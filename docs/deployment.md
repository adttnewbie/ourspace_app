# Deployment (Flutter)

Final deployment target: **Flutter Android/iOS builds** for the client, Google Apps Script for the API, Spreadsheet and Drive for private data.

## Required Env

Flutter client:

```bash
# compile-time example
--dart-define=API_BASE_URL=https://script.google.com/macros/s/xxx/exec
# or a self-hosted proxy base URL if used
```

If a server-side proxy is used:

```env
APPS_SCRIPT_URL="https://script.google.com/macros/s/xxx/exec"
```

Keep real Apps Script deployment URLs out of tracked files. Use ignored local config / CI secrets / dart-define in release pipelines. Track only placeholders in example config.

## Apps Script Before App Release

1. Push/copy every file from `apps-script/`.
2. Deploy a new Web App version.
3. Use the `/exec` URL for client `API_BASE_URL` or server `APPS_SCRIPT_URL`.

After the latest production deployment is verified:

1. Open Apps Script → Deploy → Manage deployments.
2. Keep only the latest production deployment active.
3. Disable or archive every superseded deployment.
4. Put the latest `/exec` URL only in secrets / ignored local config / CI. Never paste into tracked files.

Then finish backend setup:

1. Confirm Script Properties:
   - `SHEET_ID`
   - `SESSION_SECRET`
   - `PAIRING_WINDOW_SECONDS`
   - `DRIVE_ROOT_FOLDER_ID`
2. Run `setupSchema()` after schema changes.
3. Run `authorizeOurSpace()` if Drive permissions changed.
4. Run `installBackupTrigger()` if automatic backup should run daily.

## Flutter release

### Android

1. Configure signing (`key.properties` ignored, not committed with secrets).
2. `flutter build appbundle --dart-define=API_BASE_URL=...`
3. Upload AAB to Play Console (internal/closed track first).

### iOS

1. Configure signing & bundle id in Xcode.
2. `flutter build ipa --dart-define=API_BASE_URL=...`
3. Upload via Xcode / Transporter to TestFlight.

### Project hygiene

- `flutter analyze` clean before release.
- No debug logs printing session tokens.
- Proguard/R8 rules if needed for release Android.
- App icons + splash match cream scrapbook branding (`#fff8f1`).

## Production Smoke Test

1. Install production/TestFlight build on two phones.
2. Pair two device sessions (hold 3s within 30s).
3. Confirm Home loads greeting and `daysTogether`.
4. Create/edit/delete a Sticky Note.
5. Create/edit/delete a Date Plan.
6. Switch Dates between List and Kalender.
7. Upload a small Gallery photo.
8. Edit/delete the Gallery item.
9. Create/edit/delete a Shared List item.
10. Settings: `Cek koneksi`.
11. Settings: `Cek session`.
12. Settings: `Cek Gallery`.
13. Settings: `Cek Backup`.
14. Settings: `Backup sekarang`.
15. Verify backup JSON appears in Drive `backups/`.
16. Confirm Dio base URL is the intended production endpoint (not a local/dev URL).

## Safety

- Do not commit real URLs, secrets, or tokens.
- Do not print session tokens.
- Do not add auth bypasses.
- Do not expose Drive public URLs.
