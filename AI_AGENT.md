# AI_AGENT.md

> **Rulebook for AI coding agents** working on OurSpace.  
> Humans may use it too.  
> Product and technical truth live in **`docs/`** and **`design.md`**. This file only constrains *how* you implement.  
> Compatible with Claude Code, Codex, OpenCode, Kilo, Cursor, Copilot, Grok, Gemini CLI, and similar tools.

**Companion:** [AGENTS.md](./AGENTS.md) (reading order, workflows, DoD, when to stop).

---

## Source of truth

1. **`docs/**`** is the primary reference for product, architecture, API, state, screens, copy, security, testing, and release.
2. **`design.md`** is the primary reference for visual design tokens, components, motion, and layout.
3. **`docs/implementation-order.md`** is the **official implementation sequence** and per-step Definition of Done.
4. **`AGENTS.md`** defines reading order, conflict priority, and process checklists.
5. **This file (`AI_AGENT.md`)** defines non-negotiable agent rules (never/always, quality gates).

**Conflict handling:** follow `AGENTS.md` §5. Do not invent a third interpretation.

**Code vs docs:** change code to match docs. Update docs only when the user requests a behavior/contract change or when you must record an approved behavior change in the same task.

**Assumptions:** do not invent business logic, features, endpoints, routes, or UX. If docs are ambiguous after conflict rules → **stop and ask**.

---

## Implementation rules

- Implement **only** the current step(s) from `docs/implementation-order.md` (or an explicit user scope).
- V1 surface area: **Pairing + Home + Sticky Notes + Settings (session/diagnostics as specified)**. Do not build Gallery/Dates/Lists/Backup UI early unless the user scopes that phase.
- Stack is fixed: **Flutter · Riverpod · go_router · Dio · flutter_secure_storage · Material 3 foundation + scrapbook theme**.
- Client HTTP base URL: **`API_BASE_URL`** (`docs/environment.md`). Do not reintroduce web-era env names.
- Feature-first layout under `lib/` per `docs/architecture.md` and `docs/coding-standard.md`.
- Prefer smallest diff that satisfies the step DoD.
- No auth bypasses, no fake “always paired” production paths, no committed secrets.

---

## Coding rules

Follow **`docs/coding-standard.md`** in full. Summary agents must not violate:

- Dart/`Effective Dart` naming: `snake_case` files, `UpperCamelCase` types, `lowerCamelCase` members.
- Layers: `presentation → domain ← data`; **`core/` must not import `features/`**.
- **No business logic in widgets**; no Dio/storage calls in `build`.
- Repository pattern; domain types out of repositories; DTOs stay in `data/`.
- Riverpod: names end with `Provider`; dispose timers/subscriptions; prefer `AsyncValue.when` / documented loading patterns.
- One error strategy (`AppFailure` / documented Result) — never leak raw `DioException` to UI.
- `dart format` + project lints; avoid unjustified `// ignore:`.
- Public domain/core APIs get brief dartdoc only when non-obvious.

---

## Architecture rules

Follow **`docs/architecture.md`**:

- Flutter client → **HTTPS POST JSON only** → Apps Script `doPost` → Spreadsheet (+ Drive later).
- Session: `memberId` + `sessionToken` in **secure storage** only.
- Ownership: only creator edits/deletes; server is authority (`FORBIDDEN`).
- Pairing: hold **3s**, poll status **1–2s** while waiting, window **30s**, `anniversaryDate` from **backend**.
- Not offline-first; cache is UX only (`docs/offline.md`, `docs/performance.md`).
- Do not add new backend systems or replace Spreadsheet/Apps Script unless docs/user say so.

---

## Navigation rules

Follow **`docs/routing.md`**:

- Use **`go_router`** and documented paths (`AppRoutes` / path table).
- Shell tabs: Home `/`, Notes `/notes`, Gallery `/gallery`, Dates `/dates`, More `/settings`.
- Full-screen: `/pairing`, `/offline` (and optional `/error`).
- **SessionGate / redirect**: unauthenticated → `/pairing`; authenticated on `/pairing` → `/`.
- Repositories and Dio interceptors **must not** navigate directly; session layer owns auth redirects.
- Note editors / confirms are **dialogs**, not new routes (v1).
- **Never rename or invent routes** without docs + user approval.

---

## State management rules

Follow **`docs/state-management.md`**:

