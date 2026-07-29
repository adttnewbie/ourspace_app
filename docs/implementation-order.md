# Implementation order (Flutter from zero)

> Ordered build plan for humans and AI coding agents.  
> Preserves product scope: **v1 = Pairing + Home + Sticky Notes (+ Settings session tools)**.  
> **Related:** [mvp-roadmap.md](./mvp-roadmap.md) · [coding-standard.md](./coding-standard.md) · [architecture.md](./architecture.md)

Each step lists **goal**, **depends on**, **output**, **definition of done (DoD)**.

---

## Phase 0 — Docs freeze

| | |
| --- | --- |
| **Goal** | Team/agent uses this docs set as SSOT |
| **Depends** | — |
| **Output** | docs/* + design.md linked from README |
| **DoD** | No conflicting `API_BASE_URL` naming; routes and providers named consistently |

---

## Phase 1 — Project bootstrap

### 1.1 Flutter project skeleton

| | |
| --- | --- |
| **Goal** | Runnable app shell |
| **Depends** | Flutter SDK |
| **Output** | `lib/main.dart`, `app.dart`, `pubspec.yaml` deps from [packages.md](./packages.md) |
| **DoD** | `flutter run` shows placeholder; `flutter analyze` clean |

### 1.2 Core config & env

| | |
| --- | --- |
| **Goal** | `AppConfig` reads `API_BASE_URL` |
| **Depends** | 1.1 |
| **Output** | `lib/core/config/app_config.dart`, example env file |
| **DoD** | Missing URL fails clearly in debug |

### 1.3 Theme / design tokens

| | |
| --- | --- |
| **Goal** | Scrapbook ThemeData |
| **Depends** | 1.1 |
| **Output** | `lib/core/theme/*` per design.md |
| **DoD** | Demo screen shows ScrapbookCard tones, typography |

### 1.4 Shared widgets

| | |
| --- | --- |
| **Goal** | Reusable chrome |
| **Depends** | 1.3 |
| **Output** | ScrapbookCard, AppButton, AppTextField, PageHeader, skeletons, OfflineNotice |
| **DoD** | Widget tests smoke for button/card optional; gallery of widgets in dev |

### 1.5 Storage

| | |
| --- | --- |
| **Goal** | Session + cache stores |
| **Depends** | 1.1 |
| **Output** | secure storage wrapper, cache store, `StorageKeys` |
| **DoD** | Unit test write/read/delete session keys with fake |

### 1.6 Network

| | |
| --- | --- |
| **Goal** | Dio ApiClient POST action JSON |
| **Depends** | 1.2, 1.5 |
| **Output** | `dioProvider`, interceptors, `AppFailure` mapping |
| **DoD** | Mock adapter test for ok/error JSON; no token logs |

### 1.7 Connectivity

| | |
| --- | --- |
| **Goal** | `isOnlineProvider` |
| **Depends** | 1.1 |
| **Output** | connectivity repository/provider |
| **DoD** | Offline guard callable from notifiers |

### 1.8 Routing + SessionGate

| | |
| --- | --- |
| **Goal** | go_router table + redirects |
| **Depends** | 1.3–1.5 |
| **Output** | `AppRoutes`, shell, pairing/home/notes/settings placeholders |
| **DoD** | Unauth → pairing; fake auth → shell; analyzer clean |

### 1.9 DI / Riverpod root

| | |
| --- | --- |
| **Goal** | `ProviderScope` + overrides for tests |
| **Depends** | 1.1 |
| **Output** | `main.dart` bootstrap |
| **DoD** | Test can override `apiClientProvider` |

---

## Phase 2 — Product features v1

### 2.1 Session resume

| | |
| --- | --- |
| **Goal** | `session.resume` end-to-end |
| **Depends** | Phase 1 |
| **Output** | SessionRepository, SessionController |
| **DoD** | Valid tokens → home; UNAUTHORIZED → clear → pairing; network → retry |

### 2.2 Pairing

| | |
| --- | --- |
| **Goal** | Hold ritual two devices |
| **Depends** | 2.1, live API or mock |
| **Output** | PairingScreen + controller + repository |
| **DoD** | Matches pairing-flow + screen-specs; poll dispose; secure write; navigate home |

### 2.3 Home

| | |
| --- | --- |
| **Goal** | Personal home |
| **Depends** | 2.1 |
| **Output** | HomeRepository, HomeScreen, cache TTL |
| **DoD** | Greeting, daysTogether, hide empty today; skeleton/error/offline |

### 2.4 Notes CRUD

| | |
| --- | --- |
| **Goal** | Sticky notes full loop |
| **Depends** | 2.1 |
| **Output** | Notes feature data/domain/presentation |
| **DoD** | list/create/update/delete; ownership UI; soft delete; invalidate home |

### 2.5 Settings (v1 tools)

| | |
| --- | --- |
| **Goal** | Diagnostics + clear session |
| **Depends** | 2.1 |
| **Output** | SettingsScreen actions |
| **DoD** | Cek koneksi/session; hapus session lokal; no token display |

### 2.6 Offline UX polish

| | |
| --- | --- |
| **Goal** | Honest offline |
| **Depends** | 2.3–2.4, connectivity |
| **Output** | OfflineNotice integration, mutation blocks |
| **DoD** | Matches offline.md |

### 2.7 AppShell bottom nav

| | |
| --- | --- |
| **Goal** | 5 tabs; later tabs coming soon |
| **Depends** | 1.8 |
| **Output** | Nav + coming soon routes |
| **DoD** | Content not underlap nav; active yellow tab |

---

## Phase 3 — Quality & release

### 3.1 Testing pack

| | |
| --- | --- |
| **Goal** | Confidence bar from testing.md |
| **Depends** | Phase 2 |
| **Output** | unit/widget/integration tests |
| **DoD** | CI runs `flutter test`; pairing/notes happy paths covered |

### 3.2 Performance pass

| | |
| --- | --- |
| **Goal** | TTL cache + dedupe |
| **Depends** | Phase 2 |
| **Output** | cache store wiring, in-flight dedupe |
| **DoD** | Manual checks in performance.md |

### 3.3 Security pass

| | |
| --- | --- |
| **Goal** | No secret leakage |
| **Depends** | Phase 2 |
| **Output** | log audit, formula-safe inputs if needed |
| **DoD** | security.md checklist |

### 3.4 Store builds

| | |
| --- | --- |
| **Goal** | Android/iOS release |
| **Depends** | 3.1–3.3, backend production |
| **Output** | AAB/IPA with prod `API_BASE_URL` |
| **DoD** | production-checklist + live-testing smoke on two devices |

---

## Phase 4 — Post-v1 features (ordered)

1. Date Plans (list + calendar tabs)  
2. Gallery (picker permissions, 3 MB, memory thumb cache)  
3. Shared Lists  
4. Backup health + manual backup from Settings  
5. Optional SSL pinning / proxy  

Each feature: data model + API contract + screen spec extension + tests before next.

---

## Agent execution rules

1. Implement **one step** fully (DoD) before the next.  
2. Do not invent API fields beyond [api-contract.md](./api-contract.md).  
3. Do not add offline mutation queues (D5).  
4. Prefer updating docs if code reveals a doc bug — do not silently diverge.  
5. Run analyzer after each step.  
