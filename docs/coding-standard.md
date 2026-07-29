# Coding Standard (Flutter / Dart)

> Single source of truth for how OurSpace Flutter code is written.  
> Aligns with [Effective Dart](https://dart.dev/effective-dart), Flutter style, Material 3 theming, and this repo’s feature-first architecture.

**Related:** [architecture.md](./architecture.md) · [state-management.md](./state-management.md) · [packages.md](./packages.md) · [design.md](../design.md)

---

## 1. Dart naming convention

| Kind | Convention | Example |
| --- | --- | --- |
| Files / directories | `snake_case` | `sticky_note_card.dart`, `note_colors.dart` |
| Classes, enums, typedefs | `UpperCamelCase` | `StickyNote`, `ScrapTone`, `NotesRepository` |
| Members, variables, parameters | `lowerCamelCase` | `memberId`, `daysTogether` |
| Constants | `lowerCamelCase` or `SCREAMING_SNAKE` only for true compile-time env keys mirrored from define | `AppSpacing.md`, `kDefaultPairingHold` |
| Private library members | leading `_` | `_pollTimer`, `_mapDto` |
| Providers | `lowerCamelCase` + suffix | `notesListProvider`, `sessionControllerProvider` |
| Extensions | `UpperCamelCase` on type | `extension StickyNoteX on StickyNote` |
| Test files | `*_test.dart` next to or under `test/` mirroring lib | `notes_repository_test.dart` |

**Do not** use Hungarian prefixes (`strName`, `mMember`). Prefer clear nouns.

---

## 2. Folder structure (feature-first)

```text
lib/
  main.dart
  app.dart                          # MaterialApp.router + ProviderScope
  core/
    config/                         # env, flavors, constants
    theme/                          # AppColors, AppTheme, tokens
    network/                        # Dio client, interceptors, api_client
    storage/                        # secure_storage, cache_store
    error/                          # AppException, Result, mappers
    router/                         # go_router, routes, guards
    connectivity/                   # online status
  shared/
    widgets/                        # ScrapbookCard, AppButton, skeletons, …
    extensions/
    utils/
  features/
    pairing/
      data/                         # dto, data_source, repository_impl
      domain/                       # entities, repository interface, use cases (optional)
      presentation/                 # screens, widgets, providers
    home/
      data/
      domain/
      presentation/
    notes/
      data/
      domain/
      presentation/
    gallery/                        # later
    dates/                          # later
    lists/                          # later
    settings/
      data/
      domain/
      presentation/
    session/                        # session resume / gate shared with auth-like flow
```

**Rules:**

- Features own their screens, providers, and repositories.
- `core/` has **no** imports from `features/`.
- `shared/` has **no** feature business rules; only reusable UI/utils.
- `features/a` must not import `features/b` presentation. Cross-feature use goes through domain interfaces in `core` or shared contracts — prefer calling repositories via providers registered at app level.
- Prefer thin `domain/` entities even if use-case classes are optional for v1.

---

## 3. Clean architecture rules

| Layer | Responsibility | May depend on |
| --- | --- | --- |
| **Presentation** | Widgets, Riverpod notifiers, UI state | domain, shared, core |
| **Domain** | Entities, repository interfaces, pure rules | Dart only (no Flutter, no Dio) |
| **Data** | DTOs, Dio calls, mappers, repository impl, cache | domain, core/network, core/storage |

**Dependency direction:** `presentation → domain ← data`  
**Never:** widgets call Dio directly; repositories return UI widgets; domain imports `package:flutter`.

---

## 4. Repository pattern

```text
NotesRepository (abstract, domain)
  ↑ implemented by
NotesRepositoryImpl (data)
  → NotesRemoteDataSource (Dio actions)
  → NotesLocalCache (TTL store)
```

- One repository per aggregate/feature list where practical (`NotesRepository`, `HomeRepository`, `PairingRepository`, `SessionRepository`).
- Repositories expose domain types, **not** raw `Response` / `Map`.
- Mutations return updated entity or `void` + rely on invalidation (see state-management).
- No `BuildContext` in repositories.

---

## 5. Riverpod conventions

| Rule | Detail |
| --- | --- |
| Package | `flutter_riverpod` (or `hooks_riverpod` only if hooks already adopted — default: **no hooks required**) |
| Codegen | Optional `riverpod_annotation`; if not used, hand-written providers must still follow naming |
| Provider types | `Provider` for pure deps; `Notifier` / `AsyncNotifier` for state; `FutureProvider` only for simple one-shot reads |
| UI | `ConsumerWidget` / `ConsumerStatefulWidget`; avoid `ref.watch` in constructors |
| Selectivity | `ref.watch(provider.select((s) => s.field))` to limit rebuilds |
| Side effects | `ref.listen` for navigation, toasts, one-shot errors — not inside `build` without listen |
| Dispose | Cancel timers, Dio cancel tokens, poll loops in `ref.onDispose` |

### Provider naming

| Pattern | Example |
| --- | --- |
| Dependency | `dioProvider`, `secureStorageProvider`, `apiClientProvider` |
| Repository | `notesRepositoryProvider` |
| Controller / notifier | `pairingControllerProvider`, `notesListProvider` |
| Derived | `isOnlineProvider`, `currentMemberIdProvider` |

Suffix always `Provider`. Controllers end with `Controller` in the class name.

---

## 6. AsyncValue handling

```dart
// Preferred UI pattern
asyncNotes.when(
  loading: () => const NotesSkeleton(),
  error: (e, _) => NotesErrorCard(error: e, onRetry: () => ref.invalidate(notesListProvider)),
  data: (notes) => notes.isEmpty ? const NotesEmpty() : NotesList(notes: notes),
);
```

- Do not show raw `e.toString()` to users — map via error-handling.
- Stale-while-revalidate: show previous data when available (see state-management).
- `AsyncLoading` with previous value → status pill “Lagi nyegerin data...”, not full-screen skeleton.

---

## 7. Widget composition rules

- Prefer many small private widgets in the same file or `widgets/` subfolder over one 500-line `build`.
- `const` constructors everywhere possible.
- Extract repeated scrapbook chrome to `shared/widgets`.
- Max practical `build` depth: keep readable; extract when nesting > ~4–5 visual sections.
- No network/repository calls inside `StatelessWidget.build` — only `ref.watch` / pass data down.

---

## 8. No business logic inside widgets

**Forbidden in widgets:**

- Computing ownership beyond `note.canEdit` / comparing ids already prepared by domain
- Assembling API payloads
- Parsing ISO dates for business rules (use domain/utils)
- Starting pairing poll timers without a notifier

**Allowed in widgets:**

- Layout, animation controllers for pure UI (hold progress may live in a dedicated widget + callback to notifier)
- Formatting for display via `intl` helpers
- Calling `ref.read(controller.notifier).onSubmit()`

---

## 9. Extension method convention

- Name: `TypeNameX` or feature-specific `StickyNoteUiX`.
- Place in `shared/extensions/` or feature `presentation/` if UI-only.
- Do not hide expensive work or I/O in extensions.
- Keep pure and total when possible.

---

## 10. Model / DTO / mapper naming

| Kind | Naming | Location |
| --- | --- | --- |
| Domain entity | `StickyNote`, `Member`, `HomeSnapshot` | `features/*/domain/` |
| DTO | `StickyNoteDto`, `HomeGetResponseDto` | `features/*/data/dto/` |
| Request body | `CreateStickyNoteRequest` | `features/*/data/dto/` |
| Mapper | `StickyNoteMapper` or top-level `StickyNote toDomain()` on DTO | `features/*/data/mapper/` |

- DTOs know JSON keys; domain does not.
- Prefer `freezed` + `json_serializable` **or** hand-written `fromJson` — pick one style per repo and stay consistent (recommended: freezed for entities that need copyWith).
- `canEdit` may be server-provided; client may also derive `createdBy == currentMemberId` as defense in depth for UI only — server remains authority.

---

## 11. Error / Result pattern

```dart
// core/error/
sealed class AppFailure { … }
class NetworkFailure extends AppFailure { … }
class ApiFailure extends AppFailure { final String code; … }
class ValidationFailure extends AppFailure { … }

typedef Result<T> = ({T? data, AppFailure? failure}); // or freezed Result / Either
```

- Repositories throw `AppFailure` **or** return `Result` — **one** convention for the whole app (recommended: throw `AppFailure`, catch at notifier boundary into `AsyncError` / UI state).
- Never leak `DioException` to UI.
- See [error-handling.md](./error-handling.md).

---

## 12. Lint & formatting

- Enable `flutter_lints` (or `very_good_analysis` if team adopts — default documented: **flutter_lints** + project extras).
- `dart format .` before commit.
- Prefer trailing commas for good formatting.
- `analysis_options.yaml` should forbid `print` in production paths if possible; use a tiny `AppLog` that redacts secrets.
- No `dynamic` in public APIs without strong reason.
- Avoid `// ignore:` unless justified in comment.

---

## 13. Documentation comments

- Public classes/methods in `domain/` and `core/`: brief `///` dartdoc.
- Do not narrate obvious code (`/// Returns the id` on `get id`).
- Document non-obvious invariants (pairing 30s window, soft delete, ownership).
- Screen-level behavior belongs in docs/screen-specs, not essay comments in widgets.

---

## 14. File organization

1. Imports: dart → package → relative; separate with blank lines.
2. Order in file: exports (rare) → main type → private helpers.
3. One primary public type per file when practical.
4. Keep provider + notifier in `presentation/*_providers.dart` or next to screen if small.
5. Barrel files (`features/notes/notes.dart`) optional; avoid circular barrels.

---

## 15. Reusable widget guidelines

| Rule | Detail |
| --- | --- |
| Location | `lib/shared/widgets/` if used by 2+ features |
| Theming | Only `Theme.of(context)` / `AppColors` extensions — no raw hex |
| A11y | Semantics labels for icon-only; exclude decorative |
| API | Prefer composition (`child`, `tone`) over huge enum matrices |
| Design system | Match [design.md](../design.md) — ScrapbookCard, PageHeader, etc. |

---

## 16. Material 3

- Use M3 `ThemeData` (`useMaterial3: true`) as foundation.
- **Visual language** is scrapbook custom chrome, not default M3 cards/FABs.
- Map tokens into `ColorScheme` + `ThemeExtension` for scrap accents.
- Prefer themed `FilledButton` etc. wrapped by `AppButton` rather than unstyled `Material`.

---

## 17. Git / PR hygiene (code)

- No secrets, no real `API_BASE_URL` production values in source.
- Do not commit `sessionToken` fixtures with real tokens.
- Feature PRs should note which docs section they implement.

---

## 18. Quick checklist (PR)

- [ ] Feature-first path correct; no upward illegal imports  
- [ ] No Dio/storage in widgets  
- [ ] Providers named `*Provider`; dispose timers  
- [ ] Errors mapped to `AppFailure`  
- [ ] UI uses design tokens  
- [ ] `dart format` + analyzer clean  
- [ ] Tests for repository/mapper when non-trivial  
