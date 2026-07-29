# AGENTS.md

> Entry point for **humans and AI coding agents** (Claude Code, Codex, OpenCode, Kilo, Cursor, Copilot, Grok, Gemini CLI, and similar).  
> This file orients you. It does **not** replace `docs/`.  
> **Do not invent product behavior.** Implement only what documentation specifies.

---

## 1. Project purpose

**OurSpace** is a private digital scrapbook for **exactly two people** (a couple).

| Scope | Content |
| --- | --- |
| **Client** | Flutter (Android + iOS) |
| **API** | Google Apps Script Web App (`POST` JSON) |
| **Data** | Google Spreadsheet (+ Drive for later phases) |
| **V1** | Pairing (hold 3s / window 30s) + Home + Sticky Notes + Settings session tools |
| **Not v1** | Offline-first sync, multi-couple, OAuth, chat, push, public gallery URLs — see `docs/product-brief.md` |

Personality: warm pastel scrapbook, Indonesian casual copy (`santai`), phone-column UI (~480 max width).

---

## 2. Source of truth

| Priority | Location | Role |
| --- | --- | --- |
| **1 (highest)** | `docs/**` + root `design.md` | Product, API, architecture, screens, copy, security |
| **2** | This file (`AGENTS.md`) | How to work and read docs |
| **3** | `AI_AGENT.md` | Hard rules for automated agents |
| **4** | Existing code under `lib/` | Implementation; must match docs when conflict arises |

**If code and docs disagree:** fix code to match docs, unless the user explicitly requests a docs change.

**If two docs seem to conflict:** use the priority table in §5.

---

## 3. How to start understanding the project

1. Read this file and `AI_AGENT.md`.
2. Skim `docs/README.md` (index of all docs).
3. Read product boundaries: `docs/product-brief.md`.
4. Read the **official build sequence**: `docs/implementation-order.md`.
5. Read core engineering: `docs/architecture.md` → `docs/coding-standard.md`.
6. Before a feature, open only the docs needed for that feature (see §4).

Do **not** reverse-engineer product rules from empty `lib/` placeholders when docs already define them.

---

## 4. Mandatory documentation reading order

### 4.1 Always (before any non-trivial work)

| Order | Document |
| --- | --- |
| 1 | `docs/implementation-order.md` — **official implementation sequence and DoD** |
| 2 | `docs/architecture.md` |
| 3 | `docs/coding-standard.md` |
| 4 | `docs/environment.md` |
| 5 | `AI_AGENT.md` (rules) |

### 4.2 By work type

| Work | Required docs |
| --- | --- |
| **Bootstrap / packages / env** | `packages.md`, `environment.md`, `decision-log.md` |
| **Theme / shared UI** | `design.md`, `ui-direction.md`, `accessibility.md` |
| **Routing / session gate** | `routing.md`, `pairing-flow.md`, `security.md` |
| **State / cache / offline** | `state-management.md`, `performance.md`, `offline.md` |
| **API / models** | `api-contract.md`, `data-model.md`, `api-proxy.md`, `error-handling.md` |
| **Pairing** | `pairing-flow.md`, `screen-specs/pairing.md`, `sequence-diagrams.md`, `copy-catalog.md` |
| **Home** | `screen-specs/home.md`, `ui-direction.md`, `copy-catalog.md` |
| **Notes** | `screen-specs/notes.md`, `api-contract.md`, `copy-catalog.md` |
| **Settings** | `screen-specs/settings.md`, `security.md`, `backup.md` (if backup UI) |
| **Errors / copy** | `error-handling.md`, `copy-catalog.md` |
| **Tests** | `testing.md` |
| **Release / manual QA** | `deployment.md`, `production-checklist.md`, `live-testing.md` |
| **Later features** (gallery/dates/lists) | `mvp-roadmap.md` + relevant API/data sections — only when phase allows |

### 4.3 Implementation order is authoritative

- **`docs/implementation-order.md` is the official implementation plan.**
- Build **phase by phase** and **step by step**.
- Do not skip ahead to Gallery/Dates/Lists while Phase 1–2 session/API foundations or v1 Pairing/Home/Notes are incomplete, unless the user explicitly scopes a later phase.
- Each step’s **Definition of Done** in that file must be met before claiming the step complete.

---

## 5. Conflict resolution priority

When documents disagree, apply **higher row wins**:

| Rank | Source | Wins on |
| --- | --- | --- |
| 1 | `docs/product-brief.md` | Scope, non-goals, v1 boundaries |
| 2 | `docs/api-contract.md` + `docs/data-model.md` | Request/response shapes, field names, error codes |
| 3 | `docs/pairing-flow.md` + `docs/screen-specs/*` | User-visible flows and screen behavior |
| 4 | `docs/routing.md` | Paths, guards, redirects |
| 5 | `docs/state-management.md` | Provider names, cache TTL, ownership |
| 6 | `docs/coding-standard.md` + `docs/architecture.md` | Layers, folder structure, patterns |
| 7 | `design.md` + `docs/ui-direction.md` | Visual language |
| 8 | `docs/copy-catalog.md` + `docs/error-handling.md` | User-facing strings and error UX |
| 9 | `docs/implementation-order.md` | Build sequence (not product rules) |
| 10 | `docs/decision-log.md` | Rationale only; does not override contracts |
| 11 | `AGENTS.md` / `AI_AGENT.md` | Process rules only |

**Canonical client env name:** `API_BASE_URL` (Flutter Dio).  
**`APPS_SCRIPT_URL`:** optional **server proxy only** — see `docs/environment.md`.

**Canonical stack:** Flutter · Riverpod · go_router · Dio · `flutter_secure_storage` · Material 3 foundation + scrapbook tokens.

