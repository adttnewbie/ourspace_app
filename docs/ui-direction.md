# UI Direction (Flutter)

## Vibe

OurSpace memakai visual scrapbook lucu: pastel colorful, banyak aksen personal, tetapi tetap nyaman dipakai harian.

Bahasa UI: Indonesia santai.

Detail token, radius, shadow, dan widget: lihat [`../design.md`](../design.md).

## Palette

Gunakan pastel colorful, bukan satu warna dominan.

Warna yang disarankan:

- Soft pink untuk momen romantis.
- Mint/sage untuk background lembut / empty calm.
- Butter yellow untuk sticky note, offline, active nav.
- Sky blue untuk aksen tenang.
- Lavender tipis sebagai aksen kecil.

Hindari UI yang seluruhnya pink atau cream karena cepat terasa monoton.

## Dekorasi

Scrapbook penuh, tetapi dekorasi tidak boleh mengganggu task utama.

Elemen yang boleh dipakai:

- Sticky note cards (`StickyNoteCard` / `ScrapbookCard`).
- Tape corner widget.
- Small sticker accents.
- Paper texture / dotted canvas painter.
- Foto/kenangan dalam frame sederhana.

Elemen yang harus dihindari:

- Dekorasi yang menutupi teks.
- Background terlalu ramai di area form.
- Card di dalam card.
- Hero marketing page; first screen harus app experience (pairing atau home).

## Home

Home setelah pairing harus langsung terasa personal:

- Greeting memakai nickname.
- Counter hari bersama dari `anniversaryDate`.
- Quick add sticky note.
- Widget kecil untuk akses Notes, Gallery, Dates (`SummaryCard`).
- Section terbaru hari ini hanya muncul jika ada item hari itu.

Jika tidak ada item hari ini, jangan tampilkan section kosong. Widget lain tetap menjaga home terasa hidup.

## Pairing screen

Fokus utama pairing screen adalah tombol lingkaran hold.

- Tombol lingkaran besar (~208 logical px), mudah ditekan dengan jempol.
- Progress ring terlihat jelas selama 3 detik (`GestureDetector` onPointerDown/Up + progress).
- Waiting state punya countdown 30 detik.
- Copy pendek dan personal, bukan instruksi panjang.

## Navigasi

Mobile memakai bottom tabs di `AppShell`:

- Home
- Notes
- Gallery
- Dates
- More

Untuk v1, Gallery dan Dates boleh disabled atau masuk layar coming soon.

Routing: `go_router` dengan shell route untuk tab, full-screen routes untuk pairing / offline / error.

## Motion

Motion halus secukupnya:

- Progress ring hold button.
- Transition singkat dari paired ke home.
- Tap/press feedback pada sticky note dan quick action (`scale 0.98`).
- Page transition ringan (fade / short shared axis).

Jangan menambah animasi yang membuat app terasa lambat. Hormati reduced motion platform.

## Sticky Notes

Sticky notes v1 adalah note pendek.

- Tidak perlu title.
- Warna pastel bisa dipilih dari preset (`yellow`, `pink`, `mint`, `blue`, `lavender`).
- Author tampil sebagai nickname.
- Edit/hapus hanya tersedia untuk pembuat.
- Empty state singkat dengan CTA tambah note.
- Editor: dialog / modal scrapbook, body max 280 karakter.
