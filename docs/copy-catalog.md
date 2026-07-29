# Copy Catalog (id-ID)

> All user-facing microcopy for OurSpace. Tone: **Indonesia santai**, short, intimate — not corporate.  
> Use **copy id** in code (`AppCopy` / l10n ARB keys).  
> **Related:** [error-handling.md](./error-handling.md) · [screen-specs/](./screen-specs/) · [ui-direction.md](./ui-direction.md)

**Locale:** `id` (default). English not required for v1.

---

## Format

Each entry:

| Field | Meaning |
| --- | --- |
| **copy id** | stable key |
| **screen** | primary surface |
| **message** | default Indonesian string |
| **usage** | when shown |
| **fallback** | if dynamic parts missing |
| **l10n notes** | placeholders |

---

## Pairing

| copy id | screen | message | usage | fallback | l10n notes |
| --- | --- | --- | --- | --- | --- |
| `pairing.title` | pairing | OurSpace | header | — | — |
| `pairing.subtitle` | pairing | Ruang berdua, mulai bareng. | under title | — | — |
| `pairing.nickname_label` | pairing | Nama / nickname kamu | field label | — | — |
| `pairing.nickname_hint` | pairing | Misal: Ae | hint | — | — |
| `pairing.hold_idle` | pairing | Tahan bareng-bareng. | idle status | — | — |
| `pairing.hold_holding` | pairing | Sedikit lagi… | during 3s | — | — |
| `pairing.waiting` | pairing | Nunggu pasangan kamu... | waiting | — | — |
| `pairing.countdown` | pairing | Sisa {seconds} dtk | waiting | Sisa … dtk | `{seconds}` int |
| `pairing.paired` | pairing | Berhasil! Selamat ya. | success flash | — | — |
| `pairing.expired` | pairing | Belum barengan, coba sekali lagi. | expired | — | — |
| `pairing.retry` | pairing | Coba lagi | button | — | — |
| `pairing.hold_semantics` | pairing | Tahan tiga detik untuk pairing | a11y | — | — |
| `pairing.offline_blocked` | pairing | Butuh internet buat pairing dulu ya. | offline | — | — |

---

## Home

| copy id | screen | message | usage | fallback | l10n notes |
| --- | --- | --- | --- | --- | --- |
| `home.greeting` | home | Hai, {nickname} | greeting | Hai | `{nickname}` |
| `home.greeting_fallback` | home | Hai | no nickname | — | — |
| `home.days_together` | home | {days} hari bareng | counter | Hari bareng | `{days}` int |
| `home.quick_add_hint` | home | Tulis note singkat… | quick field | — | — |
| `home.quick_add_submit` | home | Kirim | button a11y | — | — |
| `home.today_section` | home | Terbaru hari ini | section title | — | — |
| `home.summary_notes` | home | Notes | summary title | — | — |
| `home.summary_gallery` | home | Gallery | summary | — | — |
| `home.summary_dates` | home | Dates | summary | — | — |
| `home.refreshing` | home | Lagi nyegerin data... | status pill | — | shared |

---

## Notes

| copy id | screen | message | usage | fallback | l10n notes |
| --- | --- | --- | --- | --- | --- |
| `notes.title` | notes | Notes | page title | — | — |
| `notes.eyebrow` | notes | Sticky | eyebrow | — | — |
| `notes.empty_title` | notes | Belum ada note | empty | — | — |
| `notes.empty_body` | notes | Tulis yang lucu atau yang penting, bebas. | empty | — | — |
| `notes.empty_cta` | notes | Tambah note | CTA | — | — |
| `notes.error_title` | notes | Notes belum kebuka | error | — | — |
| `notes.error_body` | notes | Ada gangguan. Coba muat ulang ya. | error | — | — |
| `notes.retry` | notes | Coba lagi | button | — | shared.retry |
| `notes.editor_title_create` | notes | Note baru | dialog | — | — |
| `notes.editor_title_edit` | notes | Edit note | dialog | — | — |
| `notes.editor_hint` | notes | Isi note… | textarea | — | — |
| `notes.save` | notes | Simpan | button | — | — |
| `notes.delete_title` | notes | Hapus note? | confirm | — | — |
| `notes.delete_body` | notes | Note ini dihapus dari daftar (soft delete). | confirm | — | — |
| `notes.delete_confirm` | notes | Hapus | destructive | — | — |
| `notes.cancel` | notes | Batal | cancel | — | shared.cancel |
| `notes.edit_a11y` | notes | Edit note | icon | — | — |
| `notes.delete_a11y` | notes | Hapus note | icon | — | — |
| `notes.author` | notes | oleh {nickname} | meta | oleh seseorang | `{nickname}` |

