# Error Handling

> Taxonomy, UI mapping, retry, logging.  
> **Related:** [api-contract.md](./api-contract.md) · [copy-catalog.md](./copy-catalog.md) · [offline.md](./offline.md) · [state-management.md](./state-management.md)

---

## 1. Error taxonomy

| Category | Source | Examples |
| --- | --- | --- |
| **Network** | Dio connection/timeout/offline | `NETWORK_OFFLINE`, `NETWORK_TIMEOUT`, `NETWORK_UNKNOWN` |
| **Business / API** | `ok: false` body | `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, … |
| **Validation** | Client form rules | empty nickname, note body empty, file > 3MB |
| **Parsing** | JSON/DTO mismatch | `PARSE_ERROR` |
| **Authentication** | Missing/invalid session | `UNAUTHORIZED`, local no tokens |
| **Authorization** | Ownership | `FORBIDDEN` |
| **Pairing** | Window / flow | `PAIRING_EXPIRED` |
| **Unexpected** | Bugs, 5xx unmapped | `INTERNAL_ERROR`, `UNKNOWN` |

All surface to UI as `AppFailure` (see coding-standard). Never show platform exception strings.

---

## 2. Normalization pipeline

```text
DioException / SocketException
  → if offline or connection error → NETWORK_OFFLINE
  → if send/receive timeout → NETWORK_TIMEOUT
  → else NETWORK_UNKNOWN

HTTP 200 + body ok:false
  → ApiFailure(code, message)

HTTP 200 + invalid JSON
  → PARSE_ERROR

HTTP non-200 (if any)
  → map or INTERNAL_ERROR

Client guard
  → ValidationFailure
  → OFFLINE_MUTATION_BLOCKED (before request)
```

---

## 3. API error codes (contract)

| Code | Meaning |
| --- | --- |
| `UNAUTHORIZED` | Token missing/invalid |
| `BAD_REQUEST` | Payload invalid |
| `NOT_FOUND` | Item missing |
| `CONFLICT` | Update conflict |
| `FORBIDDEN` | Not owner / not allowed |
| `PAIRING_EXPIRED` | 30s window over |
| `INTERNAL_ERROR` | Server unexpected |
| `NETWORK_OFFLINE` | Client-normalized |
| `NETWORK_TIMEOUT` | Client-normalized |
| `PARSE_ERROR` | Client-normalized |
| `VALIDATION` | Client-normalized |
| `OFFLINE_MUTATION_BLOCKED` | Client guard |

---

## 4. Retry strategy

| Failure | Auto retry? | Manual retry | Limit |
| --- | --- | --- | --- |
| `NETWORK_OFFLINE` | no (wait online) | yes | unlimited manual |
| `NETWORK_TIMEOUT` | optional 1× safe read only | yes | max 1 auto on idempotent GET-like actions |
| `INTERNAL_ERROR` | no | yes | — |
| `UNAUTHORIZED` | no | re-pair / recover | clear session first |
| `FORBIDDEN` | no | no (show ownership copy) | — |
| `BAD_REQUEST` / `VALIDATION` | no | fix input | — |
| `PAIRING_EXPIRED` | no | restart pairing | — |
| `NOT_FOUND` | no | refresh list | — |
| `CONFLICT` | no | refresh then retry edit | — |
| Mutations | **never** auto-retry | user taps again | prevent double-submit with flag |

Safe reads may use in-flight dedupe; that is not the same as retry.

---

## 5. Fallback behavior

| Context | Fallback |
| --- | --- |
| List load fail + cache | Keep cache + soft warning pill |
| List load fail + no cache | Error card + retry |
| Home fail + cache | Same as list |
| Mutation fail | Keep prior list; show error |
| Session resume network fail + local tokens | Temporary error / offline honest; **do not** delete tokens |
| Session `UNAUTHORIZED` | Clear tokens → `/pairing` |
| Pairing signal fail | Return to idle/expired with message |

---

## 6. UI channels

| Channel | When |
| --- | --- |
| **Inline error card** (`ScrapbookCard` pink) | Page-level load failures |
| **Status pill** (yellow) | Soft refresh fail / stale cache warning |
| **Snackbar / toast** (scrapbook) | Short mutation failures, offline mutation block, success rare |
| **Dialog** | Destructive confirm; blocking session issues optional |
| **Field error** | Validation under input |
| **Full-screen** | Fatal framework `/error`; offline help `/offline` |
| **Pairing copy region** | Flow-specific status under hold button |

Do **not** use all channels at once for one error.

---

## 7. Master mapping table

| Error code | UI | Copy id | Retry behavior | Analytics event (no PII) |
| --- | --- | --- | --- | --- |
| `NETWORK_OFFLINE` | Banner / offline empty / toast if mutation | `error.network.offline` | Manual when online | `error_network_offline` |
| `NETWORK_TIMEOUT` | Inline or toast | `error.network.timeout` | Manual; optional 1× safe read | `error_network_timeout` |
| `NETWORK_UNKNOWN` | Inline or toast | `error.network.unknown` | Manual | `error_network_unknown` |
| `UNAUTHORIZED` | Gate → pairing | `error.auth.unauthorized` | Re-auth / pair | `error_unauthorized` |
| `FORBIDDEN` | Toast or inline on action | `error.auth.forbidden` | None | `error_forbidden` |
| `BAD_REQUEST` | Toast / field | `error.api.bad_request` | Fix input | `error_bad_request` |
| `NOT_FOUND` | Inline + refresh | `error.api.not_found` | Refresh list | `error_not_found` |
| `CONFLICT` | Toast + refresh | `error.api.conflict` | Refresh then edit | `error_conflict` |
| `PAIRING_EXPIRED` | Pairing expired UI | `pairing.expired` | Restart hold flow | `error_pairing_expired` |
| `INTERNAL_ERROR` | Inline / toast | `error.api.internal` | Manual | `error_internal` |
| `PARSE_ERROR` | Inline | `error.parse` | Manual | `error_parse` |
| `VALIDATION` | Field / toast | per-field copy ids | Fix input | `error_validation` |
| `OFFLINE_MUTATION_BLOCKED` | Toast | `offline.mutation_blocked` | When online | `offline_mutation_blocked` |

Analytics: **event name + code only**. No nickname, note body, token, or raw URL with secrets.

---

## 8. Logging rules

| May log | Must not log |
| --- | --- |
| action name (`notes.list`) | `sessionToken` |
| error code | raw Authorization-like headers |
| duration, success bool | note body, captions, base64 |
| HTTP status if any | full request/response bodies in prod |

Use `AppLog.d/w/e` with redaction. Debug builds may be slightly more verbose; still redact tokens.

---

## 9. Validation errors (client)

| Field | Rule | Copy id |
| --- | --- | --- |
| Nickname | non-empty after trim; reasonable max length (e.g. 24–40) | `validation.nickname.required` |
| Note body | non-empty; max 280 | `validation.note.body` |
| Note color | one of preset keys | `validation.note.color` |
| Gallery file | image only; ≤ 3MB | `validation.gallery.size` / `type` |
| Gallery caption / takenAt | required | `validation.gallery.caption` / `taken_at` |

---

## 10. Widget helpers

- `FailureMapper.toUserMessage(AppFailure)` → localized string via copy catalog.
- `showAppToast(context, message)`
- `ErrorStateCard(failure, onRetry)`
- Prefer passing `AppFailure`, not `Object`.
