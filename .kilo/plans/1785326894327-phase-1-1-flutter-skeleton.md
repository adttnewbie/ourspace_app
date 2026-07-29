# Plan: Phase 2 Step 2.1 — Session Resume

## Goal

End-to-end `session.resume` (DoD):

| Outcome | Behavior |
| --- | --- |
| Valid tokens | → authenticated → home shell (`/`) |
| `UNAUTHORIZED` | clear secure keys + memory → `/pairing` |
| Network failure | keep tokens → temporary error / retry UI |

**SSOT:** `docs/implementation-order.md` §2.1 · `docs/api-contract.md` Session · `docs/routing.md` §6–8 · `docs/sequence-diagrams.md` §2 · `docs/state-management.md` · `docs/security.md` §4 · `docs/error-handling.md` · `docs/performance.md` (resume TTL) · `docs/data-model.md` (Member path).

## Current state (verified)

| Piece | State |
| --- | --- |
| Phase 1 | Complete (storage, ApiClient, connectivity, router, DI) |
| `SessionAuthNotifier` (1.8) | **Fake auth**: storage presence → `authenticated` without `session.resume` |
| `lib/features/session/` | Empty (`.gitkeep` only) |
| Documented providers | `sessionControllerProvider`, `currentMemberIdProvider`, `SessionRepository` |
| `session.recover` | Documented optional — **out of scope 2.1** unless needed for DoD (not required) |

## Locked decisions

1. **Replace fake auth** with real resume: tokens present ≠ authenticated until `session.resume` succeeds (or just-paired later in 2.2).
2. **SessionAuthStatus** stays the redirect snapshot (`unknown` \| `unauthenticated` \| `authenticated`). Map controller lifecycle → this snapshot for `GoRouter.refreshListenable`.
3. **`temporaryError`**: implement as **gate/retry UI**, keep tokens (error-handling + sequence diagram). Do **not** invent home offline banner (home is 2.3). Redirect: while temporary error with tokens, do **not** force `/pairing`; allow holding on gate/retry surface (full-screen or pairing-route-adjacent — prefer dedicated gate UI on start path, not product pairing ritual).
4. **TTL**: in-memory resume result **45s** (within documented 30–60s); force-fresh flag for future Settings (2.5) can call `resume(force: true)` — optional method param only if trivial; Settings force not required this step.
5. **API fields only** from contract success `data`:
   - `member`: `{ id, nickname }`
   - `members`: `[{ id, nickname }, …]`
   - `anniversaryDate`: ISO string
6. **No** invent endpoints, storage keys, or pairing/home/notes product UI.
7. **Clear local** on UNAUTHORIZED: delete `StorageKeys.memberId` + `StorageKeys.sessionToken`; clear session memory; list caches clear can be no-op until list providers exist (document in controller: clear session memory only for 2.1).
8. **Providers named exactly:** `sessionRepositoryProvider`, `sessionControllerProvider`, `currentMemberIdProvider`.

## Domain / data (minimal)

```text
lib/features/session/
  domain/
    member.dart              # id, nickname (data-model + resume payload)
    session_snapshot.dart    # optional: member + members + anniversaryDate + fetchedAt
    session_repository.dart  # abstract: resume, clearLocal, readLocalCredentials?
  data/
    session_dto.dart         # fromJson only documented fields
    session_repository_impl.dart
  presentation/
    session_controller.dart  # Notifier / AsyncNotifier
    session_providers.dart
    session_gate_screen.dart # optional holding + temporaryError retry UI
```

**SessionRepository** (state-management §12):

| Method | Behavior |
| --- | --- |
| `resume({bool force = false})` | Read secure keys; if missing → unauthenticated outcome; else `ApiClient.postAction(action: 'session.resume', payload: {})`; map data → domain; never log token |
| `clearLocal()` | Delete both storage keys |
| (optional) `writeLocal(memberId, sessionToken)` | Needed by pairing 2.2 — **defer write API to 2.2** unless controller needs it for tests; 2.1 DoD only needs clear + resume. Prefer **not** add write until 2.2 to stay minimal. |

**SessionController** owns:

- Status: aligning routing — drive `SessionAuthNotifier` or **merge** into one source of truth.
- Preferred architecture for 2.1: **`SessionController` is owner**; `SessionAuthNotifier` either (A) becomes thin adapter that mirrors controller status for `refreshListenable`, or (B) is replaced so `routerProvider` listens to controller’s `Listenable`/ChangeNotifier bridge.
- **Recommendation (locked):** Keep `SessionAuthNotifier` as GoRouter listenable; `SessionController` updates it via:
  - `unknown` while probing/resume in flight
  - `unauthenticated` no tokens or after clear
  - `authenticated` after successful resume
  - For temporaryError: keep auth snapshot as **`authenticated` is wrong**; routing has `temporaryError` as separate nav meaning. **Problem:** current `SessionAuthStatus` enum has no `temporaryError`.

