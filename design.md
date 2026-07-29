# OurSpace Design System

> Single source of truth for the existing visual language.  
> Documented from the live codebase — not a redesign.  
> Stack: React 19 · Vite · Tailwind CSS v4 · shadcn/ui (radix-luma) · lucide-react · tw-animate-css

**Related sources:** `src/index.css`, `src/components/**`, `src/pages/**`, `docs/product-brief.md`, `docs/ui-direction.md`

---

## 1. Project overview

| Aspect | Description |
| --- | --- |
| **Product** | OurSpace — private digital scrapbook for exactly two people (a couple) |
| **Purpose** | Shared space for sticky notes, photos, date plans, and wishlists; pairing hold-button ritual sets the anniversary date |
| **Target users** | Two private members only (no public/guest roles). Primary device: mobile phone |
| **Platforms** | Mobile web (PWA), desktop browser (phone-frame shell) |
| **Language** | Indonesian, casual / intimate (`santai`) — not corporate |
| **Branding** | Pastel scrapbook: paper cards, washi tape, dotted canvas, multi-pastel accents |
| **Personality** | Warm, playful, personal, soft, tactile |
| **Tone** | Friendly, short copy, nickname-first, no marketing hero |
| **Design goals** | Feel like a scrapbook, stay readable on small phones, stay private, open fast |
| **UX goals** | Pairing ritual is memorable; home feels personal immediately; empty states stay useful; offline is honest |

---

## 2. Design philosophy

Observed principles from implementation:

| Principle | Evidence |
| --- | --- |
| **Scrapbook / paper craft** | `paper-card`, dashed inner border, tape strips, pastel sticky tones, radial paper dots on `.app-canvas` |
| **Pastel multi-color, not mono-pink** | Five scrap accents (pink, mint, yellow, blue, lavender) rotated across cards and notes |
| **Mobile-first, phone shell** | `max-w-[480px]` app column, fixed bottom nav, safe-area padding |
| **Soft premium, not enterprise** | Large black weights, pill buttons, soft brown-tinted shadows, cream paper surfaces |
| **Personal, not productivity-SaaS** | Indonesian casual copy, greeting + days-together counter, hold-to-pair ritual |
| **Honest states** | Offline banners, cache warnings, empty CTAs, error cards with retry — never silent failure |
| **Gentle motion** | Short ease-out transforms; `prefers-reduced-motion` kills long animations |
| **Accessible enough for thumbs** | 40–56px targets, skip link, focus rings, `aria-label` on icon buttons |

**Not the language of this product:** dense admin tables, pure monochrome, sharp 4px corners, neon cyber, glassmorphism-heavy dashboards.

---

## 3. Visual language

### Hierarchy

1. **Eyebrow** — `text-xs font-extrabold uppercase tracking-[0.04em] text-muted-foreground`
2. **Page title** — `text-4xl font-black` (sometimes `text-3xl` on pairing subflows)
3. **Section title** — `text-2xl font-black` (empty/error cards also use this)
4. **Card title** — `text-xl` / `text-lg font-black`
5. **Body** — `text-sm font-bold leading-relaxed text-muted-foreground` or `text-base font-extrabold` for note body
6. **Meta / caption** — `text-xs font-extrabold uppercase tracking-[0.04em]`

### Composition

- Vertical stack: page header → optional status pill → cards/sections (`space-y-5` or `space-y-4`)
- Primary CTA often full-width inside cards
- Page-level create action: circular icon button top-right with `.page-action` pink glow
- Decorative tape is top-left of cards; never covers text
- Inner dashed frame on `.paper-card` (7px inset) for paper craft feel

### Whitespace & density

- Comfortable, not sparse: card padding `p-4` / `sm:p-5`
- Section gaps `gap-3`–`gap-4`, page vertical rhythm `space-y-5`
- Bottom content clearance `pb-32` for fixed nav
- Avoid nested “card inside card” (documented product rule)

### Grid & alignment

- App column centered: `mx-auto max-w-[480px]`
- Full-bleed screens (pairing / offline / error) often `max-w-[420px]`
- Bottom nav: `grid-cols-5`
- Gallery list: `grid gap-4 sm:grid-cols-2`
- Forms: single column; dual fields use `grid-cols-2 gap-2`
- Summary widgets: single-column stack

### Rhythm & balance

- Alternate scrap tones so consecutive cards are not the same pastel
- Pink for greeting / romantic emphasis; mint for empty success-ish states; yellow for offline/status; blue for info callouts; lavender sparingly

### Consistency mechanisms

| Utility / class | Role |
| --- | --- |
| `.app-canvas` | Dot texture background |
| `.app-shell` | Phone column + isolation |
| `.paper-card` | Scrapbook surface + dashed inset + hover lift |
| `.page-header` | Title block + pink→yellow underline bar |
| `.page-action` | Primary floating action shadow |
| `.skip-link` | Keyboard skip to `#app-content` |

