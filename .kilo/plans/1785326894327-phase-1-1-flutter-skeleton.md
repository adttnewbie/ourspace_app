# Plan: Phase 1 Step 1.8 — Routing + SessionGate

## Goal

Runnable `go_router` table with documented paths, shell + placeholders, redirects:

- **Unauth** → `/pairing`
- **Fake auth** → shell (`/`)
- `flutter analyze` clean

**SSOT:** `docs/implementation-order.md` §1.8 · `docs/routing.md` · `docs/pairing-flow.md` (route only) · architecture/coding-standard paths.

## Scope lock (DoD vs full SessionGate)

| Full `routing.md` SessionGate | Step 1.8 |
| --- | --- |
| Read secure storage for tokens | **Yes** (presence only) |
| Call `session.resume` | **No** — Phase **2.1** |
| SessionController / SessionRepository | **No** |
| Pairing/home/notes product UI | **No** — placeholders only |
| Bottom nav final (yellow active, 5 tabs polish) | **Minimal shell** — full chrome is **2.7** |
| OfflineNotice integration | **No** — later offline step |

**Fake auth (DoD):** tokens present in secure storage **or** test override → treat as `authenticated` without resume. Missing both keys → `unauthenticated`. Optional `unknown` holding UI: simple splash/gate scaffold while first storage read completes (no resume network).

## Documented routes only (`AppRoutes`)

From `docs/routing.md` §13 — **no inventing**:

```dart
abstract final class AppRoutes {
  static const pairing = '/pairing';
  static const home = '/';
  static const notes = '/notes';
  static const gallery = '/gallery';
  static const dates = '/dates';
  static const lists = '/lists';
  static const settings = '/settings';
  static const offline = '/offline';
  static const error = '/error';
}
```

**1.8 screen placeholders required by step output:** pairing, home, notes, settings.  
**Optional minimal stubs** (paths already in table; no product logic): gallery/dates as “segera hadir” text **or** omit branch until 2.7 — prefer **include shell branches for home/notes/settings only** if file budget tight; keep `AppRoutes` constants for gallery/dates/lists/offline/error. Full-screen `/offline` and `/error` can be simple placeholder routes without shell (routing §5) if budget allows; otherwise register in `AppRoutes` only and add routes in later step — **prefer register routes with minimal Scaffold** to match route table and avoid inventing later paths.

**Decision (locked):** Register v1 paths used in redirects + shell:

- Full-screen: `/pairing` (required); `/offline`, `/error` as minimal placeholders (documented).
- Shell: `/`, `/notes`, `/settings` (required); `/gallery`, `/dates` as minimal coming-soon placeholders so `AppRoutes` + shell map stay consistent (routing allows coming soon). Skip `/lists` shell tab if not in bottom nav map (lists is route table later feature — constant only OK without branch until product needs it).

Bottom nav map (routing §2): Home, Notes, Gallery, Dates, More → settings. For 1.8 shell: **StatefulShellRoute.indexedStack** with 5 branches, gallery/dates = coming-soon placeholder text only (no feature). Aligns with architecture without implementing 2.7 polish.

## Redirect rules (routing §7) for 1.8

| Condition | Behavior |
| --- | --- |
| `unauthenticated` + shell path | → `/pairing` |
| `authenticated` + `/pairing` | → `/` |
| `unauthenticated` + `/pairing` | stay |
| `unknown` (storage read in flight) | stay / optional gate UI; avoid flicker if possible |
| `/offline`, `/error` | allow any auth (routing table: any) |

Sync `GoRouter.redirect` reads a **session auth snapshot** (Listenable / Riverpod refresh), **not** repositories.

## Auth snapshot for 1.8 (no SessionController)

Minimal core piece — **navigation only**, not Phase 2 session product:

- Name: e.g. `SessionAuthState` enum: `unknown` | `unauthenticated` | `authenticated` (names from routing §6 — do not invent new state names).
- Source: on start, read `StorageKeys.memberId` + `StorageKeys.sessionToken` via existing `SecureStorage` / `secureStorageProvider`.
  - Both non-empty → `authenticated` (**fake auth** until 2.1 resume).
  - Else → `unauthenticated`.
- `temporaryError` **not** required until real resume (2.1).
- Test override: `Provider`/`Notifier` overridable so tests set fake auth without real storage.

