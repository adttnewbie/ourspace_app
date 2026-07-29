# Packages

> Dependency intent for OurSpace Flutter. Versions are **minimum guidance** — pin exact versions in `pubspec.yaml` / lockfile at implementation time.

**Related:** [architecture.md](./architecture.md) · [coding-standard.md](./coding-standard.md) · [environment.md](./environment.md)

---

## 1. Runtime dependencies

| Package | Min guidance | Why | Alternative |
| --- | --- | --- | --- |
| `flutter` SDK | project constraint | UI framework | — |
| `flutter_riverpod` | ^2.6.0 | State management, DI | bloc (rejected for this product’s simplicity) |
| `go_router` | ^14.0.0 | Declarative routes, shell, redirects | Navigator 2 manual |
| `dio` | ^5.7.0 | HTTP client, interceptors, timeouts | `http` (less interceptor ergonomics) |
| `flutter_secure_storage` | ^9.2.0 | `memberId` + `sessionToken` | encrypted hive (heavier) |
| `shared_preferences` | ^2.3.0 | Optional non-sensitive TTL cache flags/JSON | hive_ce |
| `connectivity_plus` | ^6.0.0 | Online/offline stream | pure Dio-fail only (weaker UX) |
| `intl` | ^0.19.0 | `id_ID` dates, numbers | manual format |
| `google_fonts` | ^6.2.0 | Single scrapbook font family | bundled font assets |
| `lucide_icons` | ^0.257.0 | One stroke icon set matching design | `cupertino_icons` only (insufficient) |
| `collection` | SDK-adjacent | list helpers | — |
| `meta` | SDK-adjacent | annotations | — |
| `uuid` | ^4.0.0 | Client-side ids if ever needed (server prefers own ids) | — |
| `path_provider` | later | file paths if gallery temp | — |
| `image_picker` | later phase gallery | pick camera/gallery photos | — |
| `equatable` or `freezed_annotation` | optional | value equality | hand equality |

### Codegen (recommended, not mandatory)

| Package | Role |
| --- | --- |
| `freezed` + `freezed_annotation` | Immutable models / unions |
| `json_serializable` + `json_annotation` | DTO fromJson |
| `build_runner` | dev codegen |
| `riverpod_annotation` + `riverpod_generator` | optional providers |

If codegen is deferred, hand-written models **must** still follow DTO/domain split.

---

## 2. Dev dependencies

| Package | Why |
| --- | --- |
| `flutter_test` | widget/unit |
| `flutter_lints` | analyzer rules |
| `mocktail` | mocks |
| `integration_test` | device flows |

---

## 3. Android permissions

| Permission | When | Manifest / usage |
| --- | --- | --- |
| `INTERNET` | always | required for API |
| `ACCESS_NETWORK_STATE` | with connectivity_plus | optional but useful |
| Camera / photos | **gallery phase** | `image_picker` docs for Android 13+ photo permission |
| Storage write | generally **not** for v1 | avoid broad storage |

v1 (Pairing + Home + Notes): **INTERNET** (+ network state) only.

---

## 4. iOS permissions

| Key | When | Usage string (ID) |
| --- | --- | --- |
| None extra for v1 | network only | — |
| `NSPhotoLibraryUsageDescription` | gallery phase | short honest reason |
| `NSCameraUsageDescription` | if camera capture | short honest reason |

Add keys **only** when the feature ships — empty unused permission strings fail review.

---

## 5. What not to add (v1)

- Firebase Auth / OAuth packages (non-goal)
- Full offline sync databases as source of truth
- Multiple icon packs
- Web-only CORS proxy packages inside the mobile app
- Heavy analytics SDKs that capture PII by default

---

## 6. Version policy

- Commit `pubspec.lock` for apps.
- Prefer caret ranges in `pubspec.yaml`, lockfile for CI reproducibility.
- Run `flutter pub outdated` before release; do not jump major Dio/Riverpod without reading changelogs.