### Responsive philosophy

- Design for portrait phone first
- Shell caps at 480px; larger viewports show side canvas + soft shell shadow
- From `sm` (640px): slightly more padding, shell top radius, dual-column gallery
- Ultrawide: same phone column centered; do not stretch content full width

---

## 4. Color system

Tokens live in `:root` / `.dark` in `src/index.css` and map to Tailwind via `@theme inline`.

### Semantic tokens

| Token | Light hex | Dark hex | Usage |
| --- | --- | --- | --- |
| `--background` | `#fff8f1` | `#241f25` | App canvas base, theme-color, status bar |
| `--foreground` | `#332838` | `#fff8f1` | Primary text, focus ring (light) |
| `--card` | `#fffdf8` | `#2d2730` | Paper surfaces, nav bar, dialogs |
| `--card-foreground` | `#332838` | `#fff8f1` | Text on cards |
| `--popover` | `#fffdf8` | `#2d2730` | Popovers, alert dialogs |
| `--popover-foreground` | `#332838` | `#fff8f1` | Popover text |
| `--primary` | `#f16f8f` | `#ff9bb2` | Main actions, hold button, brand heart |
| `--primary-hover` | `#e65f82` | *(not redefined)* | Explicit hover (light) |
| `--primary-foreground` | `#fffdf8` | `#241f25` | Text on primary |
| `--secondary` | `#f8eadf` | `#3b3340` | Secondary buttons / soft fills |
| `--secondary-hover` | `#f2ded0` | *(not redefined)* | Secondary hover (light) |
| `--secondary-foreground` | `#332838` | `#fff8f1` | Text on secondary |
| `--muted` | `#f8eadf` | `#3b3340` | Tabs list, muted panels |
| `--muted-foreground` | `#7d6975` | `#d7c7d0` | Secondary copy, labels |
| `--accent` | `#ffe89a` | `#d7b948` | Semantic accent (= yellow scrap) |
| `--accent-foreground` | `#332838` | `#241f25` | Text on accent |
| `--destructive` | `#d94f5c` | `#ff8791` | Errors, delete actions |
| `--destructive-hover` | `#c94652` | *(not redefined)* | Destructive hover (light) |
| `--destructive-foreground` | `#fffdf8` | *(inherits pattern)* | Text on solid destructive |
| `--border` | `#ead8cf` | `#514453` | Card/input outlines |
| `--input` | `#fffdf8` | `#3b3340` | Input fill base |
| `--ring` | `#332838` | `#fff8f1` | Focus outlines |

### Scrap / decorative accents

| Token | CSS var | Light hex | Tailwind class | Usage |
| --- | --- | --- | --- | --- |
| Pink | `--accent-pink` | `#ffd2df` | `bg-scrap-pink` | Greeting card, romantic widgets |
| Mint | `--accent-mint` | `#bfe8d4` | `bg-scrap-mint` | Calm empty states, success-ish UI |
| Yellow | `--accent-yellow` | `#ffe89a` | `bg-scrap-yellow` | Sticky default, offline, active nav |
| Blue | `--accent-blue` | `#b9dcff` | `bg-scrap-blue` | Info callouts, calendar chrome |
| Lavender | `--accent-lavender` | `#d9c7ff` | `bg-scrap-lavender` | Decorative / filter accents |

Chart tokens `--chart-1…5` mirror scrap accents (light) or brighter dark variants.

### Sidebar tokens

Defined for shadcn compatibility (`--sidebar*`); app primarily uses bottom nav, not a desktop sidebar.

### Overlay / effects

| Usage | Value |
| --- | --- |
| Dialog / alert overlay | `bg-black/30` + optional `backdrop-blur-sm` |
| Body wash (light) | Radial pink + mint gradients over background |
| Selection | `color-mix(in srgb, primary 28%, transparent)` |
| Tape | `bg-white/70` |
| Soft inset panels | `bg-card/60`, `bg-card/70`, `bg-card/75`, `bg-white/45` |

### Color rules

1. Prefer semantic tokens (`bg-primary`, `text-muted-foreground`) over raw hex.
2. Scrap tones are for **surfaces and decoration**, not long body text without checking contrast.
3. Balance pastels across a page — never all pink or all cream.
4. Destructive stays soft: often `bg-destructive/10 text-destructive`, not full solid red fills for buttons.
5. Add new colors to `src/index.css` tokens before using them in components.

---

## 5. Typography

### Font family

| Layer | Value | Notes |
| --- | --- | --- |
| **Rendered body (`html` rule)** | `Nunito, ui-rounded, system-ui, sans-serif` | Rounded scrapbook voice |
| **Tailwind `--font-sans` / `@apply font-sans`** | `'Inter Variable', sans-serif` | Loaded via `@fontsource-variable/inter` |
| **Heading token** | `--font-heading: var(--font-sans)` | Same stack as sans |

