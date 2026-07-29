# Environment & configuration

> Single owner for client vs server configuration names.

**Related:** [deployment.md](./deployment.md) · [api-proxy.md](./api-proxy.md) · [security.md](./security.md) · [packages.md](./packages.md)

---

## 1. Canonical client variable

| Name | Owner | Purpose |
| --- | --- | --- |
| **`API_BASE_URL`** | Flutter app (Dio `BaseOptions.baseUrl`) | Full URL for Apps Script `/exec` **or** self-hosted proxy base that accepts the same JSON POST body |

All Flutter docs, dart-defines, Settings debug labels, and CI release pipelines **must** use `API_BASE_URL` for the client.

---

## 2. Server / proxy-only variable

| Name | Owner | Purpose |
| --- | --- | --- |
| **`APPS_SCRIPT_URL`** | Optional reverse proxy / backend only | Real Apps Script `/exec` URL when the mobile app talks to a proxy instead of Apps Script directly |

Flutter **does not** read `APPS_SCRIPT_URL` unless a custom native config explicitly aliases it (discouraged). Prefer one client name: `API_BASE_URL`.

---

## 3. Flavors / environments

| Env | `API_BASE_URL` | Logging | Notes |
| --- | --- | --- | --- |
| **dev** | local proxy or dev Apps Script deployment | verbose AppLog (redacted) | developers’ machines |
| **staging** | staging `/exec` or staging proxy | info | optional second GAS deployment |
| **production** | production `/exec` or production proxy | warn/error only | store builds |

Implementation options (pick one and document in repo README when coded):

1. `--dart-define=API_BASE_URL=...` per run/build  
2. `--dart-define-from-file=env/dev.json`  
3. Flutter flavors (`dev`, `staging`, `prod`) each baking defines  

---

## 4. dart-define

```bash
# Dev
flutter run --dart-define=API_BASE_URL=https://script.google.com/macros/s/DEV_ID/exec

# Release Android
flutter build appbundle --dart-define=API_BASE_URL=https://script.google.com/macros/s/PROD_ID/exec

# Release iOS
flutter build ipa --dart-define=API_BASE_URL=https://script.google.com/macros/s/PROD_ID/exec
```

Optional defines:

| Define | Default | Purpose |
| --- | --- | --- |
| `API_BASE_URL` | **required** for real backend | Dio base |
| `LOG_LEVEL` | `info` | `debug` / `info` / `warn` |
| `APP_ENV` | `dev` | `dev` / `staging` / `prod` |

Read in Dart:

```dart
const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
```

Empty `API_BASE_URL` in release → fail fast at startup with developer-facing message (do not ship silent misconfig).

---

## 5. Apps Script Script Properties (backend)

Not Flutter env — configured in Apps Script project:

| Property | Purpose |
| --- | --- |
| `SHEET_ID` | Spreadsheet id |
| `SESSION_SECRET` | session hashing/signing secret |
| `PAIRING_WINDOW_SECONDS` | default 30 |
| `DRIVE_ROOT_FOLDER_ID` | Drive root for gallery/backups |

---

## 6. Configuration ownership

| Config | Code owner |
| --- | --- |
| `API_BASE_URL` | `lib/core/config/app_config.dart` |
| Timeouts | `lib/core/network/` |
| Secure storage keys | `lib/core/storage/storage_keys.dart` |
| Feature flags (if any) | `app_config.dart` — none required for v1 |

---

## 7. Secret handling

- Never commit real production `/exec` URLs if team policy forbids (use CI secrets).
- Never commit `SESSION_SECRET`, sheet IDs with public ACL mistakes, or session tokens.
- Track only `env.example.json` / `.env.example` with placeholders.
- Local ignored files: `.env`, `env/dev.local.json`, `android/key.properties`.

### Example `env.example.json`

```json
{
  "API_BASE_URL": "https://script.google.com/macros/s/PLACEHOLDER/exec",
  "APP_ENV": "dev",
  "LOG_LEVEL": "debug"
}
```

---

## 8. Consistency rule (all docs)

When referring to the Flutter HTTP endpoint, write **`API_BASE_URL`**.  
When referring to a server-side proxy’s upstream, write **`APPS_SCRIPT_URL`**.  
Do not invent `VITE_API_URL` or other web-era names in Flutter docs.
