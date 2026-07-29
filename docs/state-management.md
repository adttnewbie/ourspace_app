# State Management (Riverpod)

> Who owns what state, how cache works, and how mutations flow.  
> **Related:** [coding-standard.md](./coding-standard.md) · [performance.md](./performance.md) · [offline.md](./offline.md) · [pairing-flow.md](./pairing-flow.md) · [error-handling.md](./error-handling.md)

---

## 1. Principles

1. **Server is source of truth** for couple data (Spreadsheet via Apps Script).
2. **Client cache is a performance UX layer**, not offline-first sync.
3. **One owner per state concern** — no duplicate sources of session or list truth.
4. **Mutations require network**; no mutation queue.
5. **Optimistic updates: default off** for v1 (wait for backend success, then patch local list). Exception only if explicitly documented later.

---

## 2. Provider map (per feature)

### Core

| Provider | Type | Owns |
| --- | --- | --- |
| `dioProvider` | `Provider` | Dio instance |
| `apiClientProvider` | `Provider` | Apps Script action client |
| `secureStorageProvider` | `Provider` | flutter_secure_storage |
| `cacheStoreProvider` | `Provider` | non-sensitive TTL cache |
| `connectivityProvider` | `StreamProvider` / `Notifier` | online/offline |
| `routerProvider` | `Provider` | GoRouter |
| `sessionControllerProvider` | `AsyncNotifier` / `Notifier` | session status, member, resume |
| `currentMemberIdProvider` | `Provider` | derived member id |

### Pairing

| Provider | Type | Owns |
| --- | --- | --- |
| `pairingRepositoryProvider` | `Provider` | PairingRepository |
| `pairingControllerProvider` | `Notifier` | UI phase, nickname, pairingSessionId, hold, poll timer, expiresAt |

### Home

| Provider | Type | Owns |
| --- | --- | --- |
| `homeRepositoryProvider` | `Provider` | HomeRepository |
| `homeProvider` | `AsyncNotifier` | HomeSnapshot + cache metadata |

### Notes

| Provider | Type | Owns |
| --- | --- | --- |
| `notesRepositoryProvider` | `Provider` | NotesRepository |
| `notesListProvider` | `AsyncNotifier` | list + cache metadata |
| `noteEditorControllerProvider` | `Notifier` (family optional) | draft body/color for dialog |

### Settings

| Provider | Type | Owns |
| --- | --- | --- |
| `settingsRepositoryProvider` | `Provider` | health/backup/reset API |
| `settingsDiagnosticsProvider` | `Notifier` | last health check results (ephemeral) |

### Later features

| Feature | List provider | Notes |
| --- | --- | --- |
| Dates | `datePlansListProvider` | TTL 60s |
| Gallery | `galleryListProvider` | **memory only** |
| Lists | `sharedListsProvider` | TTL 60s |

---

## 3. State ownership

| State | Owner | Storage |
| --- | --- | --- |
| `memberId`, `sessionToken` | SessionController + SecureStorage | secure only |
| Session validation result | SessionController | memory (TTL) |
| Pairing UI phase | PairingController | memory only |
| Home snapshot | HomeNotifier + CacheStore | memory + optional prefs |
| Notes list | NotesListNotifier + CacheStore | memory + optional prefs |
| Gallery list | GalleryNotifier | **memory only** |
| Connectivity | Connectivity service | stream |
| Bottom nav index | go_router shell | router state |
| Dialog open | local widget / editor controller | ephemeral |

**Anti-pattern:** widgets keeping parallel copies of notes list outside providers.

---

## 4. Cache ownership & TTL

Aligned with [performance.md](./performance.md):

| Key / action | TTL | Store | Owner |
| --- | --- | --- | --- |
| `session.resume` | short (e.g. 30–60s memory) | memory | SessionController |
| `home.get` | 45s | memory + optional prefs | HomeNotifier |
| `notes.list` | 60s | memory + optional prefs | NotesListNotifier |
| `datePlans.list` | 60s | memory + optional prefs | Dates notifier |
| `sharedLists.list` | 60s | memory + optional prefs | Lists notifier |
| `gallery.list` | 60s | **memory only** | Gallery notifier |

Cache payload: **API data only**. Never cache `sessionToken` in prefs/Hive.

Cache entry metadata: `fetchedAt`, `payload`, optional `source: network|cache`.

---

## 5. Invalidation rules