> **Inconsistency (documented):** Inter is imported and mapped to `font-sans`, while the global `html { font-family }` sets Nunito (which is **not** listed in `package.json`). Runtime falls back to `ui-rounded, system-ui` when Nunito is missing. Treat **rounded system / Inter Variable** as the practical stack until fonts are unified.

### Scale (as used in UI)

| Role | Classes | Approx size | Weight | Usage |
| --- | --- | --- | --- | --- |
| Display / page H1 | `text-4xl font-black leading-tight` | 36px | 900 | Page titles, pairing hero, error titles |
| Pairing alt H1 | `text-3xl font-black leading-tight` | 30px | 900 | Recovery / offline pairing cards |
| Days counter | `text-3xl font-black` | 30px | 900 | Home anniversary counter |
| Section H2 | `text-2xl font-black` | 24px | 900 | Section + empty/error headings |
| Card H2 | `text-xl font-black` | 20px | 900 | Smaller empty states, settings profile |
| Card H3 | `text-lg font-black` | 18px | 900 | Summary titles, menu cards, note body (notes page) |
| Note body (home) | `text-base font-extrabold leading-relaxed` | 16px | 800 | Compact sticky previews |
| Body / description | `text-sm font-bold leading-relaxed` | 14px | 700 | Supporting copy |
| UI control | `text-sm font-medium` / `font-extrabold` | 14px | 500–800 | Buttons, labels |
| Caption / eyebrow | `text-xs font-extrabold uppercase tracking-[0.04em]` | 12px | 800 | Eyebrows, author meta |
| Nav label | `text-[11px] font-extrabold` | 11px | 800 | Bottom tab labels |
| Dialog title | `text-2xl font-black` | 24px | 900 | Dialog / confirm |

### Weight vocabulary

| Weight class | Typical use |
| --- | --- |
| `font-black` (900) | Titles, strong scrapbook headlines |
| `font-extrabold` (800) | Labels, note text, nav, meta |
| `font-bold` (700) | Descriptions, muted body |
| `font-semibold` (600) | Occasional pairing body |
| `font-medium` (500) | shadcn button/badge default |

### Line height & tracking

- Titles: `leading-tight`
- Body: `leading-relaxed`
- Labels: default / `leading-none` (Label component)
- Eyebrows: `tracking-[0.04em]` + `uppercase`

### Copy rules

- Indonesian casual; short sentences
- Prefer nicknames in greetings
- Error copy stays human (`Ada yang error nih`, `Notes belum kebuka`)

---

## 6. Spacing system

Base unit: **4px** (Tailwind default). No custom `--space-*` CSS variables; spacing is Tailwind scale.

| Step | Tailwind | px | Common usage |
| --- | --- | --- | --- |
| 0.5 | `0.5` | 2 | Micro (rare) |
| 1 | `1` | 4 | Icon/text tight gaps in nav |
| 1.5 | `1.5` | 6 | Button icon gaps |
| 2 | `2` | 8 | Chip gaps, form row gaps, button groups |
| 3 | `3` | 12 | Card internal clusters, summary rows |
| 4 | `4` | 16 | Default card padding, page header gap, section grids |
| 5 | `5` | 20 | Page vertical stack (`space-y-5`), larger card padding |
| 6 | `6` | 24 | Pairing shell padding, dialog gap |
| 8 | `8` | 32 | Hold-button vertical padding zones |
| 32 | `pb-32` | 128 | Main content clearance above bottom nav |

### Layout spacing rules

| Context | Pattern |
| --- | --- |
| App main | `px-4 pt-6 pb-32 sm:px-5` |
| Page stack | `space-y-5` (lists sometimes `space-y-4`) |
| Section stack | `space-y-3` |
| Card default | `p-4 sm:p-5` via ScrapbookCard |
| Compact card | `p-3` / `p-4` overrides |
| Form fields | label → `mt-2` control |
| Full-width CTA under content | `mt-4 w-full` |

---

## 7. Border radius

### Token scale (`--radius: 0.875rem` ≈ 14px)

| Token | Formula | Approx |
| --- | --- | --- |
| `--radius-sm` | `radius - 0.5rem` | ~6px |
| `--radius-md` | `radius - 0.25rem` | ~10px |
| `--radius-lg` | `radius` | 14px |
| `--radius-xl` | `radius + 0.5rem` | ~22px |
| `--radius-2xl` | `radius * 1.8` | ~25px |
| `--radius-3xl` | `radius * 2.2` | ~31px |
| `--radius-4xl` | `radius * 2.6` | ~36px |

### Practical radii in UI

