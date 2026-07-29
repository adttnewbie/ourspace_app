# Architecture

## Ringkasan

Aplikasi Flutter memanggil Google Apps Script Web App sebagai API lewat Dio (HTTP POST JSON). Apps Script menyimpan data pairing, session, home, dan notes ke Google Spreadsheet. Google Drive dipakai untuk gallery dan backup pada fase lanjut.

```text
Flutter app (Riverpod + go_router + Dio)
  -> HTTPS POST JSON
Google Apps Script Web App
  -> SpreadsheetApp
  -> DriveApp (fase lanjut)
Google Spreadsheet + Google Drive
```

Tidak ada browser CORS layer. Client mobile native memanggil **`API_BASE_URL`** (biasanya URL `/exec` Apps Script, atau base proxy). Lihat [environment.md](./environment.md). Jangan hardcode production URL di source yang di-commit.

## Client (Flutter)

Stack target:

- Flutter + Dart.
- Riverpod untuk state management.
- go_router untuk routing & deep links internal.
- Dio untuk HTTP client.
- Theme/design tokens scrapbook (lihat `design.md`).
- `flutter_secure_storage` untuk session secrets.
- Optional: `shared_preferences` / Hive untuk cache non-sensitif ber-TTL.

Route v1:

- `/pairing`
- `/` home
- `/notes`
- `/settings`

Route fase lanjut:

- `/gallery`
- `/dates`
- `/lists`
- `/offline` (UX network)

Navigasi mobile memakai bottom tabs (`NavigationBar` / custom dalam `AppShell`):

- Home
- Notes
- Gallery
- Dates
- More (settings)

Tab yang belum aktif boleh disabled atau menampilkan "segera hadir".

Struktur folder disarankan (feature-first):

```text
lib/
  main.dart
  app.dart
  core/           # config, theme, network, storage, error, router, connectivity
  shared/         # widgets scrapbook reusable, extensions, utils
  features/
    session/      # resume / gate
    pairing/
    home/
    notes/
    gallery/      # fase lanjut
    dates/        # fase lanjut
    lists/        # fase lanjut
    settings/
```

Detail layering: [coding-standard.md](./coding-standard.md). Routing: [routing.md](./routing.md). State: [state-management.md](./state-management.md).

## Backend API

Apps Script Web App menyediakan satu endpoint `doPost(e)` untuk semua action. Client mengirim JSON dengan bentuk umum:

```json
{
  "action": "notes.create",
  "memberId": "member_123",
  "sessionToken": "session_abc",
  "payload": {}
}
```

Jangan memakai `GET` untuk data private karena token akan lebih mudah bocor lewat URL/log.

## Database

Google Spreadsheet dipakai sebagai database tabular. Sheet v1:

- `members`
- `pairing_sessions`
- `couple_settings`
- `sticky_notes`

Gunakan `id` berbasis UUID/string unik untuk semua row. Jangan pakai nomor baris sebagai ID karena urutan sheet bisa berubah.

Sheet fase lanjut:

- `date_plans`
- `gallery`
- `shared_lists`
- `backups`

## Session dan pairing

- Pairing pertama mengikat dua device utama.
- Setiap device menyimpan `memberId` dan `sessionToken` di **secure storage** (`flutter_secure_storage`).
- Apps Script memvalidasi `memberId` dan `sessionToken` untuk request setelah pairing.
- `memberId` menentukan ownership item.
- Hanya pembuat item yang boleh edit/hapus.

Pairing memakai polling ringan:

- Client mengirim sinyal setelah tombol ditahan 3 detik.
- Client memanggil status tiap 1–2 detik saat waiting state (Timer / Riverpod).
- Pairing sukses jika dua sinyal valid masuk dalam window 30 detik.

## Secrets

Simpan konfigurasi sensitif di Apps Script Properties:

- `SHEET_ID`
- `DRIVE_ROOT_FOLDER_ID`
- `SESSION_SECRET`
- `PAIRING_WINDOW_SECONDS`

Di Flutter:

- Client: `API_BASE_URL` lewat `--dart-define` / flavor — **jangan commit URL production** (lihat environment.md).
- Optional proxy server only: `APPS_SCRIPT_URL`.
- `memberId` + `sessionToken` hanya di secure storage device, jangan log.

## Deploy model

- Build & release Flutter Android (AAB/APK) dan iOS.
- Deploy Apps Script sebagai Web App.
- Resource Google dibuat dari nol: Spreadsheet, folder Drive, Apps Script.
- Workflow Apps Script masih dokumentasi dulu; implementasi backend lokal atau `clasp` bisa diputuskan setelah blueprint ini.

## Risiko teknis

- Apps Script punya limit eksekusi dan kuota harian.
- Cold start Apps Script bisa lambat; UI harus jujur (skeleton / status pill).
- Polling terlalu sering bisa membebani Apps Script.
- Upload file besar via Apps Script bisa lambat, jadi gallery dibatasi 3 MB per foto.
- Spreadsheet tidak cocok untuk query kompleks atau data sangat besar.
- Private Drive file tidak bisa langsung dipasang sebagai URL publik tanpa melemahkan privacy.
- Certificate pinning opsional (fase lanjut); minimal HTTPS only.

Mitigasi:

- Polling pairing 1–2 detik hanya saat waiting state.
- Pagination sederhana di API list.
- Simpan timestamp ISO untuk sorting.
- Hindari query lintas-sheet yang berat.
- Untuk gallery private, tampilkan thumbnail/base64 kecil dari API dan simpan file asli di Drive.
- Cache client read-only ber-TTL; mutasi selalu butuh network.
