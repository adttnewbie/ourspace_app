# Performance Notes (Flutter)

OurSpace Flutter client + Google Apps Script: tujuan utama menghindari repeated calls dan membuat momen jaringan lambat terasa intentional.

## Optimized Paths

- `session.resume` di-cache in-memory TTL pendek. Manual Settings checks tetap force fresh validation.
- Identical in-flight safe read requests di-dedupe di API client Dio layer.
- Home, Notes, Date Plans, dan Shared Lists menyimpan last-known JSON payload di cache lokal ringan (memory + optional shared_preferences) dan refresh di background.
- Gallery list cache memory-only karena `thumbnailData` bisa berisi base64; jangan persist ke storage.
- Create/update/delete update list lokal setelah backend success (bukan full refetch).
- Home summary membatasi Gallery item agar thumbnail tidak memperlambat first Home render.
- `home.get` idealnya include Home summary (satu request). Client boleh compatibility fallback untuk Apps Script lama.
- Feature screens di-lazy load via `go_router` deferred routes / code splitting patterns where practical.
- Loading memakai compact scrapbook skeleton, bukan blank atau spinner-only besar.

## Cache TTLs

- `home.get`: 45 seconds.
- `notes.list`: 60 seconds.
- `datePlans.list`: 60 seconds.
- `sharedLists.list`: 60 seconds.
- `gallery.list`: 60 seconds, memory only.

Jika cache ada, screen menampilkan cache dulu + status pill "Lagi nyegerin data..." sambil background refresh. Jika refresh gagal, UI cache tetap + soft warning. Jika tidak ada cache, skeleton layout-matched lalu error state jika gagal.

Saat offline, cache terakhir tetap boleh dibaca meski TTL lewat. Tidak ada background refresh sampai connectivity online. Detail di [Offline State UX](./offline.md).

## In-flight Dedupe

Safe reads yang di-dedupe:

- `health.check`
- `session.resume`
- `couple.status`
- `home.get`
- `notes.list`
- `datePlans.list`
- `gallery.list`
- `sharedLists.list`
- `gallery.health`
- `backup.health`
- `backups.list`

Mutations dan state-changing actions **tidak** di-dedupe:

- create/update/delete
- `pairing.start`
- `pairing.signal`
- `session.recover`
- backup run / reset pairing

## Flutter-specific

- Prefer `const` widgets, selective Riverpod rebuilds (`select`, `family`).
- Decode gallery thumbnails off main isolate if large.
- Image memory: use bounded cache; clear on memory pressure when practical.
- Avoid rebuilding entire `AppShell` on list updates.
- Pairing poll 1–2s only in waiting; cancel timers on dispose.
- Keep list item widgets stable keys (`id`).

## Backend constraints (unchanged)

- Apps Script cold start can be slow — skeletons + cache hide latency.
- Spreadsheet reads remain source of truth; any server cache miss is safe.
- Gallery payload grows with base64 thumbnails; large photos may use placeholders.
- Backup is heavy — manual/triggered only, not part of normal page load.

## Manual Checks

1. Buka protected screens dua kali; visit kedua reuse cache.
2. Navigate Notes ↔ Dates ↔ Gallery ↔ Lists ↔ Settings; shell tetap; body swap cepat.
3. Create/edit/delete item; list update tanpa full app restart.
4. Confirm no duplicate simultaneous identical API requests.
5. Confirm client still hits configured API base (proxy/direct as documented).
6. Apps Script logs may show spreadsheet cache-hit on repeated reads.