| Element | Radius |
| --- | --- |
| Scrapbook / paper cards | `rounded-[1.75rem]` (28px) |
| Toasts | `rounded-[1.75rem]` |
| Dialog content | `rounded-[2rem]` |
| Alert dialog | `rounded-4xl` (+ app override `rounded-[2rem]`) |
| Pairing / gate shells | `rounded-[2rem]` |
| Sticky note articles | `rounded-[1.75rem]` (notes) / `rounded-[1.5rem]` (home) |
| Inner panels / textareas | `rounded-[1.25rem]`–`rounded-[1.15rem]` |
| Buttons (CVA) | `rounded-4xl` (pill-ish) |
| Inputs / select trigger | `rounded-3xl` (field chrome often `rounded-[1.15rem]`) |
| Badges / tabs / pills | `rounded-full` / `rounded-3xl` |
| Nav items | `rounded-2xl` |
| Color swatches / hold button | `rounded-full` |
| Tape strips | `rounded-sm` |
| App shell ≥640px | `border-radius: 2rem 2rem 0 0` |

**Rule:** Prefer soft, paper-like large radii. Avoid sharp 4–6px corners on primary surfaces.

---

## 8. Shadow & elevation

Warm brown shadow ink: `rgb(103 74 58 / α)`. Primary pink glow: `rgb(241 111 143 / α)`.

| Level | Value | Usage |
| --- | --- | --- |
| Soft card | `0 10px 30px rgb(103 74 58 / 0.10)` | ScrapbookCard, notes, toasts |
| Soft compact | `0 8px 18px … / 0.10–0.12` | Color swatches, active nav, select field |
| Tape | `0 6–8px 16–20px … / 0.10` | Washi tape accents |
| Lifted panel | `0 18px 45px … / 0.14–0.16` | Pairing cards, session gate, popover calendar |
| App shell | `0 24px 80px … / 0.14` | Phone column on wide screens |
| Bottom nav | `0 -18px 40px … / 0.14` | Upward lift |
| Offline banner | `0 8px 22px … / 0.10` | Status strip |
| Card hover (group) | `0 16px 34px … / 0.16` + `translateY(-2px) rotate(-0.15deg)` | Linked ScrapbookCards |
| Page action | `0 10px 24px rgb(241 111 143 / 0.28)` | `.page-action` FAB-style |
| Hold button | `0 18px 45px rgb(241 111 143 / 0.35)` | Pairing circle |
| Border depth | `1px solid var(--border)` | Always present on paper surfaces |
| shadcn fallbacks | `shadow-lg`, `shadow-xl`, `ring-1 ring-foreground/5` | Popover / alert |

**Elevation strategy:** mixed border + soft warm shadow (not flat Material, not heavy neumorphism).

---

## 9. Component library

### Foundations

| Piece | Path | Notes |
| --- | --- | --- |
| `cn()` | `src/lib/utils.ts` | `clsx` + `tailwind-merge` |
| Button CVA | `src/components/ui/button-variants.ts` | Shared variants |
| Note colors | `src/lib/note-colors.ts` | `yellow \| pink \| mint \| blue \| lavender` |

---

### ScrapbookCard

**Path:** `src/components/scrapbook.tsx`  
**Purpose:** Primary paper surface for almost all feature content.

| Prop | Values | Default |
| --- | --- | --- |
| `tone` | `white \| pink \| mint \| yellow \| blue \| lavender` | `white` |
| `tape` | boolean | `false` |
| `className` | passthrough | — |
| `children` | ReactNode | required |

**Visual:** `paper-card relative rounded-[1.75rem] border p-4 shadow-[soft] sm:p-5` + tone background.  
**Tape:** absolute strip `-top-3 left-8 h-6 w-20 rotate-[-3deg] bg-white/70`.  
**Hover:** when parent has `group`, card lifts slightly (see `.group:hover .paper-card`).  
**A11y:** decorative tape `aria-hidden`; semantic `<section>`.

---

### Button

**Path:** `src/components/ui/button.tsx` + `button-variants.ts`  
**Purpose:** Primary interactive control (Radix Slot capable).

**Variants:** `default` · `outline` · `secondary` · `ghost` · `destructive` · `link`  
**Sizes:** `default` (h-10) · `xs` · `sm` · `lg` · `icon` · `icon-xs` · `icon-sm` · `icon-lg`

| State | Behavior |
| --- | --- |
| Hover | Lighten/darken per variant (`primary/80`, muted fills, etc.) |
| Active | `translate-y-px` (unless haspopup) |
| Focus | `border-ring` + `ring-3 ring-ring/30` |
| Disabled | `opacity-50 pointer-events-none` |
| Invalid | destructive border/ring |

**Visual behavior:** `rounded-4xl`, `text-sm font-medium`, icon default `size-4`.  
**App pattern:** full-width primary in forms; `size="icon"` for page create / row actions; destructive soft pink-red.

---

### Badge

**Path:** `src/components/ui/badge.tsx`  
**Variants:** `default` · `secondary` · `destructive` · `outline` · `ghost` · `link`  
**Visual:** `h-5 rounded-3xl text-xs font-medium px-2`.

---

### Input

