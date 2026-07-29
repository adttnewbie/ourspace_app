# Screen Spec: Home

**Route:** `/` (`AppRoutes.home`) · **Shell:** yes · **Auth:** required · **v1:** yes  
**Providers:** `homeProvider`, `notesListProvider` (optional for quick add), `sessionControllerProvider`, `connectivityProvider`  
**Related:** [ui-direction.md](../ui-direction.md) · [api-contract.md](../api-contract.md) · [design.md](../../design.md)

---

## Purpose

First personal surface after pairing: greeting with nickname, days-together counter, quick sticky add, summary entry points, and “terbaru hari ini” when items exist for today.

---

## Layout hierarchy

```text
AppShell
└── HomeScreen (ScrollView)
    ├── OfflineNotice? (if offline)
    ├── StatusPill? (refreshing / soft warning)
    ├── GreetingCard (scrap pink + optional tape)
    │     ├── Greeting text (nickname)
    │     └── Days together counter
    ├── QuickAddStickyCard
    │     ├── Color swatches (5)
    │     ├── Short text field
    │     └── Submit (Send) button
    ├── Summary row/stack
    │     ├── SummaryCard → Notes
    │     ├── SummaryCard → Gallery (later / coming soon)
    │     └── SummaryCard → Dates (later / coming soon)
    └── TodaySection? (only if today items non-empty)
          └── StickyNoteCard* (mini)
```

---

## Widget hierarchy (recommended)

- `HomeScreen` → watches `homeProvider`
- `GreetingCard` (`ScrapbookCard` tone pink)
- `QuickAddSticky` (local draft + `NotesRepository.create` or home quick-add API if same `notes.create`)
- `SummaryCard` (tappable `ScrapbookCard`)
- `TodayNotesSection` + `StickyNoteCard` (compact)
- Skeletons: `HomeSkeleton`

---

## Component list

| Component | Design ref |
| --- | --- |
| ScrapbookCard | design.md |
| PageHeader | optional on home (home may skip formal header) |
| Status pill | yellow scrap |
| Color swatches | 32 circle, selected ring |
| AppTextField / AppTextArea compact | quick add |
| AppButton icon Send | submit note |
| SummaryCard | icon + meta + title + description |
| StickyNoteCard mini | home density |
| HomeSkeleton / error / empty fragments | |

---

## Actions

| Action | Behavior |
| --- | --- |
| Submit quick note | Online guard → `notes.create` → clear draft → refresh home/notes |
| Tap Summary Notes | `context.go(AppRoutes.notes)` |
| Tap Gallery/Dates | go route or coming soon |
| Pull refresh (optional) | force `homeProvider` refresh |
| Retry on error | invalidate `homeProvider` |
| Tap today note | optional open notes / edit if owner — v1 may be view-only on home |

---

## Navigation

| From | To |
| --- | --- |
| Summary cards | `/notes`, `/gallery`, `/dates` |
| Bottom nav | other tabs |
| Auth loss | `/pairing` |

---

## Provider usage

- `ref.watch(homeProvider)` for snapshot.
- Quick add: `ref.read(notesRepositoryProvider).create` then `ref.invalidate(homeProvider)` + notes list.
- `ref.watch(connectivityProvider)` for guards + notice.

---

## States

| State | UI |
| --- | --- |
| Loading no cache | `HomeSkeleton` |
| Loading with cache | content + status pill |
| Data | full layout |
| Empty today | **hide** TodaySection entirely |
| Error no cache | pink error card + retry |
| Offline + cache | OfflineNotice + content |
| Offline no cache | OfflineEmptyState |

---

## Permissions

None beyond network. No OS photo permission on home.

---

## Animation

- Subtle card press on SummaryCard.
- Quick add button busy spinner.
- No ambient loops.

---

## Validation

- Quick note body: required non-empty trim; maxLength 280 (align notes).
- Color: one of `yellow|pink|mint|blue|lavender`.
- Disable submit when empty or offline or submitting.

---

## Edge cases

- `daysTogether` from backend; do not recompute anniversary from device clock as source of truth.
- Hide today section when empty (not empty-state card).
- Home summary should not load heavy gallery thumbnails (API/performance: limit gallery items).
- Nickname missing fallback: generic greeting copy (`copy.home.greeting_fallback`).

---

## Business rules

- Personal, Indonesian casual greeting.
- Counter from `anniversaryDate` / `daysTogether` in `home.get`.
- Quick add creates sticky owned by current member.

---

## Ownership rules

- Today notes show author nickname; edit/delete only if exposed and `canEdit` — prefer full edit on Notes screen.

---

## Responsive

- Single column; padding 16/20; max width via shell 480.
- Summary cards stack vertically (not multi-column dashboard).

---

## Accessibility

- Greeting and days counter as clear text semantics.
- Color swatches: selected state + labels (“Warna pink”).
- Summary cards: button semantics with destination name.
- Status pill polite live region when refreshing.