---

## 6. Workflow before coding

1. **Restate the task** in one sentence (feature / bug / step from implementation-order).
2. **Identify phase/step** in `docs/implementation-order.md`.
3. **Open required docs** from §4.2 — do not rely on memory for API fields or copy.
4. **List files you will touch** under the feature-first tree (`lib/core`, `lib/shared`, `lib/features/...`).
5. **Check names already specified:** routes (`AppRoutes`), providers (`*Provider`), models, copy ids, API actions — **reuse, do not rename**.
6. **Confirm scope:** no new features, no extra endpoints, no redesigned UX.
7. If docs are **missing, contradictory after §5, or silent on a required decision** → **stop and ask** (see §9).
8. Only then implement.

---

## 7. Workflow while coding

- Follow `docs/coding-standard.md` (layers, naming, no Dio in widgets).
- Follow `docs/routing.md` for paths and session redirects.
- Follow `docs/state-management.md` for providers, cache, pairing poll lifecycle.
- Follow `docs/screen-specs/*` for layout, states, actions, ownership.
- Follow `design.md` for tokens (colors, spacing, radii, type) — no hard-coded scrapbook palette in features.
- Follow `docs/api-contract.md` for JSON — no invented fields.
- Follow `docs/copy-catalog.md` / `docs/error-handling.md` for user strings and error mapping.
- Follow `docs/security.md` — never log `sessionToken`; secure storage only for session secrets.
- Prefer **composition** and **existing shared widgets** over new parallel components.
- Keep changes **minimal** and local to the current implementation-order step.

---

## 8. Workflow after coding

1. Map the change to the step **DoD** in `implementation-order.md`.
2. Run **`flutter analyze`** (and format if needed).
3. Run **relevant tests** per `docs/testing.md` (or add them if the step requires).
4. Manually sanity-check loading / empty / error / offline where the screen-spec requires them.
5. If behavior **changed relative to docs**, update the **related doc** in the same change set (see `AI_AGENT.md` documentation rules). Do not “fix it later.”
6. Ensure no secrets, real production URLs, or tokens were added to the repo.
7. Summarize what was done **with doc references** (paths + section names), not only file lists.

---

## 9. When to stop and ask for clarification

**Stop and ask** if any of the following is true:

- The task requires a **feature, endpoint, route, or screen** not in docs / product-brief.
- Two docs still **conflict after** applying §5.
- A screen-spec or API contract is **silent** on something you must implement (and you would have to invent it).
- You need to **rename** a documented route, provider, model field, API field, or copy id.
- You need to **change business rules** (ownership, pairing window, soft delete, offline mutation policy, etc.).
- Security-sensitive choice is undocumented (e.g. new storage of secrets).
- Env/flavor or backend URL strategy is unclear for the user’s environment.
- The user request **explicitly contradicts** `docs/` and they have not asked to update docs.

**Do not** guess product behavior to “be helpful.”

---

## 10. Definition of done (general)

A task is done only when **all** apply:

- [ ] Matches the targeted step(s) in `docs/implementation-order.md` (or an explicit user-scoped exception)
- [ ] Matches API / data / screen / routing / state docs for that area
- [ ] Uses documented names (routes, providers, models, copy ids)
- [ ] Uses design tokens and shared patterns; no parallel design system
- [ ] Loading, empty, error, and offline behaviors match specs where applicable
- [ ] No business-logic or feature invention
- [ ] `flutter analyze` clean for touched code
- [ ] Tests added/updated when `testing.md` or the step DoD requires them
- [ ] Related docs updated **if** observable behavior or contracts changed
- [ ] No secrets or production credentials in source

---

## 11. Checklist before commit

- [ ] Diff is scoped to the task; no drive-by refactors
- [ ] No `API_BASE_URL` production secrets, tokens, or `.env` with real values committed
- [ ] No `print` / logs of `sessionToken` or raw auth headers
- [ ] Analyzer clean; dart format applied to touched Dart files
- [ ] Provider/repository/widget layering respected
- [ ] Copy uses catalog ids / documented Indonesian strings
- [ ] Docs updated if behavior changed
- [ ] Commit message describes intent (what step/feature), not only file names

**Do not commit** unless the user asked for a commit.

---

## 12. Checklist before pull request

- [ ] PR description links **docs** that define the work
- [ ] Implementation-order phase/step called out
- [ ] Screen-specs / API contract called out for UI or network work
- [ ] Test plan: analyzer + tests run + manual notes (pairing needs two devices when relevant)
- [ ] Screenshots optional but useful for UI
- [ ] No unfinished “temp” bypasses (auth skip, fake paired mode in production paths)
- [ ] `docs/live-testing.md` / `production-checklist.md` items considered if release-related
- [ ] Reviewer can verify behavior **against docs** without reading your mind

---

## 13. Standing rule: documentation-driven implementation

```text
docs (SSOT) → implementation-order step → code → verify DoD → (update docs if behavior changed)
```

- **Never** treat chat suggestions or training knowledge as overriding `docs/`.
- **Never** “improve” the product by adding unrequested features.
- **Always** implement the documented v1 scrapbook experience, not a generic CRUD app.
- **Always** keep `AGENTS.md` and `AI_AGENT.md` process-only; product truth stays in `docs/` + `design.md`.

---

## 14. Quick links

| Need | Open |
| --- | --- |
| Doc index | `docs/README.md` |
| Build sequence | `docs/implementation-order.md` |
| Agent hard rules | `AI_AGENT.md` |
| Design system | `design.md` |
| API | `docs/api-contract.md` |
| Screens | `docs/screen-specs/` |

---

*OurSpace engineering handbook — agent entry. Keep aligned with `docs/` without duplicating full specs here.*
