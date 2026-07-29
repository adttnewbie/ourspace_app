# Decision log (ADR-style)

> Architecture decisions for OurSpace Flutter.  
> Do not reverse these casually; update this file when a decision changes.

---

## D1 — Riverpod for state management

- **Status:** Accepted  
- **Context:** Need testable state, DI, AsyncValue, no BuildContext in business layer.  
- **Decision:** `flutter_riverpod` with Notifier/AsyncNotifier.  
- **Alternatives:** Provider only, Bloc/Cubit, GetX.  
- **Trade-off:** Team must learn Riverpod; codegen optional.  
- **Future:** May add riverpod_generator if boilerplate hurts.

## D2 — Dio for HTTP

- **Status:** Accepted  
- **Context:** Single POST JSON API, interceptors for auth, timeouts, error normalization.  
- **Decision:** Dio as sole HTTP client.  
- **Alternatives:** `package:http`.  
- **Trade-off:** Extra dependency vs ergonomics.

## D3 — flutter_secure_storage for session

- **Status:** Accepted  
- **Context:** `memberId` + `sessionToken` are credentials.  
- **Decision:** Secure storage only for session secrets.  
- **Alternatives:** shared_preferences (rejected), hive encrypted.  
- **Trade-off:** Platform channel quirks; test with fakes.

## D4 — go_router

- **Status:** Accepted  
- **Context:** Shell tabs + pairing full-screen + redirects by auth.  
- **Decision:** go_router + StatefulShellRoute.indexedStack.  
- **Alternatives:** Navigator 1/2 manual, auto_route.  
- **Trade-off:** Learning curve for shell routes.

## D5 — Not offline-first

- **Status:** Accepted  
- **Context:** Personal couple app; Spreadsheet is source of truth; conflict resolution expensive.  
- **Decision:** Read cache + honest offline; **no** mutation queue / background sync.  
- **Trade-off:** Cannot create notes on airplane mode.  
- **Future:** Only revisit with strong product need.

## D6 — No optimistic updates (v1)

- **Status:** Accepted  
- **Context:** FORBIDDEN/ownership must match server; Apps Script latency variable.  
- **Decision:** Mutate after success; patch local lists.  
- **Future:** Optional optimistic for low-risk fields later.

## D7 — Feature-first folders + clean layers

- **Status:** Accepted  
- **Context:** AI agents and humans scale better with predictable paths.  
- **Decision:** `lib/features/<feature>/{data,domain,presentation}` + `core` + `shared`.  
- **Trade-off:** More files early.

## D8 — Direct Apps Script from mobile (no required proxy)

- **Status:** Accepted  
- **Context:** Native apps are not browser CORS-bound.  
- **Decision:** Dio → `API_BASE_URL` (often `/exec` directly). Proxy optional.  
- **Trade-off:** `/exec` URL embedded in app binary via define — treat as semi-public endpoint still protected by session tokens; never put `SESSION_SECRET` in app.

## D9 — Material 3 foundation, custom scrapbook chrome

- **Status:** Accepted  
- **Context:** Design language is pastel scrapbook, not default M3 lists.  
- **Decision:** M3 ThemeData + ThemeExtension tokens + custom widgets.  
- **Trade-off:** More custom painting (tape, dots).

## D10 — Single icon family (lucide-compatible)

- **Status:** Accepted  
- **Decision:** One stroke set only.  
- **Trade-off:** Fewer decorative icons out of the box.

## D11 — Freezed optional

- **Status:** Accepted (optional)  
- **Decision:** Prefer freezed for entities; hand models allowed if consistent.  
- **Trade-off:** build_runner cost.

## D12 — Indonesian casual copy as product language

- **Status:** Accepted  
- **Decision:** UI strings ID santai; copy-catalog ids for agents.  
- **Future:** l10n ARB when second locale appears.

## D13 — Soft delete

- **Status:** Accepted (product)  
- **Decision:** Notes and later entities soft-delete via `deletedAt`.  
- **Rationale:** Memories hard to replace.

## D14 — Anniversary from backend timestamp

- **Status:** Accepted (product)  
- **Decision:** Never use device clock for `anniversaryDate`.  

## D15 — Gallery thumbnails memory-only on client

- **Status:** Accepted  
- **Decision:** Do not persist base64 thumbnails to disk cache.  
- **Rationale:** size + privacy of residual images.
