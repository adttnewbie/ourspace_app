# Sequence diagrams

> Critical flows for implementers and AI agents. Mermaid-compatible.

**Related:** [pairing-flow.md](./pairing-flow.md) · [routing.md](./routing.md) · [state-management.md](./state-management.md) · [api-contract.md](./api-contract.md) · [backup.md](./backup.md)

---

## 1. Pairing (success)

```mermaid
sequenceDiagram
  participant U1 as Device A
  participant U2 as Device B
  participant App as Flutter
  participant API as Apps Script
  participant DB as Spreadsheet

  U1->>App: open app (no session)
  App->>App: show /pairing
  U1->>App: nickname + hold 3s
  App->>API: pairing.start / signal
  API->>DB: pairing_sessions waiting
  API-->>App: waiting + expiresAt
  App->>App: poll pairing.status 1-2s

  U2->>App: nickname + hold 3s
  App->>API: pairing.signal
  API->>DB: second signal within 30s
  API->>DB: create members + anniversaryDate
  API-->>App: paired + memberId + sessionToken
  App->>App: secure storage write
  App->>App: go(/)
```

---

## 2. Authentication (session resume)

```mermaid
sequenceDiagram
  participant User
  participant App as SessionGate
  participant Store as SecureStorage
  participant API as Apps Script

  User->>App: cold start
  App->>Store: read memberId, sessionToken
  alt missing
    App->>App: redirect /pairing
  else present
    App->>API: session.resume
    alt ok
      API-->>App: member + anniversary
      App->>App: authenticated → shell /
    else UNAUTHORIZED
      App->>Store: clear
      App->>App: /pairing
    else network error
      App->>App: retry UI (keep tokens)
    end
  end
```

---

## 3. API request (authenticated)

```mermaid
sequenceDiagram
  participant UI
  participant Notifier
  participant Repo
  participant Client as ApiClient/Dio
  participant API as Apps Script

  UI->>Notifier: load / mutate
  Notifier->>Repo: call
  Repo->>Client: action + payload
  Client->>Client: attach memberId + sessionToken
  Client->>API: POST JSON
  API-->>Client: { ok, data } or { ok:false, error }
  Client->>Client: map to domain / AppFailure
  Client-->>Repo: result
  Repo-->>Notifier: domain
  Notifier-->>UI: AsyncValue
```

---

## 4. Cache refresh (stale-while-revalidate)

```mermaid
sequenceDiagram
  participant UI
  participant Notifier
  participant Cache
  participant API

  UI->>Notifier: watch notesList
  Notifier->>Cache: read
  alt hit
    Cache-->>Notifier: payload
    Notifier-->>UI: data + optional refreshing pill
    Notifier->>API: notes.list (background)
    API-->>Notifier: fresh
    Notifier->>Cache: write + fetchedAt
    Notifier-->>UI: updated data
  else miss
    Notifier-->>UI: loading skeleton
    Notifier->>API: notes.list
    API-->>Notifier: data
    Notifier->>Cache: write
    Notifier-->>UI: data
  end
```

---

## 5. Pairing polling

```mermaid
sequenceDiagram
  participant Ctrl as PairingController
  participant API
  loop every 1-2s while waiting
    Ctrl->>API: pairing.status
    alt paired
      API-->>Ctrl: session
      Ctrl->>Ctrl: stop timer, persist, navigate
    else waiting
      API-->>Ctrl: waiting
      Ctrl->>Ctrl: update countdown
    else expired
      API-->>Ctrl: PAIRING_EXPIRED / expired
      Ctrl->>Ctrl: stop timer, expired UI
    end
  end
  Note over Ctrl: onDispose cancels timer
```

---

## 6. Backup (manual / trigger)

```mermaid
sequenceDiagram
  participant User
  participant App as Settings
  participant API as Apps Script
  participant Drive
  participant Sheet as backups sheet

  User->>App: Backup sekarang / trigger
  App->>API: backup run action (or editor runBackup)
  API->>Sheet: read members, notes, …
  API->>Drive: write JSON in OurSpace/backups/
  API->>Sheet: row success/failed
  API-->>App: ok + summary
  Note over Drive: no raw sessionToken, no full photo bytes
```

---

## 7. Restore

```mermaid
sequenceDiagram
  participant Ops as Human / future tool
  participant Drive
  participant Sheet as Spreadsheet

  Note over Ops,Sheet: v1 — restore NOT implemented in app
  Ops->>Drive: download backup JSON
  Ops->>Sheet: manual / future import
  Note over Ops: App has no restore UI
```

Product: restore is explicitly out of scope for automatic in-app flow ([backup.md](./backup.md)).
