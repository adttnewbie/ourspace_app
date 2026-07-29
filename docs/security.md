# Security

> Client and data-handling rules for OurSpace Flutter.  
> Does **not** change backend auth model (pairing + session token).  
> **Related:** [api-contract.md](./api-contract.md) · [error-handling.md](./error-handling.md) · [environment.md](./environment.md) · [backup.md](./backup.md)

---

## 1. Threat model (v1)

| Asset | Risk | Mitigation |
| --- | --- | --- |
| `sessionToken` | theft from storage/logs | secure storage; never log; no prefs |
| `memberId` | binding spoof | always sent with token; server validates both |
| Couple notes/photos | exposure | private Drive; no public URLs; private by default |
| Apps Script URL | abuse/quota | optional hide behind proxy; no commit of prod URL if policy says so |
| Backup JSON | token leak | backend must not include raw tokens; client never writes tokens into backups |

Out of scope v1: multi-tenant attackers, Google OAuth, E2E encryption.

---

## 2. Secure storage

| Key | Store | Notes |
| --- | --- | --- |
| `memberId` | `flutter_secure_storage` | required with token |
| `sessionToken` | `flutter_secure_storage` | plaintext token as issued; server stores hash |

**Suggested key names (canonical):**

```text
ourspace.memberId
ourspace.sessionToken
```

Rules:

- Android: encrypted shared preferences / Keystore-backed per plugin defaults.
- iOS: Keychain; consider `first_unlock` accessibility appropriate for app launch resume.
- Clear both keys on logout / reset / UNAUTHORIZED.
- No backup of secure storage content into screenshots docs or fixtures with real values.

---

## 3. Sensitive data policy

| Data | Allowed locations |
| --- | --- |
| sessionToken | secure storage, memory (Dio interceptor), pairing response handling |
| memberId | secure storage, memory, API bodies |
| nickname | UI, API, non-secure cache OK |
| note bodies | API, list cache OK |
| gallery base64 thumbnails | **memory only** |
| API_BASE_URL | dart-define / config — not secret like a password but treat prod carefully |

**Never:** analytics properties, crash breadcrumbs, file logs, clipboard auto-copy of tokens, screenshot test goldens with real tokens.

---

## 4. Token lifecycle

```text
paired response
  → write memberId + sessionToken
  → memory session hydrated
  → Dio interceptor attaches both on each request

session.resume OK
  → keep tokens

UNAUTHORIZED
  → delete secure keys
  → clear memory session + caches
  → navigate /pairing

Hapus session lokal
  → same clear without backend

settings.resetPairing keep_data
  → backend invalidate members/sessions per API
  → local clear
  → /pairing
```

**Refresh token:** **none** in v1. No refresh rotation protocol beyond recover (if implemented) replacing token for that member identity.

---

## 5. session.recover (if enabled)

- Replaces `sessionToken` for that member identity.
- Must be online.
- Strong UX confirmation if destructive to other devices’ sessions (product: currently replaces token for identity; multi-device approval later).
- Store new token immediately; never leave old token in UI state.

---

## 6. Backup rules (client)

- Client may trigger backup / show health; does not embed tokens in requests beyond normal session auth.
- When displaying backup metadata, show counts/status only.
- Verify (manual QA): backup JSON has **no** raw `sessionToken`.

---

## 7. Logging restrictions

| May log | Must not log |
| --- | --- |
| action name | sessionToken |
| error code | full Authorization-like payloads |
| latency | raw base64 images |
| route name | complete API_BASE_URL with secrets if any |

Use `AppLog` with redaction filter for keys matching `token`, `session`, `base64`.

---

## 8. Analytics

- v1: analytics optional/off.
- If added: no note body content, no tokens, no exact GPS, no raw captions if sensitive.
- Prefer aggregate events: `pairing_success`, `note_create` without bodies.

---

## 9. Transport security

- **HTTPS only** to Apps Script / proxy.
- Cleartext traffic disabled in release (Android network security config; iOS ATS defaults).
- **SSL pinning:** recommended as **optional later** hardening; not required to ship v1. If added, document pin rotation runbook — bad pins brick the app.

---

## 10. Formula injection prevention

Spreadsheet risk: user text starting with `=`, `+`, `-`, `@` interpreted as formulas.

- **Backend** must store as text (existing production checklist item).
- **Client** must not strip or alter leading characters; display exactly what user entered.
- QA: create notes with those prefixes; UI shows intended text.

---

## 11. Clipboard policy

- Do not auto-copy session tokens or member ids.
- User-initiated copy of note text OK.
- Avoid `Clipboard.setData` for diagnostics dumps that include headers.

---

## 12. Dio / API client

- POST only for private data.
- Timeouts set (e.g. connect/receive sane bounds).
- Certificate errors → fail closed (no silent HTTP downgrade).
- Interceptor reads tokens from secure storage/session; widgets never pass tokens into repository public API.

---

## 13. OS permissions

| Permission | When |
| --- | --- |
| Internet | always |
| Photos / pick image | gallery upload phase only |
| Camera | only if product adds camera capture (not required if picker-only) |

Request photo permission **just-in-time** on gallery upload, with Indonesian rationale copy.

---

## 14. Release hygiene

- No debug banners in prod.
- obfuscation/split debug info optional for store.
- Secrets only via CI dart-define / sealed config — see [environment.md](./environment.md).