### Enum extension (docs-backed, not invent)

`docs/routing.md` §6 defines **`temporaryError`**. Step 1.8 omitted it. **2.1 must add** `SessionAuthStatus.temporaryError` to match SSOT (not a freestyle name).

Redirect updates (`resolveAuthRedirect`):

| Status | Shell path | `/pairing` | Public offline/error |
| --- | --- | --- | --- |
| `unknown` | → gate hold (see below) | stay ok | stay |
| `unauthenticated` | → `/pairing` | stay | stay |
| `authenticated` | stay | → `/` | stay |
| `temporaryError` | **prefer stay or gate**; do **not** → pairing; do **not** wipe tokens | if on pairing without product mid-hold, allow gate UI | stay |

**Gate UI location:** While `unknown` or `temporaryError`, avoid flashing shell. Options:

1. Full-screen route only via redirect to a holding widget **without new path** — use `redirect` null + replace initial builder; messy.
2. **Session gate as pairing-path overlay / replace PairingPlaceholder when status unknown+hasTokens or temporaryError** — couples pairing.
3. **Minimal full-screen builders inside router** when status is `unknown`/`temporaryError`: e.g. still land on `/pairing` path but **SessionGateScreen** shown when tokens exist and resume pending/failed network (pairing product is 2.2). Cleaner: introduce **no new AppRoutes path** (do not invent); show `SessionGateScreen` as the widget for cold-start holding by making `GoRoute` pairing builder **or** home builder switch on status.

**Locked UX for 2.1:**

- No tokens → `PairingPlaceholderScreen` at `/pairing` (unchanged product-wise).
- Tokens + resume in flight (`unknown`) → `SessionGateScreen` (checking / skeleton) — can be builder when `matchedLocation` would be shell or pairing: **redirect `unknown` with tokens to stay on a single surface**: keep redirect sending non-public to pairing **only if unauthenticated**; if `unknown`, **do not** send to pairing if that flashes wrong UI — instead stay and show gate.

Refine `resolveAuthRedirect` for 2.1:

```text
unknown:
  - allow /pairing, /offline, /error
  - shell paths → null OR optional hold (router shows gate via shell child) 
  - simplest: shell → stay null; MaterialApp shows shell only if authenticated; 
    better: unknown never enters shell — redirect shell to /pairing only when unauthenticated;
    when unknown, redirect everything except public to a holding path.

```

**Conflict:** There is no documented `/gate` path. Holding UI is “splash / gate UI” without a path name.

**Implementation approach (minimal, docs-aligned):**

- `OurSpaceApp` or router `builder` / top-level redirect:
  - If `unknown` → don’t navigate shell; `redirect` returns `null` only for public; for shell returns **null** and **errorBuilder** no — use **`GoRouter` redirect: unknown + non-public → `/pairing`** and **pairing route builder** checks controller: if tokens resolving or temporaryError → `SessionGateScreen`, else `PairingPlaceholderScreen`.
- `temporaryError` → same: stay `/pairing` surface with `SessionGateScreen(retry:)` (tokens kept). Slightly odd path name but **no invented route**; pairing path is already “unauthenticated area”. Alternative per routing “prefer shell + offline” needs home — deferred.

**Locked:** Gate/retry on `/pairing` builder when `unknown` (with tokens) or `temporaryError`; true empty pairing placeholder only when `unauthenticated`.

## State machine (controller)

```text
App start
  → status = unknown
  → read storage
      → missing keys → unauthenticated → SessionAuth unauthenticated
      → keys present → call repository.resume()
          → ok → store snapshot memory + fetchedAt
                 → authenticated → SessionAuth authenticated → redirect home
          → ApiFailure UNAUTHORIZED → clearLocal → unauthenticated → pairing
          → NetworkFailure → temporaryError (keep keys) → SessionAuth temporaryError
                             → SessionGateScreen + retry → resume(force: true)

resume() with TTL:
  if !force && snapshot fresh (<45s) && authenticated → no network

retry (user):
  → unknown or temporaryError → resume(force: true)
```

Do **not** auto-retry loops beyond optional single safe-read policy in error-handling (optional 1× for timeout) — **manual retry button is required** for DoD “network → retry”.

## Integration points (existing)

| Existing | Change |
| --- | --- |
| `session_auth.dart` | Add `temporaryError`; stop auto-`authenticated` on storage presence; expose `setStatus` for controller |
| `sessionAuthNotifierProvider` | Stop calling `resolveFromStorage` alone as final auth; controller owns bootstrap |
| `app_router.dart` / `resolveAuthRedirect` | Handle `temporaryError` (no wipe, no force pairing if tokens held — stay public/pairing gate) |
| `router_providers.dart` | Ensure controller starts resume on app load (side effect in provider or `OurSpaceApp` `ref.listen` once) |
| `apiClientProvider` | Used by SessionRepositoryImpl only |
| `secureStorageProvider` | Read/clear only documented keys |
| Auth interceptor | Unchanged (still reads storage) |

