# Routing (go_router)

> Complete navigation contract for OurSpace Flutter.  
> **Related:** [architecture.md](./architecture.md) · [pairing-flow.md](./pairing-flow.md) · [state-management.md](./state-management.md) · [screen-specs/](./screen-specs/)

---

## 1. Architecture

- Package: **`go_router`**
- Single `GoRouter` instance via `routerProvider` (Riverpod) or created in `app.dart` with `ref`.
- **Shell route** hosts authenticated tab navigation (`AppShell` + bottom nav).
- **Full-screen routes** sit outside the shell: pairing, offline help, fatal error (optional).
- Navigation ownership: **notifiers / guards** decide redirects; widgets call `context.go` / `context.push` only for user-driven moves.

```text
GoRouter
├── /pairing                    (full-screen, no shell)
├── /offline                    (full-screen help, optional)
├── /error                      (full-screen fatal, optional)
└── ShellRoute (AppShell)
    ├── /                       Home
    ├── /notes                  Notes
    ├── /gallery                Gallery (later / coming soon)
    ├── /dates                  Dates (later / coming soon)
    └── /settings               Settings (“More”)
        └── /settings/...       nested settings subpages if needed
```

---

## 2. Complete route table

| Path | Name (optional) | Screen | Shell | Auth | v1 |
| --- | --- | --- | --- | --- | --- |
| `/pairing` | `pairing` | PairingScreen | no | guest / unauthenticated | yes |
| `/` | `home` | HomeScreen | yes | required | yes |
| `/notes` | `notes` | NotesScreen | yes | required | yes |
| `/gallery` | `gallery` | GalleryScreen or ComingSoon | yes | required | later |
| `/dates` | `dates` | DatesScreen or ComingSoon | yes | required | later |
| `/lists` | `lists` | ListsScreen or ComingSoon | yes | required | later |
| `/settings` | `settings` | SettingsScreen | yes | required | yes |
| `/settings/health` | — | optional sub | yes | required | optional |
| `/offline` | `offline` | OfflineHelpScreen | no | any | yes (UX) |
| `/error` | `error` | AppErrorView full | no | any | optional |

**Bottom nav mapping**

| Tab index | Label | Location |
| --- | --- | --- |
| 0 | Home | `/` |
| 1 | Notes | `/notes` |
| 2 | Gallery | `/gallery` |
| 3 | Dates | `/dates` |
| 4 | More | `/settings` |

Inactive v1 tabs: disabled **or** navigate to coming-soon content on that path — pick one UX and keep it consistent (product allows either).

---

## 3. Shell route

- `AppShell` provides: `AppCanvas`, max-width 480 column, `OfflineNotice` slot, `NavigationBar` / custom bottom nav, `SafeArea`.
- Shell `child` is the active tab page from `GoRouterState`.
- Prefer **one** navigator under shell for tabs (`StatefulShellRoute.indexedStack` recommended) so tab state is preserved when switching.
- Bottom nav uses `navigationShell.goBranch` (if indexed stack) or `context.go(path)`.

---

## 4. Nested navigation

- Settings sub-routes optional under `/settings/*` (health, danger zone).
- Feature dialogs (note editor, confirm delete) are **modals** (`showDialog` / app dialog), **not** go_router routes, unless deep-link required (v1: not required).
- Do not push full Material routes that hide bottom nav unless intentional full-screen flow.

---

## 5. Full-screen routes

| Route | Why full-screen |
| --- | --- |
| `/pairing` | Onboarding ritual; no tabs |
| `/offline` | Focused help when user opens offline help |
| `/error` | Unrecoverable UI without shell chrome |

---

## 6. Route guards & SessionGate

### Session states

| State | Meaning | Navigation |
| --- | --- | --- |
| `unknown` | App start; reading storage / resume in flight | splash / gate UI |
| `unauthenticated` | No valid local session | only `/pairing` (and offline/error) |
| `authenticated` | `session.resume` OK or just paired | shell routes |
| `temporaryError` | Network fail on resume but local session exists | stay shell with banner **or** gate retry — prefer shell + honest offline if cache rules allow |

### SessionGate

- Widget or redirect layer that:
  1. Reads secure storage for `memberId` + `sessionToken`.
  2. If missing → treat as unauthenticated.
  3. If present → call `session.resume` (cached TTL per performance docs).
  4. On success → authenticated.
  5. On `UNAUTHORIZED` → clear storage → pairing.
  6. On network error → temporary error UI with retry (do not wipe session).

---

## 7. Redirect rules

Implemented in `GoRouter.redirect` (sync function reading current session snapshot from a `Listenable` / `ValueNotifier` / Riverpod refresh listenable):

| Condition | From | Redirect to |
| --- | --- | --- |
| Unauthenticated | any shell path | `/pairing` |
| Authenticated | `/pairing` | `/` |
| Authenticated | unknown path | `/` or 404 handler |
| Unauthenticated | `/pairing` | stay |
| Session checking | — | optional holding UI without flicker |

**Do not** redirect away from `/pairing` mid-hold solely due to connectivity blip without user messaging.

---

## 8. Authentication / onboarding flow

```text
App start
  → SessionGate
      → no tokens → /pairing
      → tokens → session.resume
          → ok → /
          → UNAUTHORIZED → clear → /pairing
          → network → retry UI
Pairing success
  → write tokens
  → mark authenticated
  → context.go('/')
Settings “Hapus session lokal”
  → clear tokens + memory caches
  → context.go('/pairing')
settings.resetPairing (keep_data)
  → backend + clear local session
  → /pairing
```

---

## 9. Deep link support

| Scope | v1 policy |
| --- | --- |
| Custom URL scheme / app links | **Not required** for v1 |
| Internal path API | All navigation uses path strings above |
| Future | `/notes?id=` possible later; not in v1 contract |

If OS delivers a deep link before auth, run same redirect rules (unauthenticated → pairing).

---

## 10. Navigation ownership

| Actor | May navigate? | How |
| --- | --- | --- |
| `GoRouter.redirect` | yes | auth boundaries |
| Pairing controller (on paired) | yes | `ref.read(routerProvider).go('/')` or callback |
| Bottom nav | yes | branch/path go |
| Feature cards (SummaryCard) | yes | `context.go('/notes')` etc. |
| Repository | **never** | — |
| Dio interceptor | **never** directly | expose auth failure to session controller → redirect |

---

## 11. Page transition rules

| Transition | Usage |
| --- | --- |
| Fade / short shared axis | Default tab and shell child |
| None / instant | Prefer when reduced motion |
| Pairing → home | Brief success state **then** `go('/')` (product), not a long custom hero |
| Dialog | Fade + scale per design.md (100–180ms) |

Use `CustomTransitionPage` sparingly; avoid heavy slides that hurt perceived performance ([design.md](../design.md), [performance.md](./performance.md)).

---

## 12. Unknown & error routes

| Case | Behavior |
| --- | --- |
| Unknown path | `GoRouter` `errorBuilder` → friendly scrapbook card + CTA Home or Pairing |
| Flutter framework error | `ErrorWidget.builder` / zone → `AppErrorView` |
| API errors on a screen | **Stay on route**; show inline error card (not global `/error`) |

---

## 13. Implementation sketch (normative intent)

```dart
// lib/core/router/app_router.dart
// - routes list as table above
// - StatefulShellRoute.indexedStack for tabs
// - redirect reads SessionStatus
// - observers optional for analytics (no tokens)
```

Route path constants live in `lib/core/router/app_routes.dart`:

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

All features import `AppRoutes` — no raw magic strings in widgets.
