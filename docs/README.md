# OurSpace Docs (Flutter)

Dokumentasi ini adalah **single source of truth** untuk membangun OurSpace sebagai aplikasi **Flutter native** (Android + iOS): private scrapbook untuk dua orang, onboarding hold button, home scrapbook, dan sticky notes sebagai v1.

Gunakan urutan baca untuk AI coding agent:  
[implementation-order.md](./implementation-order.md) → [architecture.md](./architecture.md) → [coding-standard.md](./coding-standard.md) → fitur spesifik.

---

## Design

- [Flutter Design System](../design.md) — tokens, widgets, motion, a11y, layout

## Product & architecture

| Doc | Isi |
| --- | --- |
| [product-brief.md](./product-brief.md) | V1, non-goals, fitur lanjut |
| [architecture.md](./architecture.md) | Stack, folder tree, session, risiko |
| [ui-direction.md](./ui-direction.md) | Vibe UI scrapbook |
| [decision-log.md](./decision-log.md) | Alasan Riverpod/Dio/go_router/dll. |
| [implementation-order.md](./implementation-order.md) | Build dari nol, DoD per step |
| [mvp-roadmap.md](./mvp-roadmap.md) | Fase produk |

## Engineering standards

| Doc | Isi |
| --- | --- |
| [coding-standard.md](./coding-standard.md) | Dart style, layers, Riverpod, mappers |
| [routing.md](./routing.md) | go_router table, guards, redirects |
| [state-management.md](./state-management.md) | Provider map, cache, polling |
| [error-handling.md](./error-handling.md) | Taxonomy, copy ids, retry |
| [security.md](./security.md) | Tokens, logging, injection |
| [testing.md](./testing.md) | Unit/widget/integration/golden |
| [packages.md](./packages.md) | Dependencies & permissions |
| [environment.md](./environment.md) | `API_BASE_URL`, flavors, secrets |
| [accessibility.md](./accessibility.md) | TalkBack/VoiceOver, targets, motion |
| [sequence-diagrams.md](./sequence-diagrams.md) | Pairing, auth, cache, backup |
| [copy-catalog.md](./copy-catalog.md) | Microcopy + copy id |

## Domain & API

| Doc | Isi |
| --- | --- |
| [data-model.md](./data-model.md) | Spreadsheet schema + Dart paths |
| [api-contract.md](./api-contract.md) | Actions, payloads, errors |
| [api-proxy.md](./api-proxy.md) | Direct Dio vs optional proxy |
| [pairing-flow.md](./pairing-flow.md) | Hold 3s / window 30s |
| [offline.md](./offline.md) | Cache read-only offline |
| [performance.md](./performance.md) | TTL, dedupe |
| [backup.md](./backup.md) | JSON backup Drive |

## Screen specs

| Doc | Screen |
| --- | --- |
| [screen-specs/README.md](./screen-specs/README.md) | Index |
| [screen-specs/pairing.md](./screen-specs/pairing.md) | Pairing |
| [screen-specs/home.md](./screen-specs/home.md) | Home |
| [screen-specs/notes.md](./screen-specs/notes.md) | Notes |
| [screen-specs/settings.md](./screen-specs/settings.md) | Settings |

## Ship

| Doc | Isi |
| --- | --- |
| [deployment.md](./deployment.md) | Android/iOS + Apps Script |
| [production-checklist.md](./production-checklist.md) | Pre-daily use |
| [live-testing.md](./live-testing.md) | Manual E2E |

---

## Stack (canonical)

- **Client:** Flutter, Riverpod, go_router, Dio  
- **Session:** `flutter_secure_storage` (`memberId`, `sessionToken`)  
- **Cache non-secret:** memory + optional `shared_preferences`  
- **API base (client):** `API_BASE_URL` via dart-define  
- **Backend:** Google Apps Script `doPost`  
- **DB / files:** Spreadsheet + Drive (fase lanjut)  
- **UI:** Material 3 foundation + scrapbook design system  

## Prinsip

- Private by default  
- Mobile phone column (max ~480)  
- V1 = Pairing + Home + Notes  
- Bukan offline-first  
- Jangan ubah business logic / API contract tanpa update docs  

## Env naming (wajib konsisten)

| Name | Where |
| --- | --- |
| `API_BASE_URL` | Flutter Dio |
| `APPS_SCRIPT_URL` | Optional server proxy only |
