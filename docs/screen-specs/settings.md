# Screen Spec: Settings

**Route:** `/settings` · **Shell:** yes · **Auth:** required · **v1:** yes  
**Providers:** `sessionControllerProvider`, `settingsRepositoryProvider`, `settingsDiagnosticsProvider`, `connectivityProvider`  
**Related:** [security.md](../security.md) · [backup.md](../backup.md) · [production-checklist.md](../production-checklist.md)

---

## Purpose

Profile/session visibility, connection diagnostics, gallery/backup health (when enabled), local session clear, and strong-confirm reset pairing (`keep_data`).

---

## Layout hierarchy

```text
AppShell
└── SettingsScreen (ScrollView)
      ├── OfflineNotice?
      ├── PageHeader (Settings / More)
      ├── Profile ScrapbookCard
      │     ├── Nickname
      │     ├── Member meta (non-sensitive)
      │     └── Anniversary / pair info if available
      ├── Menu stack (SettingsMenuCard tones)
      │     ├── Cek koneksi
      │     ├── Cek session
      │     ├── Cek Gallery (later)
      │     ├── Cek Backup (later)
      │     ├── Backup sekarang (later)
      │     └── API base debug label (non-secret)
      ├── Danger zone card
      │     ├── Hapus session lokal
      │     └── Reset pairing (confirm)
      └── Diagnostics result text (last check)
```

---

## Widget hierarchy

- `SettingsScreen`
- `ProfileCard`
- `SettingsMenuCard` (chevron / trailing status)
- `DiagnosticsResult`
- `ConfirmAlertDialog` (reset / clear)
- Optional nested routes for long panels

---

## Component list

| Component | Role |
| --- | --- |
| PageHeader | title |
| ScrapbookCard | profile + danger |
| SettingsMenuCard | actions |
| AppButton destructive/secondary | danger |
| ConfirmAlertDialog | reset pairing |
| Status / result text | last health payload summary **without tokens** |

---

## Actions

| Action | Online? | Behavior |
| --- | --- | --- |
| Cek koneksi | yes | `health.check` → show success/fail |
| Cek session | yes | force `session.resume` | 
| Cek Gallery | yes | `gallery.health` |
| Cek Backup | yes | `backup.health` |
| Backup sekarang | yes | trigger backup run action |
| Hapus session lokal | n/a | clear secure storage + caches → `/pairing` |
| Reset pairing | yes | confirm → `settings.resetPairing` `{mode: keep_data}` → clear local → `/pairing` |

All network actions blocked offline with friendly copy.

---

## Navigation

| Event | Route |
| --- | --- |
| Clear/reset session | `/pairing` |
| Menu only | stay `/settings` |
| Bottom nav More | `/settings` |

---

## Provider usage

- Diagnostics ephemeral on `settingsDiagnosticsProvider` (not persisted).
- Session clear through `sessionControllerProvider`.
- Never put `sessionToken` into diagnostics UI.

---

## States

| State | UI |
| --- | --- |
| Default | profile + menus |
| Check loading | row spinner / button busy |
| Check success | green/mint human message |
| Check fail | error message mapped |
| Offline | menus that need network disabled + notice |

---

## Permissions

Network; backup/gallery checks need prior Drive auth on **backend**, not extra Flutter OS perms for checks.

---

## Animation

Minimal; button busy states only.

---

## Validation

- Reset requires explicit confirm dialog (title + description + Hapus/Reset vs Batal).
- No blank confirm.

---

## Edge cases

- `UNAUTHORIZED` on cek session → offer clear to pairing.
- Backup run slow → loading until timeout; show failure copy.
- Debug API base URL shown truncated; never full token.
- Double-tap reset: disable confirm while in-flight.

---

## Business rules

- Default reset mode `keep_data` (notes soft-preserved server-side per product).
- Local clear does not call backend.
- Private by default: no public share toggles.

---

## Ownership rules

- Settings visible to both members; reset is couple-level (backend enforces).
- Cannot edit other member profile beyond what API allows (v1: nickname set at pairing).

---

## Responsive

- Single column menu cards; comfortable tap targets ≥48 height rows.

---

## Accessibility

- Danger actions announced as critical.
- Confirm dialog clear labels.
- Diagnostic results not color-only (text status).
