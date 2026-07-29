# MVP Roadmap (Flutter)

## Phase 0: Blueprint docs

Goal: keputusan produk dan teknis tidak tercecer.

- Sinkronkan product brief, architecture, data model, API contract, pairing flow, UI direction, design system Flutter.
- Tegaskan batas v1: Pairing + Home + Sticky Notes.
- Tandai Date Plans, Gallery, Shared Lists, dan backup otomatis sebagai fase lanjut.

## Phase 1: Flutter foundation

Goal: app siap untuk UI mobile scrapbook.

- Setup `ThemeData` + design tokens dari [design.md](../design.md).
- Shared widgets: ScrapbookCard, AppButton, AppTextField, PageHeader, AppShell.
- Setup `go_router` + Riverpod.
- Setup secure storage session keys.
- Setup Dio API client + env/dart-define `API_BASE_URL`.
- Bottom navigation shell (Home, Notes, Gallery, Dates, More).
- System UI / splash / icons aligned to cream scrapbook.

## Phase 2: Google resources

Goal: backend punya sumber data awal.

- Buat Spreadsheet dari nol sesuai [Data Model](./data-model.md).
- Buat folder Drive `OurSpace/gallery` dan `OurSpace/backups`.
- Buat Apps Script Web App.
- Simpan `SHEET_ID`, `DRIVE_ROOT_FOLDER_ID`, `SESSION_SECRET`, dan `PAIRING_WINDOW_SECONDS` di Script Properties.
- Putuskan proxy vs direct + CORS/headers.

## Phase 3: Pairing onboarding

Goal: dua device bisa terikat lewat hold button.

- Screen pairing + input nickname.
- Tombol lingkaran hold 3 detik.
- Waiting state saat baru satu device mengirim sinyal.
- Polling `pairing.status` tiap 1-2 detik selama waiting.
- Sukses pairing simpan `memberId` + `sessionToken` di secure storage.
- `anniversaryDate` dari timestamp backend.

## Phase 4: Home scrapbook

Goal: setelah pairing, app langsung terasa personal.

- Greeting personal bahasa Indonesia santai.
- Counter hari bersama.
- Quick add sticky note.
- Section terbaru hari ini (sembunyikan jika kosong).
- Visual pastel colorful, scrapbook, motion halus.

## Phase 5: Sticky Notes

Goal: fitur CRUD pertama end-to-end dari Flutter sampai Spreadsheet.

- List sticky notes.
- Create sticky note pendek.
- Edit/soft delete hanya oleh pembuat.
- Author sebagai nickname.
- Loading, error, empty, offline states.

## Phase 6: Date Plans

Goal: rencana date simple.

- List date plans.
- Create/edit date plan.
- Status chip: `idea`, `planned`, `done`, `cancelled`.
- Sort by date + list/calendar tabs.

## Phase 7: Gallery private

Goal: foto tersimpan private di Drive dan tetap bisa dipreview di app.

- Upload foto saja, max 3 MB.
- Caption dan tanggal wajib.
- Original di private Drive.
- Metadata + thumbnail kecil di Spreadsheet.
- Grid dari thumbnail API (memory-only cache).

## Phase 8: Backup otomatis

Goal: data lebih aman tanpa operasi manual.

- Apps Script trigger berkala.
- Export Spreadsheet data ke JSON.
- Simpan backup ke folder Drive `OurSpace/backups`.
- Catat hasil di sheet `backups`.
- Settings: health + manual backup trigger.

## Build order paling aman

1. Docs blueprint (Flutter).
2. Theme, shared widgets, go_router, Riverpod, Dio.
3. API client + models.
4. Apps Script Spreadsheet helpers.
5. Pairing end-to-end.
6. Home.
7. Sticky Notes.
8. Date Plans.
9. Gallery.
10. Backup otomatis.
