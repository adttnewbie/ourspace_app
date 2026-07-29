# Data Model

## Konvensi umum

Semua sheet data user memakai kolom dasar:

- `id`: UUID/string unik.
- `createdAt`: ISO timestamp.
- `updatedAt`: ISO timestamp.
- `createdBy`: `memberId` pembuat.
- `deletedAt`: kosong jika aktif, ISO timestamp jika soft-deleted.

Soft delete lebih aman untuk app personal karena data kenangan sulit diganti.

Di Flutter, model domain mirror struktur ini (nullable `deletedAt`, ISO strings diparse ke `DateTime` di layer client jika perlu).

## Sheet: `members`

Menyimpan dua device utama yang berhasil pairing.

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| id | string | `memberId` |
| nickname | string | Diisi saat pairing |
| deviceLabel | string | Contoh: `device_a`, `device_b` |
| sessionTokenHash | string | Hash token session, bukan token mentah |
| pairedAt | string | ISO timestamp sukses pairing |
| lastSeenAt | string | ISO timestamp request terakhir |
| createdAt | string | ISO timestamp |
| updatedAt | string | ISO timestamp |
| deletedAt | string | Kosong jika aktif |

## Sheet: `pairing_sessions`

Menyimpan proses hold button sebelum pasangan terikat.

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| id | string | UUID |
| status | string | `waiting`, `paired`, `expired`, `cancelled` |
| firstNickname | string | Nickname device pertama |
| firstSignalAt | string | ISO timestamp |
| secondNickname | string | Nickname device kedua |
| secondSignalAt | string | ISO timestamp |
| pairedAt | string | ISO timestamp sukses |
| expiresAt | string | `firstSignalAt + 30 detik` |
| memberAId | string | Terisi saat paired |
| memberBId | string | Terisi saat paired |
| createdAt | string | ISO timestamp |
| updatedAt | string | ISO timestamp |

## Sheet: `couple_settings`

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| key | string | Nama setting |
| value | string | Value sebagai string/JSON |
| updatedAt | string | ISO timestamp |

Setting v1:

- `anniversaryDate`: timestamp sukses pairing dari backend.
- `coupleName`: opsional untuk label bersama.
- `theme`: default `pastel_scrapbook`.
- `driveRootFolderId`: folder Drive fase lanjut.
- `backupFolderId`: folder backup fase lanjut.

## Sheet: `sticky_notes`

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| id | string | UUID |
| body | string | Isi sticky note pendek |
| color | string | Key warna pastel, contoh `pink`, `mint`, `yellow`, `blue`, `lavender` |
| createdBy | string | `memberId` pembuat |
| createdAt | string | ISO timestamp |
| updatedAt | string | ISO timestamp |
| deletedAt | string | Kosong jika aktif |

Aturan:

- Tidak perlu title pada v1.
- Edit/hapus hanya boleh dilakukan oleh `createdBy`.
- Notes diurutkan dari `createdAt` terbaru.
- Flutter map `color` → `ScrapTone` / `AppColors.scrap*`.

## Sheet fase lanjut: `date_plans`

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| id | string | UUID |
| title | string | Nama date |
| scheduledAt | string | ISO timestamp atau tanggal |
| locationName | string | Nama tempat |
| status | string | `idea`, `planned`, `done`, `cancelled` |
| notes | string | Catatan |
| createdBy | string | `memberId` pembuat |
| createdAt | string | ISO timestamp |
| updatedAt | string | ISO timestamp |
| deletedAt | string | Kosong jika aktif |

## Sheet fase lanjut: `gallery`

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| id | string | UUID |
| fileId | string | Google Drive file ID |
| fileName | string | Nama file |
| mimeType | string | `image/jpeg`, `image/png`, atau `image/webp` |
| fileSize | number | Max 3 MB |
| thumbnailData | string | Base64 thumbnail kecil untuk preview private |
| caption | string | Wajib |
| takenAt | string | Wajib, tanggal foto/momen |
| createdBy | string | `memberId` pembuat |
| createdAt | string | ISO timestamp |
| updatedAt | string | ISO timestamp |
| deletedAt | string | Kosong jika aktif |

Aturan:

- Gallery hanya foto, bukan video.
- File Drive tetap private.
- Preview app memakai thumbnail dari API, bukan public link.
- Flutter: `thumbnailData` memory-only cache; jangan persist ke secure/shared storage.

## Sheet fase lanjut: `shared_lists`

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| id | string | UUID |
| title | string | Item list |
| category | string | `place`, `food`, `movie`, `gift`, `activity`, dll |
| status | string | `todo`, `doing`, `done` |
| notes | string | Catatan |
| createdBy | string | `memberId` pembuat |
| createdAt | string | ISO timestamp |
| updatedAt | string | ISO timestamp |
| deletedAt | string | Kosong jika aktif |

## Sheet fase lanjut: `backups`

| Kolom | Tipe | Catatan |
| --- | --- | --- |
| id | string | UUID |
| fileId | string | File backup di Drive |
| status | string | `success` atau `failed` |
| message | string | Ringkasan hasil |
| createdAt | string | ISO timestamp |
| updatedAt | string | ISO timestamp |

## Folder Drive

Struktur minimal:

```text
OurSpace/
  gallery/
  backups/
```

Simpan ID folder di Apps Script Properties dan mirror non-secret di `couple_settings` jika perlu.

## Flutter domain mapping

Paths aligned with [coding-standard.md](./coding-standard.md) / [architecture.md](./architecture.md):

| Sheet / entity | Dart model location |
| --- | --- |
| members | `lib/features/session/domain/member.dart` |
| pairing_sessions | `lib/features/pairing/domain/pairing_session.dart` |
| sticky_notes | `lib/features/notes/domain/sticky_note.dart` |
| date_plans | `lib/features/dates/domain/date_plan.dart` |
| gallery | `lib/features/gallery/domain/gallery_item.dart` |
| shared_lists | `lib/features/lists/domain/shared_list_item.dart` |
| couple_settings | `lib/features/settings/domain/couple_settings.dart` |
| home aggregate | `lib/features/home/domain/home_snapshot.dart` |

DTO counterparts live under each feature’s `data/dto/` with `*Dto` suffix.
