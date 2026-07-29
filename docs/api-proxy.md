# API access (Flutter network)

## Historical web note

Pada web, browser call langsung ke Google Apps Script sering gagal dibaca JS karena CORS. Solusi web memakai same-origin proxy. **OurSpace target adalah Flutter mobile**, yang tidak tunduk pada CORS browser.

## Flutter default path

```text
Flutter app (Dio)
  -> POST JSON to API_BASE_URL
Google Apps Script Web App (/exec)
  -> SpreadsheetApp / DriveApp
```

`API_BASE_URL` biasanya di-set ke URL `/exec`. Lihat [environment.md](./environment.md).

## Optional proxy

Proxy tetap relevan jika:

- Target Flutter **web** di masa depan (CORS).
- Tim ingin menyembunyikan `/exec` di belakang backend sendiri.
- Perlu rate-limit / edge logging.

Jika proxy dipakai:

```text
Flutter (Dio) -> API_BASE_URL (proxy)
Proxy server  -> APPS_SCRIPT_URL (/exec)   # server env only
```

## Konfigurasi client

```bash
flutter run --dart-define=API_BASE_URL=https://script.google.com/macros/s/xxx/exec
```

Jangan commit URL production jika kebijakan melarang; track placeholder saja.

## Manual test

Settings → `Cek koneksi` → `health.check` lewat ApiClient yang sama dengan pairing.