- One owner per concern (session, pairing controller, home, notes list, etc.).
- Use **documented provider names** (`sessionControllerProvider`, `notesListProvider`, …).
- Cache TTLs and stores as documented (gallery **memory-only**; never cache `sessionToken` in prefs).
- **No optimistic mutations** by default; wait for backend success then patch lists.
- **No offline mutation queue**; block mutations when offline with documented copy.
- Pairing poll timer: start only in waiting; **cancel on dispose**.
- Invalidate/update related providers after successful mutations (e.g. notes → home).
- **Never duplicate** parallel sources of truth for the same list/session.

---

## UI rules

Follow **`docs/ui-direction.md`**, **`docs/screen-specs/*`**, and **`design.md`**:

- Scrapbook pastel multi-accent; Indonesian casual copy; no corporate SaaS chrome.
- Phone column max ~**480**; bottom nav clearance; SafeArea.
- Implement **loading / empty / error / offline** as each screen-spec requires.
- Reuse shared scrapbook widgets (`ScrapbookCard`, `PageHeader`, skeletons, etc.) from the design system targets.
- Pairing hold button and progress must match pairing screen-spec + pairing-flow.
- Home: hide “today” section when empty; greeting + days together from API data.
- Notes: short body, color presets, author nickname, edit/delete **owner only**.
- **Never freestyle a different information architecture** than screen-specs.

---

## API rules

Follow **`docs/api-contract.md`**, **`docs/data-model.md`**, **`docs/api-proxy.md`**:

- Every call: `POST` JSON `{ action, memberId, sessionToken, payload }`.
- Pairing may send empty member/session before paired.
- Success: `{ ok: true, data }`; failure: `{ ok: false, error: { code, message } }`.
- Map codes via **`docs/error-handling.md`** (including client `NETWORK_OFFLINE`).
- **Do not** use GET for private data; **do not** invent actions or fields.
- Dio interceptor attaches session after pairing; pairing endpoints as documented.
- Soft delete for notes; gallery rules (max 3MB, caption/takenAt, private thumbnails) only when building that phase.
- Models/field names stay aligned with contract and data-model paths.

---

## Design rules

Follow **`design.md`** (and ui-direction for product vibe):

- Colors, spacing (4px grid), radii, shadows, type **from tokens** (`AppColors`, `AppSpacing`, …) — **no hard-coded feature hex/spacing/type scales**.
- Scrap tones: pink / mint / yellow / blue / lavender as documented.
- Motion: short ease-out; honor reduced motion; pairing hold 3s linear progress.
- One icon family as documented; icon-only controls need Indonesian semantics labels.
- Material 3 is the **foundation**; visual language is **custom scrapbook**, not default M3 dense admin UI.

---

## Testing rules

Follow **`docs/testing.md`**:

- Mirror `lib/` under `test/`; names `should_...`.
- Fake repositories for widget/provider tests; mock Dio only at API client boundary when needed.
- Cover mappers, ownership UI (`canEdit`), pairing timer cancel, cache TTL behavior where feasible.
- Do not assert on real network or real secure storage values in unit tests.
- Golden tests optional and explicit; do not expand scope just to add goldens.
- Meet step DoD test expectations in `implementation-order.md`.

---

## Accessibility rules

Follow **`docs/accessibility.md`** (+ design a11y sections):

- Min touch targets (prefer 48dp; hold control large).
- Semantics on icon-only actions; decorative tape/icons excluded.
- Status not by color alone; contrast on scrap tones.
- Respect system text scaling within scrapbook layout constraints.
- Respect reduced / disable animations.
- Bottom nav and primary actions not obscured; SafeArea respected.

---

## Security rules

Follow **`docs/security.md`**:

- Session secrets **only** in `flutter_secure_storage` with documented keys.
- **Never** log or commit `sessionToken`, raw auth headers, or production `API_BASE_URL` secrets.
- Clear session on logout/reset/UNAUTHORIZED as documented.
- No mutation queue that stores secrets; no analytics of PII/tokens.
- Treat user text as data (Sheets formula injection awareness on backend; client still must not “fix” malicious strings into executable contexts).
- HTTPS only; pinning optional later — do not half-implement pinning without docs.
- Gallery thumbnails: no public Drive URLs; memory cache only for base64 previews.

---

## Documentation rules

