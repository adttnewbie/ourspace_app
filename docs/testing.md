# Testing Strategy

> How to test OurSpace Flutter without slowing delivery.  
> **Related:** [coding-standard.md](./coding-standard.md) · [live-testing.md](./live-testing.md) · [implementation-order.md](./implementation-order.md)

---

## 1. Test pyramid

| Layer | Scope | Tools |
| --- | --- | --- |
| Unit | mappers, pure domain, failure mapping, TTL cache logic | `test` |
| Repository | remote+cache with fake data source | `test` + mocks |
| Provider / Notifier | pairing state machine, notes list mutations | `flutter_test` + `ProviderContainer` |
| Widget | Hold button, StickyNoteCard, empty/error cards | `flutter_test` |
| Golden (optional) | scrapbook cards light theme | `golden_toolkit` or matchesGoldenFile |
| Integration | pairing+home smoke on device/emulator | `integration_test` |
| Manual | two-phone pairing, store builds | [live-testing.md](./live-testing.md) |

---

## 2. Unit testing

**Must cover:**

- DTO `fromJson` / `toDomain` for notes, home, pairing paired payload.
- `AppFailure` mapping from API error codes + Dio types.
- Nickname validation helpers.
- Cache TTL expiry pure functions.

**Naming:** `methodName_condition_expectedResult`

```text
stickyNoteMapper_fromJson_mapsColorAndCanEdit
mapDioException_connectionError_returnsNetworkOffline
```

---

## 3. Repository testing

- Inject fake `NotesRemoteDataSource` + fake `CacheStore`.
- Assert: list returns domain entities; create calls remote then updates cache policy.
- Assert gallery repository **does not** write thumbnails to prefs.

---

## 4. Provider testing

```dart
final container = ProviderContainer(
  overrides: [
    notesRepositoryProvider.overrideWithValue(FakeNotesRepository()),
    connectivityProvider.overrideWith((ref) => Stream.value(true)),
  ],
);
addTearDown(container.dispose);
```

Cover:

- Pairing: idle → holding cancel → waiting → paired; timer cancelled on dispose.
- Notes: load error → retry; create success patches list.
- Session: UNAUTHORIZED clears auth state.

---

## 5. Widget testing

| Widget | Assert |
| --- | --- |
| `HoldPairingButton` | progress completes only after full duration; early release cancels |
| `StickyNoteCard` | owner sees edit/delete; non-owner does not |
| `NotesEmpty` | CTA present |
| `OfflineNotice` | text visible |
| `PageHeader` | title + action callback |

Use `pump` / `pumpAndSettle` carefully with animations; for 3s hold, use `tester.binding.setDuration` or inject short duration in tests only via parameter.

---

## 6. Integration testing

Minimal happy path (emulator):

1. Override API with mock HTTP or staging backend.
2. Cold start → pairing UI.
3. (Hard to fully pair two emulators in CI) — prefer stub paired session write + home load.
4. Notes create appears in list.

Two-device pairing remains **manual** live test.

---

## 7. Golden testing

- Optional for `ScrapbookCard` tones and `PageHeader`.
- Light theme only unless dark ships.
- Run on stable CI OS/font to avoid flake; pin font loading in tests.

---

## 8. Mocking strategy

| Prefer | Avoid |
| --- | --- |
| Fakes implementing repository interfaces | Mocking every Dio method in widgets |
| `http_mock_adapter` / custom `HttpClientAdapter` for Dio | Real network in unit tests |
| `ProviderContainer` overrides | Global singletons |

Packages: `mocktail` or `mockito` — pick one (`mocktail` recommended for null-safety ergonomics).

---

## 9. Fake repositories

```text
test/fakes/fake_notes_repository.dart
test/fakes/fake_pairing_repository.dart
test/fakes/fake_session_repository.dart
test/fixtures/notes_list.json
```

Fixtures: anonymized JSON **without** real session tokens (use `session_test_token`).

---

## 10. Test naming & layout

```text
test/
  unit/
  widget/
  features/notes/
  features/pairing/
integration_test/
  app_smoke_test.dart
```

File: `notes_list_notifier_test.dart` mirrors lib path when practical.

---

## 11. Coverage expectation

| Area | Target |
| --- | --- |
| mappers + error mapping | high (≥80% lines) |
| pairing controller | high (state transitions) |
| repositories | medium-high |
| widgets | critical interactions |
| overall project | pragmatic; not vanity 100% |

CI: `flutter test` required; coverage upload optional.

---

## 12. What not to automate in v1

- Real Apps Script quota behavior.
- Full Drive upload binary large files in CI.
- Store screenshot review.

---

## 13. Definition of done for a feature PR

- [ ] Unit tests for mappers/rules touched  
- [ ] Notifier or repository test if state logic non-trivial  
- [ ] Widget test if new interaction (hold, ownership actions)  
- [ ] Manual checklist items in live-testing for the feature  