**SessionGate:** either (a) redirect-only layer + optional full-screen holding widget while `unknown`, or (b) thin widget wrapping app that triggers storage probe — **redirect remains source of auth boundaries** (routing §10). Do not implement resume/clear on UNAUTHORIZED here.

## Files to add/touch (≤15)

| Path | Action |
| --- | --- |
| `pubspec.yaml` | Add `go_router: ^14.0.0` (packages.md) |
| `lib/core/router/app_routes.dart` | `AppRoutes` constants |
| `lib/core/router/app_router.dart` | `GoRouter` + redirect + shell |
| `lib/core/router/router_providers.dart` | `routerProvider` (+ auth snapshot provider if co-located) |
| `lib/core/router/session_auth.dart` or `lib/features/session/...` | Minimal auth snapshot for gate — prefer **`lib/core/router/`** or **`lib/features/session/presentation/`** placeholder; avoid SessionRepository |
| `lib/shared/widgets/app_shell.dart` | Minimal shell: max-width 480, `SafeArea`, body child, simple bottom nav (labels only) |
| `lib/features/pairing/presentation/pairing_placeholder_screen.dart` | Scaffold placeholder |
| `lib/features/home/presentation/home_placeholder_screen.dart` | Scaffold placeholder |
| `lib/features/notes/presentation/notes_placeholder_screen.dart` | Scaffold placeholder |
| `lib/features/settings/presentation/settings_placeholder_screen.dart` | Scaffold placeholder |
| `lib/features/gallery|dates/...` or one shared `coming_soon_placeholder.dart` | Optional shared coming-soon for gallery/dates |
| `lib/app.dart` | `MaterialApp.router` + `AppTheme` + router from Riverpod (`ConsumerWidget` / `UncontrolledProviderScope` pattern) |
| `lib/main.dart` | Keep `ProviderScope` + `AppConfig.ensureInitialized`; no product changes beyond router root |

**Do not** wire SharedWidgetsGallery as home anymore.

## Implementation tasks (ordered)

1. Add `go_router` dependency; `flutter pub get`.
2. `AppRoutes` exactly as routing.md.
3. Minimal session auth snapshot + provider (storage presence / override); expose `Listenable` or `refreshListenable` for `GoRouter`.
4. Placeholder screens (Scaffold + title text only; design tokens OK; no API).
5. `AppShell`: `Scaffold` + bottom `NavigationBar`/`NavigationBar` indices 0–4 → `navigationShell.goBranch`; child = shell body; max width 480.
6. `GoRouter` in `app_router.dart`:
   - `/pairing`, `/offline`, `/error` outside shell
   - `StatefulShellRoute.indexedStack` branches: home, notes, gallery, dates, settings
   - `redirect` per table above
   - `errorBuilder` friendly placeholder (routing §12) — minimal scrap card optional; Scaffold + text OK for 1.8
7. `routerProvider`; `OurSpaceApp` → `MaterialApp.router(routerConfig: ...)`.
8. Verify DoD manually or with small router test (optional): override unauth → pairing; override auth → `/`.
9. `dart format` + `flutter analyze` clean.

## Out of scope

- SessionRepository, SessionController, `session.resume`
- Pairing hold/signal/poll, notes CRUD, home data
- Final AppShell chrome (OfflineNotice slot wiring, yellow active tab polish) beyond minimal nav — **2.6/2.7**
- Real deep links
- Invented paths or renamed `AppRoutes`

## Failure modes

| Risk | Mitigation |
| --- | --- |
| Implementing full resume in gate | Storage presence only + comment/docs defer 2.1 |
| File count >15 | Share coming-soon widget; co-locate auth with router providers |
| Redirect loops | Auth on pairing → home only when authenticated; unauth never lands on shell |
| Hardcoding production auth | Fake via storage keys or provider override only |

## DoD checklist (1.8)

- [ ] `AppRoutes` matches routing.md
- [ ] Shell + pairing/home/notes/settings placeholders
- [ ] Unauth → pairing
- [ ] Fake auth → shell
- [ ] No session.resume / feature business logic
- [ ] `flutter analyze` clean

## Validation

```bash
flutter pub get
dart format lib
flutter analyze
# Manual or test:
# - no tokens → opens /pairing
# - override/fake tokens → shell home
```

## Next step after 1.8

**1.9 DI / Riverpod root** (ProviderScope overrides for tests, e.g. `apiClientProvider`) — then Phase 2.1 real session resume.
