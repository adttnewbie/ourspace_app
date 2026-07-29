# Screen Spec: Pairing

**Route:** `/pairing` · **Shell:** no · **Auth:** guest · **v1:** yes  
**Providers:** `pairingControllerProvider`, `connectivityProvider`, `sessionControllerProvider`  
**Related:** [pairing-flow.md](../pairing-flow.md) · [sequence-diagrams.md](../sequence-diagrams.md) · [copy-catalog.md](../copy-catalog.md)

---

## Purpose

Onboarding ritual: two people enter nicknames and hold a circular button for 3 seconds within a 30-second pairing window. Success writes session and becomes `anniversaryDate` (backend timestamp).

---

## Layout hierarchy

```text
AppCanvas (full)
└── Center
    └── ConstrainedBox max ~420
        └── ScrapbookCard (lifted, radius 32)
              ├── Title / short copy
              ├── Nickname AppTextField
              ├── HoldButton (~208 circle + progress)
              ├── Status text (idle/holding/waiting/expired/paired)
              ├── Countdown (waiting)
              └── Optional recovery form (if product exposes session.recover)
```

---

## Widget hierarchy

- `PairingScreen`
- `PairingCard`
- `NicknameField`
- `HoldPairingButton` (GestureDetector + AnimationController 3s)
- `PairingStatusText`
- `PairingCountdown`
- Optional `SessionRecoverForm`

---

## Component list

| Component | Notes |
| --- | --- |
| ScrapbookCard | lifted shadow |
| AppTextField | nickname |
| Hold button | primary fill, progress arc, HeartHandshake / spinner |
| AppButton | retry after expired; recover submit |
| PairingStatusSkeleton | session gate adjacent |

---

## Actions

| Action | Behavior |
| --- | --- |
| Edit nickname | update controller; enable hold when valid |
| Pointer down on hold | start 3s progress if online + valid nickname |
| Pointer up early | cancel progress; no API |
| Hold complete | `pairing.start` if needed then `pairing.signal` (implementation may start session on first entry — follow api-contract: start when entering flow with nickname; signal after hold) |
| Waiting | poll `pairing.status` 1–2s |
| Paired | save secure storage; session authenticated; short success; `go('/')` |
| Expired | show copy; allow retry (new window) |
| Retry | reset to idle; clear pairingSessionId as needed |

**API order (canonical):**

1. User fills nickname.
2. On first need: `pairing.start` → store `pairingSessionId`, `expiresAt`.
3. After 3s hold: `pairing.signal` with session id + nickname.
4. If waiting: poll `pairing.status` until paired/expired.

(If implementation batches start at screen open after nickname commit, document in code to match this contract.)

---

## Navigation

| Event | Route |
| --- | --- |
| Paired | `/` |
| Already authenticated redirect | never stay on pairing |
| Offline help optional | `/offline` |

---

## Provider usage

- All phase logic in `pairingControllerProvider`.
- Timer cancelled on dispose.
- Session write via `sessionControllerProvider` after paired response.

---

## States

| UI state | Visual |
| --- | --- |
| Idle | nickname + hold ready; copy “Tahan bareng-bareng.” |
| Holding | progress ring 3s |
| Waiting | “Nunggu pasangan kamu...”; countdown ≤30s; poll |
| Paired | brief success |
| Expired | “Belum barengan, coba sekali lagi.” |
| Error | human error + retry |
| Offline | block hold/start; friendly message |

---

## Permissions

Network only.

---

## Animation

- Hold progress: 3s linear.
- Press scale ~0.98.
- Respect reduced motion (progress can jump/complete without long ornament).

---

## Validation

- Nickname: required, trim, reasonable max length (e.g. 1–24 chars — keep product soft; reject empty).
- Hold disabled if invalid nickname, offline, submitting signal, or waiting.

---

## Edge cases

- Two devices same nickname: backend rule requires different devices/nicknames in window — show error if API fails.
- Process kill mid-waiting: not restored; user restarts.
- Clock skew: `expiresAt` from server; countdown from server time if possible, else local elapsed from receive.
- Double signal: button disabled while in-flight.
- `PAIRING_EXPIRED` → expired UI.

---

## Business rules

- Anniversary = backend success timestamp only.
- Window default 30s (`PAIRING_WINDOW_SECONDS` on server).
- Pairing session not reusable after success.

---

## Ownership rules

N/A (pre-member). After pair, device bound to `memberId`.

---

## Responsive

- Centered card max ~420; full viewport height comfortable for thumb hold.
- Hold button large (~208).

---

## Accessibility

- Hold button semantics: “Tahan tiga detik untuk pairing” + value progress.
- Announce waiting/expired via polite semantics.
- Text field label visible.
- Do not rely on color alone for progress (ring + text).