**Path:** `src/components/ui/input.tsx`  
**Visual:** `h-9 rounded-3xl border-transparent bg-input/50`, focus ring, `md:text-sm`.  
**App overrides:** often `rounded-3xl` / taller field chrome via className; pairing uses `mt-2 rounded-3xl`.

Global CSS also styles native `input:focus-visible` with primary soft glow.

---

### Textarea

**Path:** `src/components/ui/textarea.tsx`  
**Visual:** `min-h-16 rounded-2xl bg-input/50`, `field-sizing-content`, `resize-none`.  
**App pattern:** note editors use `min-h-24 rounded-[1.25rem]`, maxLength 280.

---

### Label

**Path:** `src/components/ui/label.tsx`  
**Visual:** `text-sm font-medium leading-none`; disabled peer opacity.

App often uses raw `<span className="text-sm font-extrabold text-muted-foreground">` instead of Label.

---

### Dialog

**Path:** `src/components/ui/dialog.tsx`  
**Parts:** Root, Content, Header, Title, Description (+ close button).

| Part | Style |
| --- | --- |
| Overlay | `bg-black/30` blur, fade in/out |
| Content | `max-w-md`, `rounded-[2rem]`, `p-4 sm:p-5`, zoom+fade, `max-h-[88dvh]` |
| Title | `text-2xl font-black` |
| Description | `text-sm font-bold leading-relaxed text-muted-foreground` |
| Close | ghost `icon-sm`, `aria-label="Tutup dialog"` |

---

### AlertDialog + ConfirmAlertDialog

**Paths:** `alert-dialog.tsx`, `confirm-alert-dialog.tsx`  
**Purpose:** Destructive / confirm flows (delete note, etc.).

**ConfirmAlertDialog props:** `title`, `description`, `isOpen`, `onConfirm`, `onCancel`, optional labels, `confirmDisabled`, `children`.  
**Defaults:** cancel `Batal`, confirm `Hapus` with `variant="destructive"`.  
**Chrome:** `rounded-[2rem] bg-card`, title `text-2xl font-black`.

---

### Tabs

**Path:** `src/components/ui/tabs.tsx`  
**List variants:** `default` (pill on `bg-muted`) · `line`  
**Trigger:** rounded-full, active `bg-background`, focus ring.  
**Used on:** Dates (list vs calendar).

---

### Select / SelectField

**Paths:** `select.tsx`, `select-field.tsx`  
**SelectField:** app-styled full-width trigger `h-12 rounded-[1.15rem] bg-card font-bold` + warm shadow; items `font-extrabold`, focus `bg-scrap-yellow`.

---

### Popover

**Path:** `popover.tsx`  
**Content:** `w-72 rounded-3xl p-4 shadow-lg ring-1`, zoom/fade/slide, `duration-100`, `z-[70]`.

---

### Calendar + DatePickerInput + DateTimePickerInput

**Paths:** `calendar.tsx`, `date-picker-input.tsx`, `date-time-picker-input.tsx`  
**Calendar:** react-day-picker, cell radius `1rem`, ghost nav buttons, `bg-card`.  
**DatePickerInput:** outline button `h-12 rounded-[1.15rem]`, id-ID medium date, popover with lifted shadow.

---

### Sonner Toaster

**Path:** `sonner.tsx`  
**Position:** `top-center`, `richColors`.  
**Toast chrome:** scrapbook radius + soft card shadow; action uses primary.

---

### AppShell

**Path:** `app-shell.tsx`  
**Purpose:** Authenticated chrome — canvas, 480px shell, main outlet, offline notice, bottom nav.

**Nav items:** Home · Notes · Gallery · Dates · More (→ `/settings`)  
**Active tab:** `bg-scrap-yellow text-foreground` + soft shadow  
**Tab target:** `h-14`, icon 20px `strokeWidth={2.2}`, label 11px extrabold  
**A11y:** `aria-label="Navigasi utama"`, skip link, icons `aria-hidden`

---

### OfflineNotice / OfflineEmptyState

**Path:** `offline-notice.tsx`  
**Notice:** yellow banner, CloudOff icon, `role="status"` `aria-live="polite"`.  
**Empty:** ScrapbookCard yellow + tape for no-cache pages.

---

### SessionGate

**Path:** `session-gate.tsx`  
**States:** checking / ready / blocked / temporary-error  
**UI:** centered card `rounded-[2rem]` lifted shadow; retry button.

---

### ErrorBoundary

**Path:** `error-boundary.tsx`  
**UI:** full-canvas ScrapbookCard pink + tape; icon in `rounded-2xl`; dual CTA retry / home.

---

### Loading skeletons

**Path:** `loading-skeleton.tsx`  
**Primitives:** `SkeletonBlock` — `animate-pulse rounded-full bg-card/65`  
**Exports:** `HomeSkeleton`, `NotesSkeleton`, `DatesListSkeleton`, `DatesCalendarSkeleton`, `GallerySkeleton`, `PairingStatusSkeleton`, `SettingsSkeleton`, etc.  
**Rule:** Skeletons mirror real layout tones and tape so loading feels on-brand. `aria-busy="true"`, blocks `aria-hidden`.