**Bootstrap:** `sessionControllerProvider` construction triggers `bootstrap()` / `resume()` once — not duplicate ProviderScope.

## Tests (required for DoD confidence)

| Test | Assert |
| --- | --- |
| Repository resume success | Maps DTO fields; calls `session.resume` |
| Repository UNAUTHORIZED | Throws/propagates `ApiFailure(code: UNAUTHORIZED)` |
| Controller valid tokens | → authenticated; auth notifier authenticated |
| Controller UNAUTHORIZED | clearLocal called; unauthenticated |
| Controller network | temporaryError; keys **not** deleted |
| `resolveAuthRedirect` | temporaryError does not send to wipe path; unauthenticated shell → pairing; authenticated pairing → home |

Use `FakeSecureStorage`, override `apiClientProvider` / fake repository (1.9 pattern).

## File budget (≤15)

| File | Action |
| --- | --- |
| `lib/features/session/domain/member.dart` | Create |
| `lib/features/session/domain/session_snapshot.dart` | Create (resume result) |
| `lib/features/session/domain/session_repository.dart` | Create abstract |
| `lib/features/session/data/session_dto.dart` | Create |
| `lib/features/session/data/session_repository_impl.dart` | Create |
| `lib/features/session/presentation/session_controller.dart` | Create |
| `lib/features/session/presentation/session_providers.dart` | Create |
| `lib/features/session/presentation/session_gate_screen.dart` | Create (checking + retry) |
| `lib/core/router/session_auth.dart` | Update enum + wiring |
| `lib/core/router/app_router.dart` | Redirect + pairing builder gate |
| `lib/core/router/router_providers.dart` | Wire controller bootstrap if needed |
| `lib/features/pairing/presentation/pairing_placeholder_screen.dart` | Maybe thin — gate selection in router instead |
| `test/features/session/session_repository_test.dart` | Create |
| `test/features/session/session_controller_test.dart` | Create |
| `test/core/router/app_router_test.dart` | Update for temporaryError / real flow |

If over budget: merge DTO into repository_impl file; merge providers into controller file.

## Out of scope

- Pairing hold/signal/poll/write session on pair (2.2)
- Home/notes/settings product
- `session.recover`
- OfflineNotice / mutation queues
- List cache clearing beyond session memory
- Bottom nav polish (2.7)
- FailureMapper UI copy catalog wiring beyond gate retry label (use documented copy id text from copy-catalog only if gate needs string — `shared.retry` / error auth; **use catalog strings only**, no invent)

Gate copy (if needed): from `docs/copy-catalog.md` — `shared.retry`, `error.unauthorized` path is navigation not banner; network: `error.timeout` / network offline strings if present. Read catalog at implement time; if missing for gate title use minimal neutral from catalog only.

## Failure modes

| Risk | Mitigation |
| --- | --- |
| Double source of auth truth | Controller writes SessionAuthNotifier only |
| Authenticated without resume (1.8 leftover) | Remove presence→authenticated shortcut |
| Clearing tokens on network error | Explicit tests; only UNAUTHORIZED/clearLocal |
| Invented JSON fields | Hand-parse only contract keys; ignore extras |
| temporaryError redirect loop | Unit-test resolveAuthRedirect matrix |
| File count | Merge small files |

## Implementation order

1. Domain Member + SessionSnapshot + abstract SessionRepository.
2. DTO + SessionRepositoryImpl (`session.resume` + clearLocal).
3. Extend `SessionAuthStatus.temporaryError`; fix redirects.
4. SessionController + providers; bootstrap resume; TTL.
5. SessionGateScreen (loading + retry); wire pairing route builder.
6. Tests + analyzer.
7. Update router tests for new enum behavior.

## Validation

```bash
dart format lib/features/session lib/core/router test/features/session test/core/router
flutter analyze
flutter test test/features/session test/core/router
```

Manual (optional): run with dart-define + mock/fake storage states.

## DoD checklist (2.1)

- [ ] `SessionRepository` + `SessionController` (`sessionControllerProvider`)
- [ ] Valid tokens + resume OK → home
- [ ] `UNAUTHORIZED` → clear storage → pairing
- [ ] Network → keep tokens + retry UI
- [ ] No pairing/home/notes product features
- [ ] No invented API fields
- [ ] `flutter analyze` clean
- [ ] Unit tests cover three DoD branches

## Next step after 2.1

**2.2 Pairing** (hold ritual, secure write, navigate home) — uses `sessionControllerProvider` to mark authenticated after pair.
