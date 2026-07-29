# Screen Spec: Notes

**Route:** `/notes` · **Shell:** yes · **Auth:** required · **v1:** yes  
**Providers:** `notesListProvider`, `noteEditorControllerProvider`, `connectivityProvider`, `currentMemberIdProvider`  
**Related:** [api-contract.md](../api-contract.md) · [data-model.md](../data-model.md) · [error-handling.md](../error-handling.md)

---

## Purpose

CRUD list of short pastel sticky notes. Create/edit/delete only by owner; soft delete on backend.

---

## Layout hierarchy

```text
AppShell
└── NotesScreen
      ├── OfflineNotice?
      ├── StatusPill?
      ├── PageHeader (eyebrow + title + PageActionButton create)
      ├── Body
      │     ├── NotesSkeleton | ErrorCard | EmptyCard | NotesGrid/List
      │     └── StickyNoteCard*
      └── Dialogs
            ├── NoteEditorDialog
            └── ConfirmAlertDialog (delete)
```

---

## Widget hierarchy

- `NotesScreen`
- `PageHeader` + `PageActionButton` (Plus)
- `NotesList` / wrap grid
- `StickyNoteCard` (tone, tape, body, author, actions)
- `NoteEditorDialog` (AppTextArea, color picker, save)
- `ConfirmAlertDialog`
- `NotesSkeleton`, empty, error widgets

---

## Component list

| Component | Role |
| --- | --- |
| PageHeader | title Notes |
| PageActionButton | create |
| StickyNoteCard | list item |
| Color picker | 5 scrap tones |
| AppTextArea | max 280 |
| AppButton | save |
| ConfirmAlertDialog | delete |
| Status pill | cache refresh |

---

## Actions

| Action | Who | API |
| --- | --- | --- |
| Open create | any member | dialog empty |
| Save create | any | `notes.create` |
| Open edit | owner only | dialog prefill |
| Save edit | owner | `notes.update` |
| Delete | owner | confirm → `notes.delete` |
| Retry load | any | invalidate list |
| Refresh | any | force fetch |

Non-owners: hide edit/delete affordances (not disabled traps).

---

## Navigation

| From | To |
| --- | --- |
| Bottom nav | other tabs |
| Home summary | `/notes` |
| Dialogs | stay on `/notes` |

---

## Provider usage

- `ref.watch(notesListProvider)`
- Mutations via repository through notifier methods: `create`, `update`, `remove`
- After success: patch list + invalidate home

---

## States

| State | UI |
| --- | --- |
| Loading no cache | NotesSkeleton |
| Loading with cache | list + pill |
| Empty | mint/pink empty card + CTA “Tambah note” |
| Error | pink card + retry |
| Offline + cache | readable list; mutations blocked |
| Offline no cache | OfflineEmptyState |
| Submitting | save button spinner; prevent double |

---

## Permissions

Network only.

---

## Animation

- Card press feedback light.
- Dialog enter fade+scale short.
- No staggered heavy list animations required.

---

## Validation

- `body` required non-empty trim; max 280.
- `color` enum scrap keys.
- Client-side only convenience; server still validates (`BAD_REQUEST`).

---

## Edge cases

- `FORBIDDEN` on edit/delete → toast + refresh list.
- `NOT_FOUND` → remove local item + message.
- Soft-deleted items never shown in list.
- Concurrent edit by same user: last write wins unless `CONFLICT` → message + refresh.
- Text starting with `= + - @` must display as text (Sheets formula safety is backend; UI must not strip).

---

## Business rules

- Short notes, no title field v1.
- Author shown as nickname.
- Sort newest `createdAt` first (server order).

---

## Ownership rules

- Only `createdBy` / `canEdit == true` may update/delete.
- UI hides actions; server enforces.

---

## Responsive

- Phone: single column stack/grid gap 16.
- ≥640: optional 2-column sticky grid if design allows; keep readability.

---

## Accessibility

- Each card: semantics label with body excerpt + author.
- Icon edit/delete: “Edit note”, “Hapus note”.
- Dialog focus trap; close labeled “Tutup dialog”.
- Empty CTA full-width large target.
