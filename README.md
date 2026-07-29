# OurSpace (Flutter)

Private digital scrapbook for exactly two people.  
Flutter client → Google Apps Script → Spreadsheet (+ Drive later).

## Documentation (SSOT)

**Start here for implementation:**

1. [docs/implementation-order.md](./docs/implementation-order.md)  
2. [docs/architecture.md](./docs/architecture.md)  
3. [docs/coding-standard.md](./docs/coding-standard.md)  
4. [design.md](./design.md)  
5. [docs/README.md](./docs/README.md) — full index  

Critical contracts:

- [docs/api-contract.md](./docs/api-contract.md)  
- [docs/pairing-flow.md](./docs/pairing-flow.md)  
- [docs/routing.md](./docs/routing.md)  
- [docs/state-management.md](./docs/state-management.md)  
- [docs/screen-specs/](./docs/screen-specs/)  

## Stack

| Layer | Choice |
| --- | --- |
| App | Flutter (Android + iOS) |
| State | Riverpod |
| Routes | go_router |
| HTTP | Dio → `API_BASE_URL` |
| Session | flutter_secure_storage |
| Backend | Google Apps Script Web App |
| Data | Google Spreadsheet (+ Drive) |

## V1 scope

Pairing hold ritual · Home · Sticky Notes · Settings session tools  

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=https://script.google.com/macros/s/YOUR_ID/exec
```

See [docs/environment.md](./docs/environment.md). Never commit real secrets or session tokens.
