# Production Checklist (Flutter)

Gunakan sebelum OurSpace dipakai harian.

## Environment

- `API_BASE_URL` (atau dart-define setara) mengarah ke proxy/backend yang benar
- `APPS_SCRIPT_URL` hanya di server/proxy env jika proxy dipakai
- Browser/web network checks diganti: log Dio base URL di Settings debug
- Jangan commit secrets, session tokens, atau real Apps Script URL
- Track hanya example env / placeholders

## Apps Script

1. Push every file from `apps-script/`.
2. Create a new Apps Script version.
3. Deploy the Web App with the new version.
4. Use the `/exec` URL for `APPS_SCRIPT_URL` (proxy/server only if applicable).
5. Run `setupSchema()` after schema changes, including `shared_lists`.
6. Run `authorizeOurSpace()` once after Drive scope changes.
7. Open Deploy → Manage deployments, disable/archive old deployments so only the latest production deployment remains active.

Required Script Properties:

- `SHEET_ID`
- `SESSION_SECRET`
- `PAIRING_WINDOW_SECONDS`
- `DRIVE_ROOT_FOLDER_ID`

## Drive And Backup

1. Confirm `DRIVE_ROOT_FOLDER_ID` points to the private OurSpace root folder.
2. Click `Cek Gallery` in Settings after pairing.
3. Click `Cek Backup` in Settings after pairing.
4. Run `installBackupTrigger()` from Apps Script editor.
5. Confirm a daily `runBackup` trigger exists.
6. Use `removeBackupTriggers()` if automatic backup needs to be disabled.

## Flutter Release

1. `flutter analyze` clean for release branch.
2. Build Android App Bundle / IPA with production dart-defines.
3. Confirm API base URL is production, not local.
4. Install on two physical phones.
5. Open Settings → `Cek koneksi`.
6. Confirm requests hit intended base URL (proxy or direct).

## Performance Smoke

1. Open Home, Notes, Dates, Gallery, Lists, and Settings once.
2. Navigate away and back; cached content should appear immediately while fresh data loads in the background.
3. Create/edit/delete one item and confirm the visible list updates without a full app restart.
4. Confirm Gallery does not block Home or Settings loading.
5. Confirm duplicate simultaneous identical API calls are not visible during normal navigation.

## Offline Smoke

1. Saat online, buka Home, Notes, Dates, Gallery, dan Lists agar cache tersedia.
2. Matikan network (airplane mode / device network off).
3. Pastikan halaman cached tetap tampil + OfflineNotice.
4. Pastikan mutasi diblokir dengan pesan ramah.
5. Nyalakan network; refresh/background load kembali normal.

## Functional Smoke

1. Pair two devices with hold 3s within 30s window.
2. Confirm anniversaryDate from backend.
3. Kill app and reopen; session resume → Home.
4. Clear secure session only; expect pairing again.
5. Recovery flow if implemented.
6. Confirm Home greeting + days together.
7. Notes create/edit/delete (owner only).
8. Date plan CRUD + List/Kalender switch.
9. Gallery upload under 3 MB, edit, soft-delete.
10. Shared list create/edit/soft-delete.
11. Settings: Cek koneksi, session, Gallery, Backup.
12. Backup sekarang → Drive JSON OK, no raw sessionToken.
13. Other member cannot edit/delete content they did not create.
14. Text beginning with `=`, `+`, `-`, `@` stores as text in Sheets and shows as intended text in UI.

Recovery currently replaces the `sessionToken` for that member identity. Full multi-device approval can be added later if needed.