---

## Settings

| copy id | screen | message | usage | fallback | l10n notes |
| --- | --- | --- | --- | --- | --- |
| `settings.title` | settings | Settings | page | More | — |
| `settings.cek_koneksi` | settings | Cek koneksi | menu | — | — |
| `settings.cek_session` | settings | Cek session | menu | — | — |
| `settings.cek_gallery` | settings | Cek Gallery | menu | — | — |
| `settings.cek_backup` | settings | Cek Backup | menu | — | — |
| `settings.backup_now` | settings | Backup sekarang | menu | — | — |
| `settings.backend_ok` | settings | Backend tersambung. | success | — | — |
| `settings.gallery_ok` | settings | Gallery siap dipakai. | success | — | — |
| `settings.backup_ok` | settings | Backup siap dipakai. | success | — | — |
| `settings.clear_local` | settings | Hapus session lokal | danger | — | — |
| `settings.reset_pairing` | settings | Reset pairing | danger | — | — |
| `settings.reset_title` | settings | Reset pairing? | confirm | — | — |
| `settings.reset_body` | settings | Session dilepas. Data note di server tetap disimpan (keep_data). | confirm | — | — |
| `settings.reset_confirm` | settings | Reset | confirm | — | — |

---

## Offline / network

| copy id | screen | message | usage | fallback | l10n notes |
| --- | --- | --- | --- | --- | --- |
| `offline.notice` | global | Lagi offline. Menampilkan data terakhir. | banner | — | — |
| `offline.empty_title` | feature | Belum ada data di HP ini | no cache | — | — |
| `offline.empty_body` | feature | Sambungkan internet dulu biar bisa muat. | no cache | — | — |
| `offline.mutation_blocked` | global | Butuh internet buat mengubah data. | toast | — | — |
| `offline.help_title` | offline | Kamu lagi offline | /offline | — | — |
| `offline.help_body` | offline | Cek kuota/Wi‑Fi, lalu coba lagi. | /offline | — | — |
| `offline.retry` | offline | Coba lagi | button | — | shared.retry |
| `offline.back` | offline | Kembali | button | — | — |

---

## Global errors / shared

| copy id | screen | message | usage | fallback | l10n notes |
| --- | --- | --- | --- | --- | --- |
| `shared.retry` | global | Coba lagi | button | — | — |
| `shared.cancel` | global | Batal | button | — | — |
| `shared.close_dialog` | global | Tutup dialog | a11y | — | — |
| `shared.refreshing` | global | Lagi nyegerin data... | pill | — | — |
| `shared.coming_soon` | tabs | Segera hadir | coming soon | — | — |
| `error.generic_title` | global | Ada yang error nih | card | — | — |
| `error.generic_body` | global | Coba lagi sebentar ya. | card | — | — |
| `error.unauthorized` | global | Sesi tidak valid. Pairing ulang ya. | auth | — | — |
| `error.forbidden` | global | Ini milik pasanganmu, tidak bisa diubah. | ownership | — | — |
| `error.not_found` | global | Itemnya sudah tidak ada. | — | — | — |
| `error.conflict` | global | Datanya bentrok. Muat ulang dulu. | — | — | — |
| `error.bad_request` | global | Isian belum valid. | — | — | — |
| `error.pairing_expired` | pairing | Waktu pairing habis. | — | use pairing.expired | — |
| `error.timeout` | global | Koneksi timeout. Coba lagi. | — | — | — |
| `error.server` | global | Server lagi bermasalah. | — | — | — |
| `error.unknown` | global | Ada yang error nih | — | — | — |
| `nav.home` | shell | Home | tab | — | — |
| `nav.notes` | shell | Notes | tab | — | — |
| `nav.gallery` | shell | Gallery | tab | — | — |
| `nav.dates` | shell | Dates | tab | — | — |
| `nav.more` | shell | More | tab | — | — |

---

## Implementation notes

- Prefer ARB/`flutter gen-l10n` with these ids as keys, **or** a typed `AppCopy` class mirroring ids.
- Do not hardcode alternate phrasings in widgets without catalog update.
- When adding a string, append here first, then code.