---

### Page-level composite patterns

| Pattern | Where | Description |
| --- | --- | --- |
| **Page header** | notes, gallery, dates, lists, settings | `.page-header` + eyebrow + `text-4xl` title + optional `.page-action` icon button |
| **Status pill** | home, notes, gallery, lists, dates | `rounded-full bg-scrap-yellow px-4 py-2 text-xs font-extrabold` for cache/refresh warnings |
| **Empty state card** | all feature pages | ScrapbookCard mint/pink + H2 + body + full-width CTA |
| **Error state card** | all feature pages | ScrapbookCard pink + tape + retry secondary button |
| **Color picker** | home, notes | 5 circular swatches `size-8`, selected `scale-110 ring-2 ring-foreground` |
| **Sticky note card** | notes, home | Tone fill + tape + author meta + optional edit/delete |
| **SummaryCard** | home | Linked ScrapbookCard with icon, meta, title, description |
| **SettingsMenuCard** | settings | Linked toned card + chevron |
| **Hold pairing button** | pairing | `size-52` circle, primary fill, progress conic/overlay, HeartHandshake / spinner |
| **Coming soon** | coming-soon.tsx | Centered toned card + Sparkles |

---

## 10. Layout system

| Token / pattern | Value |
| --- | --- |
| Min viewport width | `320px` (`html`/`body`) |
| App shell max width | `480px` |
| Standalone card max | `420px` (pairing, offline, error) |
| Dialog max | `max-w-md` / alert `max-w-xs`→`sm:max-w-md` |
| Main padding | `px-4 sm:px-5`, `pt-6`, `pb-32` |
| Bottom nav | fixed, same `max-w-[480px]`, safe-area bottom |
| Breakpoints used | default mobile; `sm:` (≥640) for padding, 2-col gallery, shell radius, dual buttons |
| Orientation | PWA `portrait` preferred |
| Height | `min-h-dvh`, content `100dvh` calculations for pairing |

**Do not** expand feature layouts to full desktop multi-column dashboards; keep the scrapbook phone column.

---

## 11. Iconography

| Rule | Detail |
| --- | --- |
| **Library** | `lucide-react` only (`components.json` → `iconLibrary: "lucide"`) |
| **Sizes** | 16–18 (inline actions), 20 (nav / page action), 22–24 (card icons), 28 (empty/error heroes), 52–58 (pairing hold) |
| **Stroke** | Default lucide; nav & pairing often `strokeWidth={2.2}` |
| **Color** | Inherit text color; destructive icons `text-destructive` |
| **A11y** | Decorative icons `aria-hidden="true"`; icon-only buttons need `aria-label` (Indonesian) |
| **Loading** | `LoaderCircle` + `animate-spin` |

Common icons: `Home`, `NotebookText`, `Images`, `CalendarHeart`, `MoreHorizontal`, `Plus`, `Send`, `Save`, `PencilLine`, `Trash2`, `HeartHandshake`, `CloudOff`, `Sparkles`, `RotateCcw`, etc.

---

## 12. Motion

### Global

- `tw-animate-css` + shadcn animate utilities (`animate-in`, `fade-in-0`, `zoom-in-95`, …)
- `@media (prefers-reduced-motion: reduce)` forces animation/transition duration ≈ 1ms

### Timing table (observed)

| Type | Duration | Easing | Where |
| --- | --- | --- | --- |
| Micro press | 150ms | `ease-out` | Nav active, hold button scale, skip-link, inputs |
| Card lift | 180ms | `ease-out` | `.paper-card` transform/shadow |
| Overlay | 100ms | default animate | Alert/dialog/popover |
| Dialog enter | tw animate | zoom+fade | Dialog content |
| Pulse | infinite | Tailwind | Skeletons `animate-pulse` |
| Spin | infinite | Tailwind | Loaders `animate-spin` |
| Hold progress | 3s linear (logic) | JS interval | Pairing hold |

### Motion rules

1. Prefer `transform` and `opacity` (card hover, active scale `0.98`).
2. Motion responds to user action (press, open, hold) — not ambient loops except skeleton/loader.
3. Respect reduced motion.
4. Do not add heavy page-route transitions that slow perceived performance.

### Pairing hold

- Pointer down starts 3s progress; release cancels
- Visual: circular primary button, progress feedback, status copy below
- Waiting window: 30s (product logic)

---

## 13. Interaction

