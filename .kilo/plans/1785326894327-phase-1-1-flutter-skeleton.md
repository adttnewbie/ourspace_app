# Plan: Phase 1 Step 1.1 — Flutter project skeleton

## Goal

Rapikan skeleton Flutter **existing** (bukan `flutter create` ulang) menjadi shell runnable: `lib/main.dart` + `lib/app.dart`, struktur feature-first, `ProviderScope` placeholder, placeholder UI. **Tidak** implement pairing/home/notes/config/theme/router produk.

**SSOT:** `docs/implementation-order.md` §1.1 · `docs/architecture.md` · `docs/coding-standard.md` §2 · `docs/packages.md` (minimal) · user scope override (repo sudah create).

## Current state (verified)

| Item | State |
| --- | --- |
| Project | `ourspace_app` Flutter exists (Android/iOS, `pubspec.yaml`) |
| `lib/main.dart` | **Broken** — `const new({super.key})`, no `main()`, incomplete `MaterialApp` |
| Folders | Empty non-canonical `lib/screens/`, `lib/widgets/` |
| Deps | Only `flutter` + `cupertino_icons`; **no** `flutter_riverpod` |
| `test/` | Empty (no `widget_test.dart`) |
| SDK | `^3.14.0-65.0.dev` (master channel) — leave as-is |

## Decisions (locked)

1. **Scope = tidy existing**, not re-create project or touch product features.
2. **Deps for 1.1 only:** add `flutter_riverpod: ^2.6.0` (ProviderScope). Defer `go_router`, `dio`, secure storage, fonts, lucide, connectivity to later steps (1.2–1.9). Keep `cupertino_icons` + `flutter_lints` as-is.
3. **`app.dart` for 1.1:** `MaterialApp` (not `MaterialApp.router`) + simple `home:` placeholder. Router shell is **step 1.8**.
4. **`ProviderScope` in 1.1:** wrap app at bootstrap so 1.9 only deepens overrides/tests — matches user instruction and coding-standard intent without inventing providers.
5. **No product routes/providers/API fields.** No `AppRoutes`, no feature screens, no env/`API_BASE_URL` (1.2).
6. **Empty dirs:** create tree + `.gitkeep` so git tracks folders; no feature Dart code.
7. **Remove** obsolete `lib/screens/`, `lib/widgets/` (empty, non-docs).
8. **Do not** change docs business logic, `design.md`, or invent routes.

## Target structure

```text
lib/
  main.dart                 # void main() => runApp(ProviderScope(child: OurSpaceApp()))
  app.dart                  # OurSpaceApp → MaterialApp + placeholder home
  core/
    config/.gitkeep
    theme/.gitkeep
    network/.gitkeep
    storage/.gitkeep
    error/.gitkeep
    router/.gitkeep
    connectivity/.gitkeep
  shared/
    widgets/.gitkeep
    extensions/.gitkeep
    utils/.gitkeep
  features/
    session/.gitkeep
    pairing/.gitkeep
    home/.gitkeep
    notes/.gitkeep
    gallery/.gitkeep
    dates/.gitkeep
    lists/.gitkeep
    settings/.gitkeep
```

(Optional later: nest `data|domain|presentation` per feature when coding that feature — not required for empty 1.1 dirs.)

## Implementation tasks (ordered)

1. **`pubspec.yaml`**
   - Add `flutter_riverpod: ^2.6.0` under `dependencies`.
   - Optionally tighten `description` to product one-liner (non-blocking).
   - Run `flutter pub get`.

2. **`lib/app.dart`**
   - `OurSpaceApp` extends `StatelessWidget`.
   - `MaterialApp`: `debugShowCheckedModeBanner: false`, `title: 'OurSpace'`, `useMaterial3: true` (foundation only; no scrapbook tokens — 1.3).
   - `home:` simple centered placeholder, e.g. text `OurSpace` (or short Indonesian “placeholder skeleton” — no copy-catalog ids required yet).
   - No `GoRouter`, no theme tokens file, no feature imports.

3. **`lib/main.dart`**
   - Valid entry: `void main() { runApp(const ProviderScope(child: OurSpaceApp())); }`
   - Import `flutter_riverpod` + `app.dart`.
   - Fix broken constructor; do not put UI logic in `main`.

4. **Folders**
   - Create `lib/core/*`, `lib/shared/*`, `lib/features/*` as above with `.gitkeep`.
   - Delete empty `lib/screens/`, `lib/widgets/`.

5. **Tests (minimal, optional but recommended for green CI)**
   - If adding anything under `test/`: smoke that `OurSpaceApp` pumps under `ProviderScope` and finds placeholder text. **Not** required by DoD 1.1; only if needed so future default tests don’t break. Prefer no inventing large test suite.

6. **Validate**
   - `dart format` on touched Dart files.
   - `flutter analyze` → clean.
   - `flutter run` (device/emulator/web as available) → shows placeholder.

## Out of scope (explicit)

- 1.2 `AppConfig` / `API_BASE_URL`
- 1.3 Theme tokens / design.md mapping
- 1.4 Shared scrapbook widgets
- 1.5–1.7 Storage, Dio, connectivity
- 1.8 go_router / `AppRoutes` / redirects
- 1.9 Provider overrides for `apiClientProvider`
- Phase 2 pairing/home/notes/settings product code
- Backend / Apps Script
- Committing secrets or real production URLs

## Failure modes / risks

| Risk | Mitigation |
| --- | --- |
| Broken `main` blocks run/analyze | Replace entirely with valid bootstrap |
| Adding all packages.md deps early | Only riverpod for 1.1 |
| Implementing router early “because app.dart says router” | Defer to 1.8; comment optional one-line in plan only, not code comments unless needed |
| Empty dirs untracked | `.gitkeep` |
| Analyzer unused-import after scaffold | Keep imports minimal |

## DoD checklist (step 1.1)

- [ ] `lib/main.dart` valid `main()` + `ProviderScope`
- [ ] `lib/app.dart` with `OurSpaceApp` + placeholder UI
- [ ] Feature-first folder tree under `lib/` per architecture/coding-standard
- [ ] Obsolete `lib/screens`, `lib/widgets` removed
- [ ] `flutter_riverpod` in `pubspec.yaml` (+ lockfile after pub get)
- [ ] No product routes/providers/API fields/pairing/home/notes logic
- [ ] `flutter analyze` clean
- [ ] `flutter run` shows placeholder

## Files expected to touch

| File | Action |
| --- | --- |
| `pubspec.yaml` | Add riverpod |
| `pubspec.lock` | Via `flutter pub get` |
| `lib/main.dart` | Rewrite |
| `lib/app.dart` | Create |
| `lib/core/**`, `lib/shared/**`, `lib/features/**` | Create + `.gitkeep` |
| `lib/screens/`, `lib/widgets/` | Delete |
| `test/widget_test.dart` | Optional smoke only |

## Validation commands

```bash
flutter pub get
dart format lib
flutter analyze
flutter run   # or flutter run -d linux / chrome if no device
```

## Post-step note for sequential work

Next prompt should be **1.2 Core config & env** only (`AppConfig` + `API_BASE_URL`), then 1.3, … one step per prompt.
