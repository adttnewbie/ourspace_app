<div align="center">

<img src="./assets/images/icon.png" width="84" height="84" alt="OurSpace" style="border-radius:20px; border:1.5px solid #1B1C1A" />

# OurSpace

**Ruang kita, cerita kita.**

*Jurnal privat untuk berdua — foto, surat, dan janji kencan yang ditempel kayak scrapbook fisik.*

<br/>

[![Expo SDK](https://img.shields.io/badge/Expo-SDK%2057-864D61?style=for-the-badge&labelColor=1B1C1A)](https://docs.expo.dev/versions/v57.0.0/)
[![React Native](https://img.shields.io/badge/React_Native-0.86-61DAFB?style=for-the-badge&labelColor=1B1C1A)](https://reactnative.dev)
[![NativeWind](https://img.shields.io/badge/NativeWind-5-38BDF8?style=for-the-badge&labelColor=1B1C1A)](https://www.nativewind.dev)
[![TypeScript](https://img.shields.io/badge/TypeScript-6.0-3178C6?style=for-the-badge&labelColor=1B1C1A)](https://www.typescriptlang.org/)

**Private by default • Tanpa iklan • Hapus kapan saja**

[Get Started](#-get-started) • [Design System](#-tactile-memory-design-system) • [Arsitektur](#-arsitektur) • [Roadmap](#-roadmap)

</div>

---

### Kenapa OurSpace nggak kayak app couple lain?

> Kebanyakan app couple itu dashboard generik: kalender, chat, checklist. OurSpace dibikin kayak **jurnal fisik yang kalian isi bareng di meja** — kertas cream, washi tape, foto miring, coretan pensil warna. Minimal secara logika, tactile secara rasa.

| Prinsip | Di OurSpace jadi |
|---|---|
| **Layering** | Card `shadow 4px 4px 0 #1B1C1A` + rotasi `±0.8°` + tape di sudut — kayak kertas ditumpuk |
| **Imperfection** | Garis ruled notebook, border dashed, font `Bricolage` yang quirky |
| **Personal** | Stiker, doodle heart, dan `one day at a time` — bukan UI steril |

---

### ✨ Fitur

| Area | Yang bisa dilakukan |
|---|---|
| **Get Started** | Hero `Alya & Bima`, swap `Aku ↔ Kamu` (spring `damping 14`), swipe `Geser untuk memulai` |
| **Ruang (Home)** | Overview couple: `874 hari • 48 kenangan • 12 tempat`, anniversary bar pensil `82%`, teaser catatan & kenangan |
| **Catatan** | Sticky notes `Pink/Mint/Kuning/Biru` + washi tape, composer sheet dengan color picker kertas |
| **Kenangan** | Polaroid gallery + tape, add foto dengan preview polaroid live + cerita singkat |
| **Kencan** | Tiket kencan `Menunggu/Terjadwal/Selesai`, pickers taktill: **Kalender kertas** (grid 7 kol + lingkar spidol), **Jam dial** (00–23 + 00–55), **Peta kertas** (pin draggable + preset `SKYE, Suropati, CGV`) |
| **Pengaturan** | Nama ruang (ruled line), notifikasi `DoodleToggle ❤`, tema kertas `Cream/Pink/Biru`, privasi hand-checkbox |

Semua form pakai **validasi `design.md`** (`#ba1a1a / #ffdad6 / #93000a`) — error di garis buku, bukan toast generik. Semua ikon **Lucide** — tanpa emoji.

---

### 🎨 Tactile Memory Design System

Sistem diambil 1:1 dari `design.md` — bukan template AI.

**Palet Sun-Drenched Pastel**

| Token | Hex | Pakai |
|---|---|---|
| Cream (kertas) | `#FDFCF8` | background |
| Ink | `#1B1C1A` | teks & border 1.5px |
| Primary / Pink | `#864D61` / `#FFB7CE` | aksi hati, primary |
| Washi Yellow | `#EEE199` | tape & chip |
| Sky Blue | `#B4EBFF` / `#93D4EB` | sekunder |
| Mint | `#C6F0D1` | catatan |
| Error | `#ba1a1a` / `#ffdad6` | validasi |

**Tipografi**

- **Bricolage Grotesque 800** — display / judul (quirky, kayak cap vintage)
- **Plus Jakarta Sans 400** — body panjang (readable)
- **Space Mono 700** — label caps / metadata typewriter

**Bentuk & Bayangan**
`rounded 16–20px` + `border 1.5px #1B1C1A` + `shadow 4px 4px 0 #1B1C1A` (bukan blur). Tape `h 14px` semi-transparan dengan sobekan kiri-kanan.

**Navigasi**
Floating **Bookmark Strip** `w 96% max-w 420 h 68 rounded-full` dengan 2 notch segitiga + washi di tengah, active `pill 48×34` dengan fill pensil warna per-tab (Ruang pink, Catatan mint, Kenangan kuning, Kencan biru).

---

### 🛠 Stack

- **Expo SDK 57** + **Expo Router** (file-based, `src/app`)
- **React 19 / React Native 0.86** + **Reanimated 4** + **Gesture Handler**
- **NativeWind 5** + **Tailwind 4** (`src/global.css`)
- **Lucide React Native**, **React Native Maps**, **Expo Location**
- **TypeScript 6** (strict)

> 📖 Expo sudah berubah — baca **docs versi yang dipakai**: https://docs.expo.dev/versions/v57.0.0/

---

### 🚀 Get Started

```bash
# 1. Install
npm install

# 2. Patch vulnerabilitas (query-string ESM fix)
node ./scripts/fix-vulnerabilities.js

# 3. Jalanin
npx expo start          # → scan QR di Expo Go (butuh SDK 57) atau
npx expo start --web    # → http://localhost:8081
npx expo run:android    # dev build (kalau Expo Go Play Store masih SDK 53)
```

**Butuh SDK 57 di Expo Go?**  
Expo Go Play Store belum tentu bawa 57 (canary). Join **Beta Program** di Play Store, atau pakai `--web` / `run:android`. Jangan downgrade tanpa perlu — project ini memang di-pin ke `expo ~57.0.18`.

---

### 📂 Arsitektur

```
src/
├── app/
│   ├── _layout.tsx              # Stack + GestureHandlerRootView + global.css
│   ├── index.tsx                # Get Started — swap Aku/Kamu + swipe
│   ├── login.tsx                # Ruled inputs + error #ffdad6
│   ├── register.tsx             # + kode pasangan OUR-XXXX
│   └── (tabs)/
│       ├── _layout.tsx          # Tabs + BookmarkBar
│       ├── home.tsx             # Overview couple (single-source info)
│       ├── notes.tsx            # Sticky notes + composer
│       ├── memories.tsx         # Polaroid gallery + add sheet
│       ├── timeline.tsx         # Kencan — date/time/map pickers
│       └── profile.tsx          # Pengaturan taktill
├── components/ui/
│   ├── washi-tape.tsx
│   ├── swipe-button.tsx         # Pan gesture threshold 72%
│   ├── notebook-input.tsx       # Ruled line + AlertCircle
│   ├── tactile-date-picker.tsx  # Kalender kertas 7 kol
│   ├── tactile-time-picker.tsx  # Dial 00-23 / 00-55
│   ├── tactile-map-picker.tsx   # Paper map + pin draggable + presets
│   └── bottom-nav.tsx           # Bookmark strip
└── global.css                   # @theme cream/ink/pink/yellow/blue
```

---

### 🔒 Privasi

OurSpace didesain **private by default**: enkripsi, tanpa algoritma, tanpa iklan. Data cuma milik berdua — hapus kapan saja dari Pengaturan.

---

### 🗺 Roadmap

- [x] Tactile foundation + auth + 5 tabs
- [x] Pickers kertas (date/time/map)
- [ ] Sync E2E + foto upload real
- [ ] Push notifikasi kencan (1 jam sebelum)
- [ ] Export jurnal ke PDF kertas

---

<div align="center">

**Dibuat dengan ♡ di OurSpace**

`v1.0` • `one day at a time` — Streak 12 hari

<br/>

[Report Bug](https://github.com/adttnewbie/ourspace_app/issues) • [Request Feature](https://github.com/adttnewbie/ourspace_app/issues)

</div>