| Event | Invalidate / update |
| --- | --- |
| Notes create/update/delete success | Patch notes list; invalidate or refresh `homeProvider` (today section / counts) |
| Pairing success | Write session; set authenticated; warm `homeProvider` |
| Local session clear / reset pairing | Clear all list caches + session memory |
| `UNAUTHORIZED` on any call | Clear session; redirect pairing; clear caches |
| Pull-to-refresh / explicit refresh | Force network ignore TTL |
| Connectivity online after offline | Optional soft refresh active screen only |
| Settings force session check | Bypass session resume TTL |

---

## 6. Mutation flow (standard)

```text
User action
  → guard online (else toast copy.offline.mutation_blocked)
  → set submitting UI on control
  → repository.mutation()
  → on success:
      update local list (replace/remove/insert)
      optionally invalidate related providers
      close dialog / toast success (optional, keep subtle)
  → on failure:
      map AppFailure → UI (dialog/inline/toast)
      do not remove optimistic rows (none exist by default)
```

---

## 7. Refresh strategy

| Mode | Behavior |
| --- | --- |
| **Cold open** | No cache → skeleton → network |
| **Warm open** | Show cache immediately → background refresh if TTL expired or always soft-refresh once per enter (product: if cache exists show first + “Lagi nyegerin…”) |
| **Offline + cache** | Show cache even if TTL expired; no background refresh |
| **Offline + no cache** | Offline empty state (no infinite skeleton) |
| **Tab re-entry** | Prefer cached data; refresh per TTL |

---

## 8. Optimistic update rules

**v1 default: no optimistic mutations.**

- Wait for backend success before inserting/editing/removing in list UI.
- Loading indicator on the specific action (button spinner).
- Rationale: Apps Script latency variable; ownership/FORBIDDEN must be trusted from server; personal data correctness > snappy fake UI.

---

## 9. Polling lifecycle (pairing)

| Phase | Poll? | Interval | Stop when |
| --- | --- | --- | --- |
| Idle / Holding | no | — | — |
| Waiting | yes `pairing.status` | 1–2s | paired, expired, dispose, user cancel |
| Paired / Expired | no | — | — |

Implementation requirements:

- `Timer.periodic` owned by `PairingController`.
- `ref.onDispose` / `onCancel` cancels timer.
- Overlapping status calls: **dedupe** in-flight status for same `pairingSessionId` or ignore stale responses (sequence number).
- Do not poll when offline; show offline + allow retry when back.

---

## 10. Pairing lifecycle state machine

```text
idle → (valid nickname + press) → holding
holding → (release early) → idle
holding → (3s complete) → signal API → waiting | paired | error
waiting → (poll paired) → paired
waiting → (expires / PAIRING_EXPIRED) → expired
expired → (retry) → idle (new start/signal flow as implemented)
paired → persist session → navigate home
```

Nickname: required non-empty trim before hold enables (validation in controller).

---

## 11. Provider dependency graph

```text
secureStorageProvider
        ↓
sessionControllerProvider ← apiClientProvider ← dioProvider
        ↓
currentMemberIdProvider
        ↓
homeProvider / notesListProvider / …  (need auth headers via api client reading session)

pairingControllerProvider → pairingRepositoryProvider → apiClientProvider
connectivityProvider → guards in notifiers
```

Session tokens injected in Dio interceptor from secure storage / session controller — repositories do not take raw tokens as parameters from widgets.

---

## 12. Repository ownership

| Repository | Actions |
| --- | --- |
| `SessionRepository` | `resume`, `recover` (if any), clear local |
| `PairingRepository` | `start`, `signal`, `status` |
| `HomeRepository` | `get` |
| `NotesRepository` | `list`, `create`, `update`, `delete` |
| `SettingsRepository` | `health.check`, gallery/backup health, `resetPairing`, backup run |

Repositories coordinate remote + cache; notifiers coordinate UI async state.

---

## 13. State restoration

| Kind | v1 |
| --- | --- |
| OS process death | Session restored from secure storage; lists cold-fetched or prefs cache if present |
| `RestorationMixin` scroll | Optional later; not required |
| Pairing mid-hold | **Not** restored across process kill — user restarts hold |
| open dialogs | Not restored |

---

## 14. Loading strategy summary

| Situation | UI |
| --- | --- |
| First load no cache | Feature skeleton |
| Refresh with cache | Content + yellow status pill |
| Mutation | Button/local busy, list stays |
| Pairing hold | Progress on button |
| Session gate | PairingStatusSkeleton / gate card |
| Offline no cache | OfflineEmptyState |

---

## 15. In-flight dedupe

Safe reads deduped at API client (see performance.md). Mutations never deduped. Notifiers should not fire double submit without disabling the button (`isSubmitting` flag).