- If implementation **changes observable behavior**, contracts, routes, provider names, copy, or security posture → **update the related doc in the same task**.
- Do **not** edit docs to match incorrect code; fix code unless the user requested a product change.
- Do **not** mass-rewrite docs for style. Prefer surgical updates.
- Do **not** add new feature docs for features you were not asked to build.
- Keep `AGENTS.md` / `AI_AGENT.md` process-only; put product detail in `docs/`.
- When finishing a task, cite which docs you followed.

---

## Never

- **Never** invent features, screens, endpoints, or business rules.
- **Never** expand v1 scope (gallery/dates/lists/backup/chat/OAuth/etc.) without explicit phase + docs.
- **Never** rename routes, provider names, domain models, DTO/API fields, or copy ids defined in docs.
- **Never** bypass repositories (widgets/notifiers calling Dio directly).
- **Never** bypass Riverpod/state ownership with ad-hoc singletons or duplicate list caches.
- **Never** hard-code colors, spacing, radii, or typography that belong in design tokens.
- **Never** duplicate repositories, providers, or parallel “source of truth” for session/lists.
- **Never** ignore screen specifications, pairing-flow timings, or ownership rules.
- **Never** implement offline-first sync or optimistic writes contrary to docs.
- **Never** use GET for private couple data or put tokens in URLs/logs.
- **Never** commit secrets, real production URLs, or session tokens.
- **Never** add a second navigation system, state library, or HTTP client “just because.”
- **Never** guess when documentation is ambiguous — **stop and ask**.
- **Never** change `docs/` content unless required by an approved behavior change or explicit user request (this rulebook task created root agent files only; default is leave docs intact).

---

## Always

- **Always** treat `docs/` + `design.md` as SSOT.
- **Always** follow `docs/implementation-order.md` order and per-step DoD.
- **Always** reuse existing shared widgets, providers, and repositories when they exist or are specified.
- **Always** use design tokens and documented component patterns.
- **Always** follow screen-specs for structure, actions, and states.
- **Always** follow coding-standard, routing, state-management, api-contract, error-handling, security, testing, accessibility.
- **Always** map API errors through the documented taxonomy and copy ids.
- **Always** cancel pairing polls and other timers on dispose.
- **Always** prefer composition over duplication; smallest correct change over large rewrites.
- **Always** run analyzer (and relevant tests) before claiming done.
- **Always** update related documentation when behavior or contracts change.
- **Always** stop and clarify when docs conflict unresolved or requirements are missing.
- **Always** write Indonesian casual UI strings via catalog/specs — not corporate English chrome.

---

## Quality gates

A task is **not complete** until all gates pass:

### Gate A — Scope & docs

- [ ] Task mapped to `implementation-order` step or explicit user scope  
- [ ] Required docs from `AGENTS.md` reading list were applied  
- [ ] No undocumented feature or API surface introduced  

### Gate B — Correctness

- [ ] API actions/fields match `api-contract.md` / `data-model.md`  
- [ ] Routes/guards match `routing.md`  
- [ ] Providers/cache/mutations match `state-management.md`  
- [ ] Screen behavior matches `screen-specs/*` + pairing-flow when relevant  
- [ ] Copy/errors match `copy-catalog.md` + `error-handling.md`  

### Gate C — Engineering

- [ ] Layering and naming match `coding-standard.md`  
- [ ] Design tokens used; no rogue palette/spacing  
- [ ] Security: no token logs; secure storage for session  
- [ ] Offline: mutations blocked; cache read-only per `offline.md`  

### Gate D — Verification

- [ ] `flutter analyze` clean on touched project state  
- [ ] Tests added/updated per `testing.md` / step DoD  
- [ ] Manual checks for loading/empty/error/offline as specified  

### Gate E — Hygiene

- [ ] No secrets in diff  
- [ ] Docs updated if behavior changed  
- [ ] Summary references doc paths  

If any gate fails → **do not** mark the task done.

---

## Minimal operating loop

```text
1. Read AGENTS.md + relevant docs
2. Lock step from implementation-order.md
3. Implement per AI_AGENT.md never/always
4. Analyze + test
5. DoD / quality gates
6. Update docs only if behavior changed (or user asked)
7. Stop or ask — never invent
```

---

*OurSpace AI agent rulebook. When in doubt, open `docs/` and ask — do not improvise product behavior.*
