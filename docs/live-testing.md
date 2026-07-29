# Live Testing Checklist (Flutter)

Gunakan sebelum membangun fase fitur berikutnya.

## Setup

1. Update the Apps Script project with every file from `apps-script/`.
2. In Apps Script, run `setupSchema` once if sheets are not created yet. Run again after schema changes (e.g. `date_plans`, `gallery`).
3. Confirm Script Properties:
   - `SHEET_ID`
   - `SESSION_SECRET`
   - `PAIRING_WINDOW_SECONDS`
   - `DRIVE_ROOT_FOLDER_ID`
4. Run `authorizeOurSpace` once; expect `status: authorized` and Drive root folder name.
5. Deploy Apps Script Web App new version; copy `/exec` URL into server/proxy env only if using proxy.
6. Configure Flutter:

```bash
flutter run --dart-define=API_BASE_URL=https://your-api-or-proxy
```

7. Prefer two physical devices (or one device + emulator) for pairing tests.

## Backup Setup

1. Run `setupSchema()`.
2. Confirm `DRIVE_ROOT_FOLDER_ID` points to private OurSpace Drive folder.
3. Run `authorizeOurSpace()`.
4. Run `backup.health` from Settings with `Cek Backup`.
5. Run `runBackup()` manually from Apps Script editor.
6. Confirm JSON in Drive `backups/`.
7. Confirm `backups` sheet has `success` row.
8. Open JSON: `generatedAt`, `includedSheets`, `itemCounts`.
9. Counts look right; no raw `sessionToken`.
10. Gallery is metadata only (no original image base64).
11. Run `installBackupTrigger()`; confirm daily `runBackup` trigger.

## Settings Checks

1. Open Settings.
2. Confirm API base path/URL shown is expected.
3. Click `Cek koneksi` → `Backend tersambung.`
4. Click `Cek session`.
5. If no local session, expect `UNAUTHORIZED`.
6. After pairing: `Cek Gallery`, `Cek Backup`.
7. Expect Gallery/Backup ready messages.
8. `Hapus session lokal` clears secure storage and returns to `/pairing`.

## Pairing Live Test

1. Two devices, no session.
2. Enter nicknames.
3. Hold both circles ~3s within 30s.
4. Waiting shows countdown; paired shows success then Home.
5. `memberId` + `sessionToken` in secure storage.
6. Expire window intentionally; expect retry copy.
7. Release early during hold; no signal until full 3s.

## Home Live Test

1. Greeting uses nickname.
2. Days together matches anniversary.
3. Quick add sticky works.
4. Today section hides when empty.
5. Summary widgets navigate correctly.

## Notes CRUD Live Test

1. Create short note with color.
2. Edit as owner.
3. Soft delete as owner.
4. Other member cannot edit/delete.
5. Author shows nickname.
6. Empty/error/loading states visible.

## Dates / Gallery / Lists (when enabled)

1. Date plans list + calendar month nav; selected day obvious.
2. Gallery upload form shows limits; caption/date required; edit/delete readable.
3. Shared lists filters/chips compact; create/edit/delete easy to tap.
4. Backup Settings actions show loading + success/error.

## UI / A11y Smoke

1. Phone portrait: scrapbook readable, no cramped buttons.
2. Bottom nav never covers primary actions (`pb` clearance).
3. Forms have labels; focus visible; status not color-only.
4. Offline notice readable.
5. Hold button large enough for thumbs.

## Network Check

Dio / debug logs should show requests to configured `API_BASE_URL` (proxy path or direct Apps Script). Do not log full `sessionToken`.