| State | Pattern |
| --- | --- |
| **Hover** | Buttons recolor; group cards lift+tilt; links/chevrons imply navigation |
| **Active / pressed** | `active:scale-[0.98]` (nav, hold); buttons `translate-y-px` |
| **Focus visible** | Ring tokens on controls; nav `outline-2 outline-ring`; skip-link reveals |
| **Disabled** | `opacity-50`, no pointer; offline disables create/upload |
| **Loading** | Spinner in button, skeleton pages, `aria-busy` on skeleton roots |
| **Selected** | Color swatch scale+ring; tabs `data-active`; nav yellow fill |
| **Invalid** | `text-destructive` messages; `aria-invalid` rings on inputs |
| **Keyboard** | Radix dialogs/selects/tabs; Enter submits nickname on pairing |
| **Touch** | `-webkit-tap-highlight-color: transparent`; large hold target (`size-52`) |

---

## 14. Accessibility

| Area | Implementation |
| --- | --- |
| **Lang** | `<html lang="id">` |
| **Skip link** | “Langsung ke konten” → `#app-content` |
| **Semantics** | `<main>`, `<nav aria-label>`, `<header>`, `<section>`, `<article>` for notes |
| **Live regions** | Offline notice, session checking, some status messages `aria-live="polite"` |
| **Alerts** | Session temporary error `role="alert"` |
| **Icon buttons** | Indonesian `aria-label` (edit, hapus, upload, …) |
| **Pressed state** | Color swatches `aria-pressed` |
| **Focus** | Visible rings; dialog focus trap via Radix |
| **Contrast** | Dark plum text on cream; muted mauve secondary; verify scrap tone + text pairs |
| **Touch targets** | Nav `h-14`; buttons ≥h-9/h-10; hold `size-52` |
| **Safe area** | Bottom nav `pb-[max(0.875rem,env(safe-area-inset-bottom))]` |
| **Reduced motion** | Global CSS override |

---

## 15. Responsive behavior

| Viewport | Behavior |
| --- | --- |
| **Mobile (&lt;640)** | Single column, full-bleed shell edges, bottom nav, `px-4` |
| **Tablet / sm (≥640)** | Shell top rounded, `sm:px-5`, gallery 2 columns, dual button rows on error screens |
| **Laptop / desktop** | Centered 480px column, side dotted canvas, deep shell shadow — still “phone UI” |
| **Ultrawide** | Same; extra margin is empty canvas, not wider content |
PWA: standalone, portrait, theme/background `#fff8f1`.

---

## 16. Design tokens

### CSS variables (source of truth: `src/index.css`)

```text
/* surfaces */
--background --foreground --card --card-foreground
--popover --popover-foreground --muted --muted-foreground
--sidebar --sidebar-* 

/* actions */
--primary --primary-hover --primary-foreground
--secondary --secondary-hover --secondary-foreground
--accent --accent-foreground
--destructive --destructive-hover --destructive-foreground

/* chrome */
--border --input --ring

/* scrap accents */
--accent-pink --accent-mint --accent-yellow --accent-blue --accent-lavender
--chart-1 … --chart-5

/* radius */
--radius (--radius-sm … --radius-4xl derived)

/* typography theme */
--font-sans --font-heading
```

### Tailwind color bridges

`bg-background`, `text-foreground`, `bg-primary`, `bg-scrap-pink|mint|yellow|blue|lavender`, etc.

### Domain tokens (TS)

```ts
noteColors = ['yellow', 'pink', 'mint', 'blue', 'lavender']
noteToneClasses → bg-scrap-*
```

### Asset / brand constants

| Item | Value |
| --- | --- |
| Theme color | `#fff8f1` |
| App icon | Pastel paper + heart (`public/app-icon.svg`) |
| Shadow ink | `103 74 58` |
| Primary glow | `241 111 143` |

---

## 17. Dos & don'ts

### Do

- Use `ScrapbookCard` + scrap tones for feature surfaces
- Keep pages in the `space-y-5` + page-header pattern
- Rotate pastel tones; default sticky yellow is OK, not mandatory everywhere
- Write short Indonesian casual copy
- Full-width primary CTAs inside cards; icon FAB for page create
- Show empty/error/offline explicitly with retry or CTA
- Use lucide icons with `aria-hidden` + labeled buttons
- Stay inside the 480px shell mental model
- Animate lightly; honor reduced motion
- Put new colors in CSS tokens first

### Don't

- Don't redesign to flat enterprise gray or pure pink monochrome
- Don't nest cards inside cards
- Don't cover text with tape/stickers
- Don't introduce a second icon library
- Don't stretch layouts to full desktop width
- Don't use sharp tiny radii on primary surfaces
- Don't hardcode random hex in components when a token exists
- Don't hide empty sections as endless spinners
- Don't add noisy ambient animations
- Don't mix English corporate UI chrome into primary flows (errors may be bilingual today — prefer ID)

---

## 18. Future guideline

When adding a **new feature or component**:

