# Offline State UX (Flutter)

Phase offline menambahkan penanganan kondisi jaringan tanpa mengubah OurSpace menjadi aplikasi offline-first.

## Yang Bisa Dilakukan Saat Offline

- `AppShell` dan bottom navigation tetap dapat dipakai jika session lokal (`flutter_secure_storage`) masih tersedia.
- Home, Notes, Dates, dan Shared Lists menampilkan data terakhir dari cache list (in-memory + optional `shared_preferences` / Hive), termasuk cache yang TTL-nya sudah lewat selama device masih offline.
- Gallery dapat menampilkan cache terakhir yang masih ada di memory pada sesi app yang sama. Cache Gallery tidak dipersist karena dapat berisi thumbnail base64.
- Halaman yang mempunyai cache menampilkan `OfflineNotice` dan tetap membiarkan pengguna membaca data.
- Route `/offline` menyediakan penjelasan, tombol coba lagi, dan tombol kembali.

Cache hanya berisi payload data yang sebelumnya sudah dipakai aplikasi. Fase ini tidak menambahkan cache baru untuk `sessionToken`.

## Yang Tidak Bisa Dilakukan Saat Offline

- Membuat, mengedit, atau menghapus Notes, Dates, Gallery, dan Shared Lists.
- Upload foto.
- Pairing dan recovery session.
- Pemeriksaan API, session, Gallery, dan Backup di Settings.
- Menjalankan backup atau reset pairing.

Mutasi offline langsung diblokir dengan pesan yang ramah (toast / dialog). Mutasi **tidak** masuk antrean dan **tidak** dijalankan otomatis setelah koneksi kembali.

## Perilaku Tanpa Cache

Jika halaman belum pernah dibuka dan tidak mempunyai cache, skeleton tidak ditampilkan tanpa batas. Halaman menunjukkan bahwa belum ada data tersimpan di device dan meminta pengguna menyambungkan internet terlebih dahulu.

Sumber status jaringan Flutter:

- `connectivity_plus` (atau setara) untuk online/offline.
- Kegagalan `Dio` (timeout, connection error) dinormalisasi menjadi `NETWORK_OFFLINE`, sehingga UI tidak menampilkan pesan error mentah dari platform.

## Batasan Fase Ini

- Tidak ada offline mutation queue.
- Tidak ada conflict resolution atau background sync penuh.
- Cache device bukan backup dan dapat hilang ketika app data dibersihkan.
- Tidak ada service-worker style asset caching (konsep web); Flutter mengandalkan cache API layer + asset build.

## Widget & state

| Piece | Role |
| --- | --- |
| `OfflineNotice` | Banner kuning di atas konten cached |
| `OfflineEmptyState` | Card kuning saat no-cache |
| Offline route | Bantuan full-page |
| Mutation guard | Cek online sebelum create/update/delete/upload |