1. **Start from patterns** — page header, ScrapbookCard tones, status pill, empty/error cards, Dialog or ConfirmAlertDialog.
2. **Tokens first** — extend `src/index.css` / note-color maps; avoid one-off palettes.
3. **Mobile column** — content must read well at 360×800 inside `max-w-[480px]`.
4. **Tone map** — assign scrap tones deliberately (e.g. info→blue, calm empty→mint, warning/offline→yellow, romantic→pink).
5. **Typography** — eyebrow → `text-4xl font-black` title → `text-sm font-bold` description.
6. **Controls** — reuse Button variants, Input/Textarea/SelectField, DatePickerInput.
7. **Motion** — 100–180ms ease-out; no new animation libraries without need.
8. **A11y** — labels in Indonesian, focus rings, 40px+ targets, decorative icons hidden.
9. **Skeleton** — add a matching skeleton in `loading-skeleton.tsx` if the page loads async.
10. **Document** — update this `design.md` when introducing a new repeated pattern (promote one-offs to rules).

### Component checklist (PR)

- [ ] Uses existing tokens / ScrapbookCard where appropriate  
- [ ] Matches spacing scale and radius language  
- [ ] Empty, error, loading, offline considered  
- [ ] Icon-only controls labeled  
- [ ] Works in 480px shell + bottom nav clearance  
- [ ] No contrast regressions on scrap tones  

---

## Design inconsistencies

Documented for alignment later — **not changed in code by this doc**.

| Issue | Detail | Recommendation |
| --- | --- | --- |
| **Font split** | `html` sets Nunito (not packaged); Tailwind `font-sans` is Inter Variable; `@layer base` applies `font-sans` | Pick one primary font, load it, align `html` + `--font-sans` |
| **Legacy DESIGN.md vs code** | Older doc listed Nunito scale in px and incomplete spacing tokens | Prefer this file; remove or redirect old short DESIGN.md if duplicate |
| **Dark scrap accents** | `.dark` recolors charts/semantic tokens but not `--accent-pink` etc. | Define dark scrap accents if dark mode ships to users |
| **Hover tokens in dark** | `--primary-hover` / `--destructive-hover` only in `:root` | Define dark hover companions or rely solely on `/opacity` hovers |
| **Radius scatter** | Mix of `1.15rem`, `1.25rem`, `1.5rem`, `1.75rem`, `2rem`, Tailwind `rounded-2xl/3xl/4xl` | Consolidate to tokenized radii (card=1.75rem, panel=1.25rem, shell=2rem, control=pill) |
| **Shadow scatter** | Many near-duplicate warm shadows | Promote named utilities (e.g. `.shadow-paper`, `.shadow-lifted`) |
| **Button weight** | CVA `font-medium` vs app copy `font-extrabold` elsewhere | Acceptable hierarchy; optionally bump primary CTA weight for scrapbook boldness |
| **Sticky note chrome** | Home mini-notes vs Notes page cards differ slightly (radius, tape size, type size) | Keep intentional density difference or extract shared `StickyNoteCard` |
| **Label component underused** | Many raw `<span>`/`<label>` styles | Prefer shared label class for consistency |
| **App.css** | Vite template styles largely unused by product UI | Ignore for product design; safe to delete later |
| **Coming-soon vs live features** | Gallery/Dates are implemented; coming-soon component may be legacy | Use live page patterns as source of truth |
| **bg-accent-mint** | Settings status uses `bg-accent-mint/70` while scrap map is `scrap-mint` | Prefer `bg-scrap-mint` for consistency |
| **Lists category colors** | Extra Tailwind `blue-300`, `amber-300`, `rose-950` borders alongside scrap fills | Map fully to scrap tokens + foreground for fewer raw palette exits |

---

## Quick reference — page map

| Route | Page | Signature UI |
| --- | --- | --- |
| `/pairing` | Pairing | Nickname → hold circle ritual / recovery form |
| `/` | Home | Pink greeting, days counter, quick note, summary cards, today notes |
| `/notes` | Notes | Header+FAB, sticky grid, dialog editor, confirm delete |
| `/gallery` | Gallery | Header+FAB, 2-col cards, upload dialog |
| `/dates` | Dates | Header+FAB, tabs list/calendar, plan cards |
| `/lists` | Lists | Wishlist cards, filters, category chips |
| `/settings/*` | Settings | Profile card, menu tones, health/setup/danger |
| `/offline` | Offline | Centered yellow help card |

---

## File index (implementation)

| Area | Location |
| --- | --- |
| Tokens & global styles | `src/index.css` |
| UI primitives | `src/components/ui/*` |
| Product chrome | `src/components/app-shell.tsx`, `scrapbook.tsx`, … |
| Pages | `src/pages/*` |
| Note color domain | `src/lib/note-colors.ts` |
| Product intent | `docs/product-brief.md`, `docs/ui-direction.md` |
| PWA chrome | `index.html`, `public/manifest.webmanifest`, `public/app-icon.svg` |

---

*Generated from the OurSpace codebase as the design source of truth. Update this document when the implemented language changes.*
