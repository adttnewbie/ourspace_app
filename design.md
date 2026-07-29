# OurSpace Flutter Design System

> Single source of truth for the OurSpace visual language on Flutter.  
> Converted from the original web design language — not a redesign.  
> Stack target: Flutter · Material 3 foundation · Riverpod · go_router · Dio · lucide_icons (or equivalent) · flutter_secure_storage

**Related sources:** `lib/core/theme/**`, `lib/shared/widgets/**`, `lib/features/**`, `docs/product-brief.md`, `docs/ui-direction.md`

---

## 1. Project overview

| Aspect | Description |
| --- | --- |
| **Product** | OurSpace — private digital scrapbook for exactly two people (a couple) |
| **Purpose** | Shared space for sticky notes, photos, date plans, and wishlists; pairing hold-button ritual sets the anniversary date |
| **Target users** | Two private members only (no public/guest roles). Primary device: mobile phone |
| **Platforms** | Flutter mobile (Android + iOS). Tablet uses the same phone-column scrapbook layout, not a multi-column desktop dashboard |
| **Language** | Indonesian, casual / intimate (`santai`) — not corporate |
| **Branding** | Pastel scrapbook: paper cards, washi tape, dotted canvas, multi-pastel accents |
| **Personality** | Warm, playful, personal, soft, tactile |
| **Tone** | Friendly, short copy, nickname-first, no marketing hero |
| **Design goals** | Feel like a scrapbook, stay readable on small phones, stay private, open fast |
| **UX goals** | Pairing ritual is memorable; home feels personal immediately; empty states stay useful; offline is honest |

---

## 2. Design philosophy

| Principle | Flutter evidence |
| --- | --- |
| **Scrapbook / paper craft** | `ScrapbookCard` widget, dashed inner border, tape strip widgets, pastel sticky tones, dotted canvas painter on `AppCanvas` |
| **Pastel multi-color, not mono-pink** | Five scrap accents (pink, mint, yellow, blue, lavender) rotated across cards and notes via `ScrapTone` |
| **Mobile-first, phone shell** | Content max width ~480 logical px, fixed bottom navigation, `SafeArea` / system inset padding |
| **Soft premium, not enterprise** | Large black font weights, pill buttons, soft brown-tinted shadows, cream paper surfaces |
| **Personal, not productivity-SaaS** | Indonesian casual copy, greeting + days-together counter, hold-to-pair ritual |
| **Honest states** | Offline banners, cache warnings, empty CTAs, error cards with retry — never silent failure |
| **Gentle motion** | Short ease-out transforms; honor `MediaQuery.disableAnimations` / reduced motion |
| **Accessible enough for thumbs** | 40–56 logical px targets, Semantics labels, focus highlights, icon-only buttons labeled |

**Not the language of this product:** dense admin tables, pure monochrome, sharp 4px corners, neon cyber, heavy glassmorphism, Material dense data UIs.

---

## 3. Design principles

### Hierarchy

1. **Page title** — largest black weight (`display` / ~36 sp)
2. **Card titles / sticky body** — bold readable body
3. **Meta / author / muted** — smaller, muted plum
4. **Decorative** — tape, dots, stickers never compete with text

### Composition

- One primary action per screen region
- Scrapbook surfaces stack vertically with consistent gaps
- Bottom navigation is permanent chrome after session is ready
- Full-bleed standalone screens (pairing / offline / fatal error) center a single card

### Whitespace & density

- Comfortable, not sparse: page stack ~20 logical px between sections
- Cards breathe with 16–20 logical px padding
- Avoid dense multi-column data layouts

### Grid & alignment

- Primary content column: max ~480 logical px, centered on wide tablets
- Full-bleed screens (pairing / offline / error): max ~420 logical px
- Bottom nav: 5 equal destinations
- Gallery list: 1 column phone, 2 columns from ~640 logical px
- Forms: single column; dual fields use 2-column row with 8 logical px gap
- Summary widgets: single-column stack

### Rhythm & balance

- Alternate scrap tones so consecutive cards are not the same pastel
- Pink for greeting / romantic emphasis; mint for empty success-ish states; yellow for offline/status; blue for info callouts; lavender sparingly

### Consistency mechanisms

| Widget / token | Role |
| --- | --- |
| `AppCanvas` | Dot texture background |
| `AppShell` | Phone column + isolation + bottom nav |
| `ScrapbookCard` | Scrapbook surface + dashed inset + optional press lift |
| `PageHeader` | Title block + pink→yellow underline bar |
| `PageActionButton` | Primary floating action shadow (icon create) |
| Semantics / skip focus | Keyboard/a11y path to main content where relevant |

### Responsive philosophy

- Design for portrait phone first
- Shell caps at 480 logical px; larger viewports show side canvas + soft shell shadow
- From ~640 logical px: slightly more padding, shell top radius, dual-column gallery
- Ultrawide/tablet landscape: same phone column centered; do not stretch content full width

---

## 4. Color system

Tokens live in `AppColors` / `ColorScheme` (light + dark) and are the only allowed product palette sources.

### Semantic tokens

| Token | Light hex | Dark hex | Usage |
| --- | --- | --- | --- |
| `background` | `#fff8f1` | `#241f25` | App canvas base, system status bar / theme color |
| `foreground` | `#332838` | `#fff8f1` | Primary text, focus ring (light) |
| `card` | `#fffdf8` | `#2d2730` | Paper surfaces, nav bar, dialogs |
| `cardForeground` | `#332838` | `#fff8f1` | Text on cards |
| `popover` | `#fffdf8` | `#2d2730` | Sheets, menus, alert dialogs |
| `popoverForeground` | `#332838` | `#fff8f1` | Popover text |
| `primary` | `#f16f8f` | `#ff9bb2` | Main actions, hold button, brand heart |
| `primaryHover` | `#e65f82` | *(derive or keep primary)* | Pressed / hovered primary (light) |
| `primaryForeground` | `#fffdf8` | `#241f25` | Text on primary |
| `secondary` | `#f8eadf` | `#3b3340` | Secondary buttons / soft fills |
| `secondaryHover` | `#f2ded0` | *(derive)* | Secondary press (light) |
| `secondaryForeground` | `#332838` | `#fff8f1` | Text on secondary |
| `muted` | `#f8eadf` | `#3b3340` | Tabs list, muted panels |
| `mutedForeground` | `#7d6975` | `#d7c7d0` | Secondary copy, labels |
| `accent` | `#ffe89a` | `#d7b948` | Semantic accent (= yellow scrap) |
| `accentForeground` | `#332838` | `#241f25` | Text on accent |
| `destructive` | `#d94f5c` | `#ff8791` | Errors, delete actions |
| `destructiveHover` | `#c94652` | *(derive)* | Destructive press (light) |
| `destructiveForeground` | `#fffdf8` | *(pattern)* | Text on solid destructive |
| `border` | `#ead8cf` | `#514453` | Card/input outlines |
| `input` | `#fffdf8` | `#3b3340` | Input fill base |
| `ring` | `#332838` | `#fff8f1` | Focus outlines |

### Scrap / decorative accents

| Token | Light hex | Flutter constant | Usage |
| --- | --- | --- | --- |
| Pink | `#ffd2df` | `AppColors.scrapPink` | Greeting card, romantic widgets |
| Mint | `#bfe8d4` | `AppColors.scrapMint` | Calm empty states, success-ish UI |
| Yellow | `#ffe89a` | `AppColors.scrapYellow` | Sticky default, offline, active nav |
| Blue | `#b9dcff` | `AppColors.scrapBlue` | Info callouts, calendar chrome |
| Lavender | `#d9c7ff` | `AppColors.scrapLavender` | Decorative / filters sparingly |

### Overlay / effects

| Effect | Value | Usage |
| --- | --- | --- |
| Dialog scrim | black ~30% + optional blur | Modal barriers |
| Paper dots | radial / custom painter soft dots on canvas | `AppCanvas` |
| Dashed inset | soft dashed border inside paper cards | `ScrapbookCard` |
| Tape fill | white ~70% opacity strip | Washi tape accent |

### Color rules

1. Never invent one-off hex in feature widgets — extend tokens first.
2. Scrap tones are backgrounds; text stays `foreground` / `mutedForeground` unless on solid primary.
3. Rotate scrap tones across consecutive cards.
4. Offline / cache warnings prefer yellow scrap.
5. Destructive actions use destructive tokens, not pure Material red defaults.

---

## 5. Typography

### Font family

| Role | Recommendation |
| --- | --- |
| **Primary UI** | One soft rounded sans (e.g. Inter, Nunito, or Plus Jakarta Sans) — pick **one**, package via `google_fonts` or bundled assets |
| **Heading** | Same family, black / extrabold weights |
| **Mono** | Not used in product UI |

Resolve any web-era font split (Inter vs Nunito) by choosing a single primary family and wiring it through `ThemeData.textTheme`.

### Scale (as used in UI)

| Role | Approx size | Weight | Where |
| --- | --- | --- | --- |
| Eyebrow | 12–13 sp | extrabold | Page header kicker |
| Page title | ~36 sp (`text-4xl`) | black | `PageHeader` |
| Section H2 | ~20–24 sp | black / extrabold | Empty/error titles |
| Card title | 16–18 sp | extrabold | Summary / settings rows |
| Body | 14 sp | bold / medium | Descriptions, note body |
| Meta | 12–13 sp | bold | Author, timestamps |
| Nav label | 11 sp | extrabold | Bottom nav |
| Micro / badge | 12 sp | medium | Badges, status pills |

### Weight vocabulary

| Weight | Usage |
| --- | --- |
| black (900) | Page titles, dialog titles |
| extrabold (800) | Nav labels, status pills, select items, strong labels |
| bold (700) | Body emphasis, descriptions |
| medium (500) | Default buttons, badges |
| regular (400) | Rare; prefer medium+ for scrapbook boldness |

### Line height & tracking

- Body / descriptions: relaxed (~1.4–1.6)
- Titles: tight-comfortable
- No aggressive letter-spacing on Indonesian copy

### Copy rules

- Indonesian casual (`santai`), short sentences
- Prefer nicknames in greetings
- Error copy stays human (`Ada yang error nih`, `Notes belum kebuka`)
- No marketing hero copy on first screens

---

## 6. Spacing system

Base unit: **4 logical pixels**. Expose as `AppSpacing` constants (not ad-hoc magic numbers).

| Step | Logical px | Common usage |
| --- | --- | --- |
| 0.5 | 2 | Micro (rare) |
| 1 | 4 | Icon/text tight gaps in nav |
| 1.5 | 6 | Button icon gaps |
| 2 | 8 | Chip gaps, form row gaps, button groups |
| 3 | 12 | Card internal clusters, summary rows |
| 4 | 16 | Default card padding, page header gap, section grids |
| 5 | 20 | Page vertical stack, larger card padding |
| 6 | 24 | Pairing shell padding, dialog gap |
| 8 | 32 | Hold-button vertical padding zones |
| 32 | 128 | Main content clearance above bottom nav |

### Layout spacing rules

| Context | Pattern |
| --- | --- |
| App main | horizontal 16 (20 from ~640), top 24, bottom ~128 |
| Page stack | vertical 20 (lists sometimes 16) |
| Section stack | vertical 12 |
| Card default | padding 16 / 20 via `ScrapbookCard` |
| Compact card | padding 12 / 16 overrides |
| Form fields | label → 8 gap → control |
| Full-width CTA under content | top 16, full width |

---

## 7. Sizing

| Element | Size |
| --- | --- |
| Min interactive target | ≥40 logical px (prefer 44–56) |
| Default button height | 40 |
| Large field / select | 48 |
| Icon button (page action) | 40–48 |
| Bottom nav item height | 56 |
| Color swatch | 32 |
| Pairing hold button | ~208 (size-52) |
| Inline icons | 16–18 |
| Nav / page action icons | 20 |
| Card icons | 22–24 |
| Empty/error hero icons | 28 |
| Pairing hold icon | 52–58 |

---

## 8. Border radius

### Token scale (base radius ≈ 14)

| Token | Approx |
| --- | --- |
| `radiusSm` | ~6 |
| `radiusMd` | ~10 |
| `radiusLg` | 14 |
| `radiusXl` | ~22 |
| `radius2xl` | ~25 |
| `radius3xl` | ~31 |
| `radius4xl` | ~36 |

### Practical radii in UI

| Element | Radius |
| --- | --- |
| Scrapbook / paper cards | 28 |
| Toasts / snackbars | 28 |
| Dialog / bottom sheet content | 32 |
| Alert dialog | ~32–36 |
| Pairing / gate shells | 32 |
| Sticky note articles | 28 (notes) / 24 (home mini) |
| Inner panels / text fields multi-line | ~18–20 |
| Buttons | pill-ish (~999 / large) |
| Inputs / select trigger | large rounded (~18–28) |
| Badges / tabs / pills | full / large |
| Nav items | ~16–20 |
| Color swatches / hold button | full circle |
| Tape strips | small (~6) |
| App shell ≥640 | top corners 32, bottom 0 (if framed) |

**Rule:** Prefer soft, paper-like large radii. Avoid sharp 4–6 corners on primary surfaces.

---

## 9. Elevation & shadow

Warm brown shadow ink: `Color.fromRGBO(103, 74, 58, α)`. Primary pink glow: `Color.fromRGBO(241, 111, 143, α)`.

| Level | Approx | Usage |
| --- | --- | --- |
| Soft card | blur 30, y 10, α 0.10 | `ScrapbookCard`, notes, toasts |
| Soft compact | blur 18, y 8, α 0.10–0.12 | Color swatches, active nav, select field |
| Tape | blur 16–20, y 6–8, α 0.10 | Washi tape accents |
| Lifted panel | blur 45, y 18, α 0.14–0.16 | Pairing cards, session gate, calendar popover |
| App shell | blur 80, y 24, α 0.14 | Phone column on wide screens |
| Bottom nav | upward blur 40, y -18, α 0.14 | Bottom chrome |
| Offline banner | blur 22, y 8, α 0.10 | Status strip |
| Card press lift | blur 34, y 16, α 0.16 + slight translate/rotate | Tappable summary cards |
| Page action | pink glow blur 24, y 10, α 0.28 | FAB-style create |
| Hold button | pink glow blur 45, y 18, α 0.35 | Pairing circle |
| Border depth | 1 logical px `border` color | Always present on paper surfaces |

**Elevation strategy:** mixed border + soft warm shadow (not flat Material defaults, not heavy neumorphism). Prefer `BoxDecoration` / `Material` with custom shadows over default Material elevation cards.

---

## 10. Animation & motion

### Global

- Use Flutter `AnimationController`, `AnimatedScale`, `AnimatedOpacity`, `Hero` sparingly
- When `MediaQuery.disableAnimations` / reduced motion is on, collapse long animations to ~1 frame / instant

### Timing table

| Type | Duration | Easing | Where |
| --- | --- | --- | --- |
| Micro press | 150ms | easeOut | Nav active, hold button scale, inputs |
| Card lift | 180ms | easeOut | Paper card transform/shadow |
| Overlay | 100ms | default | Dialog / sheet barrier |
| Dialog enter | short | fade + scale | Modal content |
| Pulse | infinite | soft | Skeletons |
| Spin | infinite | linear | Loaders |
| Hold progress | 3s linear | product logic | Pairing hold |

### Motion rules

1. Prefer transform and opacity (scale `0.98` on press).
2. Motion responds to user action (press, open, hold) — not ambient loops except skeleton/loader.
3. Respect reduced motion.
4. Do not add heavy route transitions that slow perceived performance.

### Pairing hold

- Pointer down starts 3s progress; release cancels
- Visual: circular primary button, progress feedback (`CircularProgressIndicator` arc or custom painter), status copy below
- Waiting window: 30s (product logic)

### Page transition

- Default: light fade / shared-axis short via `go_router` / `CustomTransitionPage`
- Avoid full-screen slide stacks that feel slow
- Pairing → home: brief success state then navigate

---

## 11. Iconography

| Rule | Detail |
| --- | --- |
| **Library** | One icon set only (recommended: `lucide_icons` or equivalent stroke set matching lucide names) |
| **Sizes** | 16–18 (inline), 20 (nav / page action), 22–24 (card), 28 (empty/error), 52–58 (pairing hold) |
| **Stroke** | Default; nav & pairing often ~2.2 |
| **Color** | Inherit text color; destructive icons use `destructive` |
| **A11y** | Decorative icons excluded from semantics; icon-only controls need Indonesian `Semantics` / `tooltip` labels |
| **Loading** | circular progress / spinning loader icon |

Common icons: Home, Notebook, Images, CalendarHeart, MoreHorizontal, Plus, Send, Save, Pencil, Trash, HeartHandshake, CloudOff, Sparkles, RotateCcw, etc.

---

## 12. Component specification

Recommended Flutter widgets / custom components. Paths are target locations under `lib/`.

### Foundations

| Piece | Target | Notes |
| --- | --- | --- |
| Theme tokens | `lib/core/theme/app_colors.dart`, `app_spacing.dart`, `app_radii.dart`, `app_shadows.dart`, `app_typography.dart` | Design tokens |
| `AppTheme` | `lib/core/theme/app_theme.dart` | `ThemeData` light/dark |
| Note colors | `lib/features/notes/domain/note_colors.dart` | `yellow \| pink \| mint \| blue \| lavender` |

---

### ScrapbookCard

**Target:** `lib/shared/widgets/scrapbook_card.dart`  
**Base:** custom `StatelessWidget` / `Container` + `CustomPaint` dashed border (not default `Card`)  
**Purpose:** Primary paper surface for almost all feature content.

| Prop | Values | Default |
| --- | --- | --- |
| `tone` | `white \| pink \| mint \| yellow \| blue \| lavender` | `white` |
| `tape` | bool | `false` |
| `onTap` | VoidCallback? | null |
| `child` | Widget | required |
| `padding` | EdgeInsets? | 16 / 20 |

**Visual:** relative, radius 28, border, soft paper shadow, tone background.  
**Tape:** absolute strip near top, slight rotation, white ~70%.  
**Press:** optional slight lift when tappable.  
**A11y:** decorative tape excluded from semantics; prefer semantic section via parent.

---

### AppButton

**Target:** `lib/shared/widgets/app_button.dart`  
**Base:** `FilledButton` / `OutlinedButton` / `TextButton` themed, or custom  
**Variants:** `primary` · `outline` · `secondary` · `ghost` · `destructive` · `link`  
**Sizes:** default (h 40) · xs · sm · lg · icon · iconSm · iconLg

| State | Behavior |
| --- | --- |
| Hover / highlight | Lighten/darken per variant (desktop/web pointer) |
| Pressed | slight translate down or scale |
| Focus | border ring + soft ring glow |
| Disabled | opacity 50, ignore pointers |
| Invalid | destructive border/ring |

**App pattern:** full-width primary in forms; icon size for page create / row actions; destructive soft pink-red.

---

### AppBadge

**Target:** `lib/shared/widgets/app_badge.dart`  
**Base:** compact `Container` / `Chip`  
**Visual:** height ~20, large radius, 12 sp medium, horizontal padding 8.

---

### AppTextField

**Target:** `lib/shared/widgets/app_text_field.dart`  
**Base:** `TextFormField` themed  
**Visual:** height ~36–48, large radius, transparent/soft border, `input` fill, focus ring.  
**Pairing:** larger field, top margin after label.

Focus: soft primary glow via `InputDecoration` / `Focus` theme.

---

### AppTextArea

**Target:** `lib/shared/widgets/app_text_area.dart`  
**Base:** `TextFormField` multi-line  
**Visual:** min height ~64–96, radius ~20, no resize handle (mobile).  
**Notes editor:** min height ~96, maxLength 280.

---

### AppLabel

**Target:** `lib/shared/widgets/app_label.dart`  
**Visual:** 14 sp medium; strong labels may use extrabold muted.

---

### AppDialog

**Target:** `lib/shared/widgets/app_dialog.dart`  
**API:** `showAppDialog` / `showModalBottomSheet` with scrapbook chrome  
**Parts:** barrier, content, header, title, description, close.

| Part | Style |
| --- | --- |
| Barrier | black 30%, optional blur |
| Content | max width ~md, radius 32, padding 16–20, max height ~88% viewport |
| Title | ~24 sp black |
| Description | 14 sp bold relaxed muted |
| Close | ghost icon, semantics “Tutup dialog” |

Prefer centered dialog on phone for short forms; bottom sheet is acceptable when keyboard-heavy if chrome stays scrapbook.

---

### ConfirmAlertDialog

**Target:** `lib/shared/widgets/confirm_alert_dialog.dart`  
**Purpose:** Destructive / confirm flows (delete note, etc.).

**Props:** `title`, `description`, `onConfirm`, `onCancel`, optional labels, `confirmDisabled`, optional body.  
**Defaults:** cancel `Batal`, confirm `Hapus` with destructive variant.  
**Chrome:** radius 32, card surface, title black.

---

### AppTabs

**Target:** `lib/shared/widgets/app_tabs.dart`  
**Base:** `TabBar` / custom pill segmented control  
**List variants:** pill on muted · line  
**Trigger:** rounded full, active background surface, focus ring.  
**Used on:** Dates (list vs calendar).

---

### AppSelect / AppSelectField

**Target:** `lib/shared/widgets/app_select_field.dart`  
**Base:** `DropdownButtonFormField` or custom menu  
**SelectField:** full-width trigger height 48, radius ~18, card fill, bold, warm shadow; items extrabold; focused/hover yellow scrap.

---

### AppPopover / menu surfaces

**Target:** themed `PopupMenu` / custom overlay  
**Content:** width ~288, radius large, padding 16, elevated shadow, z above sheets.

---

### AppCalendar + DatePickerField + DateTimePickerField

**Target:** `lib/shared/widgets/date_picker_field.dart` etc.  
**Base:** `showDatePicker` customized or `table_calendar` / custom month grid with scrapbook cells  
**Date field:** outline button height 48, radius ~18, locale `id_ID` medium date, elevated popover/sheet.

---

### AppToaster / Snackbar

**Target:** `lib/shared/widgets/app_toast.dart` or `ScaffoldMessenger` theme  
**Position:** top-center preferred (or floating snackbar)  
**Chrome:** scrapbook radius + soft card shadow; action uses primary.

---

### AppShell

**Target:** `lib/shared/widgets/app_shell.dart`  
**Purpose:** Authenticated chrome — canvas, ~480 shell, main body, offline notice, bottom nav.

**Nav items:** Home · Notes · Gallery · Dates · More (→ settings)  
**Active tab:** yellow scrap fill + soft shadow  
**Tab target:** height 56, icon 20 stroke ~2.2, label 11 extrabold  
**A11y:** semantics label “Navigasi utama”; icons decorative when labels present  
**Safe area:** bottom inset via `SafeArea` / `MediaQuery.viewPadding`

---

### OfflineNotice / OfflineEmptyState

**Target:** `lib/shared/widgets/offline_notice.dart`  
**Notice:** yellow banner, CloudOff icon, polite live region semantics.  
**Empty:** `ScrapbookCard` yellow + tape for no-cache pages.

---

### SessionGate

**Target:** `lib/features/auth/presentation/session_gate.dart`  
**States:** checking / ready / blocked / temporary-error  
**UI:** centered card radius 32 lifted shadow; retry button.

---

### AppErrorBoundary / fatal error UI

**Target:** `lib/shared/widgets/app_error_view.dart` (+ Flutter `ErrorWidget.builder` / zone handling)  
**UI:** full-canvas `ScrapbookCard` pink + tape; icon in rounded square; dual CTA retry / home.

---

### Loading skeletons

**Target:** `lib/shared/widgets/loading_skeleton.dart`  
**Primitives:** pulse blocks, rounded, card/65 fill  
**Exports:** `HomeSkeleton`, `NotesSkeleton`, `DatesListSkeleton`, `DatesCalendarSkeleton`, `GallerySkeleton`, `PairingStatusSkeleton`, `SettingsSkeleton`, etc.  
**Rule:** Skeletons mirror real layout tones and tape so loading feels on-brand. Mark busy for a11y; decorative blocks ignored by semantics.

---

### Page-level composite patterns

| Pattern | Where | Flutter notes |
| --- | --- | --- |
| **Page header** | notes, gallery, dates, lists, settings | `PageHeader` + eyebrow + large black title + optional `PageActionButton` |
| **Status pill** | home, notes, gallery, lists, dates | pill yellow scrap, 12 sp extrabold for cache/refresh warnings |
| **Empty state card** | all feature pages | `ScrapbookCard` mint/pink + H2 + body + full-width CTA |
| **Error state card** | all feature pages | `ScrapbookCard` pink + tape + retry secondary button |
| **Color picker** | home, notes | 5 circular swatches size 32, selected scale 1.1 + ring |
| **Sticky note card** | notes, home | Tone fill + tape + author meta + optional edit/delete |
| **SummaryCard** | home | Tappable `ScrapbookCard` with icon, meta, title, description |
| **SettingsMenuCard** | settings | Tappable toned card + chevron |
| **Hold pairing button** | pairing | ~208 circle, primary fill, progress arc, HeartHandshake / spinner |
| **Coming soon** | shared | Centered toned card + Sparkles |

---

## 13. Layout rules

| Token / pattern | Value |
| --- | --- |
| Min comfortable width | ~320 logical px |
| App shell max width | 480 logical px |
| Standalone card max | 420 (pairing, offline, error) |
| Dialog max | ~md; alerts slightly tighter |
| Main padding | 16 / 20 horizontal, top 24, bottom ~128 |
| Bottom nav | fixed, same max width, safe-area bottom |
| Breakpoints | phone default; ≥640 padding / 2-col gallery / dual buttons |
| Orientation | portrait preferred |
| Height | full viewport; pairing uses full height calculations |

**Do not** expand feature layouts to full desktop multi-column dashboards; keep the scrapbook phone column (`ConstrainedBox` + `Center`).

---

## 14. Interaction rules

| State | Pattern |
| --- | --- |
| **Hover** (desktop/web) | Buttons recolor; group cards lift+tilt |
| **Pressed** | scale ~0.98 (nav, hold); slight translate on buttons |
| **Focus visible** | Ring tokens on controls |
| **Disabled** | opacity 50; offline disables create/upload |
| **Loading** | Spinner in button, skeleton pages, busy semantics |
| **Selected** | Color swatch scale+ring; tabs active; nav yellow fill |
| **Invalid** | destructive text messages; invalid borders on inputs |
| **Keyboard** | form submit on pairing nickname; dialogs trap focus where applicable |
| **Touch** | no ugly tap flash; large hold target (~208) |

---

## 15. Accessibility

| Area | Implementation |
| --- | --- |
| **Lang** | App locale `id` (`MaterialApp.locale` / l10n) |
| **Semantics** | Meaningful labels on icon buttons; exclude decorative tape/icons |
| **Live regions** | Offline notice, session checking via polite announcements where useful |
| **Alerts** | Temporary session error as assertive alert |
| **Icon buttons** | Indonesian labels (edit, hapus, upload, …) |
| **Pressed state** | Color swatches expose selected/pressed |
| **Focus** | Visible focus; modal focus scope |
| **Contrast** | Dark plum text on cream; verify scrap tone + text pairs |
| **Touch targets** | Nav 56; buttons ≥36–40; hold ~208 |
| **Safe area** | `SafeArea` / view padding for notches and home indicator |
| **Reduced motion** | Honor platform disable-animations |

---

## 16. Responsive rules

| Viewport | Behavior |
| --- | --- |
| **Phone (&lt;640)** | Single column, full-bleed shell edges, bottom nav, padding 16 |
| **Tablet / sm (≥640)** | Shell top rounded, padding 20, gallery 2 columns, dual button rows on error screens |
| **Large tablet** | Centered 480 column, side dotted canvas, deep shell shadow — still “phone UI” |
| **Ultrawide** | Same; extra margin is empty canvas, not wider content |

System UI: status bar / navigation bar colors aligned to `#fff8f1` light theme.

---

## 17. Loading / empty / error states

| State | Pattern |
| --- | --- |
| **Loading (no cache)** | Layout-matched skeleton, not blank spinner-only full screen |
| **Loading (with cache)** | Show cached content + yellow status pill “Lagi nyegerin data...” |
| **Empty** | Mint/pink scrap card + short copy + full-width CTA |
| **Error** | Pink scrap card + tape + human copy + retry |
| **Offline + cache** | Offline notice + readable cached data; mutations blocked |
| **Offline + no cache** | Offline empty: no endless skeleton; ask to reconnect |
| **Pairing waiting** | Countdown + polling status; never silent |

Never silent failure. Never infinite spinner without explanation.

---

## 18. Theme architecture

```text
lib/core/theme/
  app_colors.dart       # semantic + scrap accents
  app_spacing.dart      # 4px scale
  app_radii.dart
  app_shadows.dart
  app_typography.dart
  app_theme.dart        # ThemeData light/dark from tokens
```

- `ThemeData.colorScheme` maps semantic tokens
- Extensions (`ThemeExtension`) hold scrap accents, paper shadows, domain tones
- Feature widgets read `Theme.of(context)` / extensions — no raw hex
- Dark mode tokens exist for parity; ship only if product enables dark

### Domain tokens

```dart
const noteColors = ['yellow', 'pink', 'mint', 'blue', 'lavender'];
// map → AppColors.scrap*
```

### Brand constants

| Item | Value |
| --- | --- |
| Theme / system color | `#fff8f1` |
| App icon | Pastel paper + heart |
| Shadow ink | `103, 74, 58` |
| Primary glow | `241, 111, 143` |

---

## 19. Widget guidelines

1. Prefer composition of shared scrapbook widgets over one-off decorations.
2. One icon library only.
3. Full-width primary CTAs inside cards; icon FAB for page-level create.
4. Keep Indonesian casual copy in UI strings (l10n-ready structure even if single locale).
5. Mirror web product patterns: page header, tones, status pill, empty/error cards.
6. Use Riverpod for state; keep widgets rebuild-friendly and dumb where possible.
7. Navigation via `go_router`; shell route hosts bottom nav.

---

## 20. Implementation notes

| Web concept | Flutter equivalent |
| --- | --- |
| HTML structure | Widget tree |
| CSS / Tailwind | `ThemeData`, tokens, `BoxDecoration` |
| shadcn/ui | Shared widgets under `lib/shared/widgets` |
| React Router | `go_router` |
| fetch / axios | `dio` |
| localStorage (session) | `flutter_secure_storage` for `memberId` + `sessionToken` |
| sessionStorage (list cache) | in-memory cache + optional `shared_preferences` / Hive with TTL (gallery thumbnails memory-only) |
| Redux / Context | Riverpod |
| lucide-react | lucide_icons (or one stroke set) |
| PWA install | native install via store / sideload |
| `prefers-reduced-motion` | `MediaQuery.disableAnimations` |
| `env(safe-area-inset-*)` | `SafeArea` / `MediaQuery.viewPadding` |
| Sonner toast | themed `SnackBar` / toast package with scrapbook chrome |
| ErrorBoundary | `FlutterError` / zone + `AppErrorView` |

**Recommended package baseline (documentation intent, not lockfile):**

- `flutter_riverpod`
- `go_router`
- `dio`
- `flutter_secure_storage`
- `shared_preferences` (non-sensitive cache / flags)
- `google_fonts` or bundled font assets
- `lucide_icons` (or equivalent)
- `intl` (id_ID dates)

---

## 21. Dos & don'ts

### Do

- Use `ScrapbookCard` + scrap tones for feature surfaces
- Keep pages in vertical stack + page-header pattern
- Rotate pastel tones; default sticky yellow is OK, not mandatory everywhere
- Write short Indonesian casual copy
- Full-width primary CTAs inside cards; icon create for page actions
- Show empty/error/offline explicitly with retry or CTA
- Use one icon set with labeled icon-only controls
- Stay inside the 480 shell mental model
- Animate lightly; honor reduced motion
- Put new colors in theme tokens first

### Don't

- Don't redesign to flat enterprise gray or pure pink monochrome
- Don't nest cards inside cards
- Don't cover text with tape/stickers
- Don't introduce a second icon library
- Don't stretch layouts to full desktop width
- Don't use sharp tiny radii on primary surfaces
- Don't hardcode random hex in widgets when a token exists
- Don't hide empty sections as endless spinners
- Don't add noisy ambient animations
- Don't mix English corporate UI chrome into primary flows (prefer ID)

---

## 22. Future guideline

When adding a **new feature or widget**:

1. **Start from patterns** — page header, ScrapbookCard tones, status pill, empty/error cards, AppDialog or ConfirmAlertDialog.
2. **Tokens first** — extend theme tokens / note-color maps; avoid one-off palettes.
3. **Mobile column** — content must read well at 360×800 inside max 480 width.
4. **Tone map** — assign scrap tones deliberately (info→blue, calm empty→mint, warning/offline→yellow, romantic→pink).
5. **Typography** — eyebrow → large black title → bold muted description.
6. **Controls** — reuse AppButton, AppTextField/AppTextArea/AppSelectField, date fields.
7. **Motion** — 100–180ms ease-out; no new animation libraries without need.
8. **A11y** — Indonesian labels, focus rings, 40px+ targets, decorative icons hidden.
9. **Skeleton** — add a matching skeleton if the page loads async.
10. **Document** — update this `design.md` when introducing a new repeated pattern.

### Widget checklist (PR)

- [ ] Uses existing tokens / ScrapbookCard where appropriate  
- [ ] Matches spacing scale and radius language  
- [ ] Empty, error, loading, offline considered  
- [ ] Icon-only controls labeled  
- [ ] Works in 480 shell + bottom nav clearance  
- [ ] No contrast regressions on scrap tones  

---

## Design inconsistencies (carry-over)

Documented for alignment later — **not product redesign**.

| Issue | Detail | Recommendation |
| --- | --- | --- |
| **Font split** | Web mixed Inter / Nunito | Pick one primary font for Flutter and stick to it |
| **Dark scrap accents** | Dark semantic tokens existed; scrap accents incomplete | Define dark scrap accents if dark mode ships |
| **Hover tokens in dark** | Some hover tokens light-only | Define dark press companions or opacity presses |
| **Radius scatter** | Mix of 18–32 values | Consolidate: card 28, panel ~20, shell 32, control pill |
| **Shadow scatter** | Near-duplicate warm shadows | Named `AppShadows.paper`, `.lifted`, `.hold`, etc. |
| **Button weight** | medium vs extrabold elsewhere | Acceptable hierarchy; optionally bump primary CTA weight |
| **Sticky note chrome** | Home mini-notes vs Notes page differ slightly | Keep intentional density difference or extract shared `StickyNoteCard` |
| **Label underused** | Raw text styles instead of shared label | Prefer `AppLabel` |
| **Coming-soon vs live features** | Gallery/Dates may be live in product | Use live screen patterns as source of truth |
| **Lists category colors** | Extra raw palette exits | Map fully to scrap tokens + foreground |

---

## Quick reference — screen map

| Route path | Screen | Signature UI |
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

## File index (Flutter target)

| Area | Location |
| --- | --- |
| Tokens & theme | `lib/core/theme/**` |
| Shared widgets | `lib/shared/widgets/**` |
| App chrome | `lib/shared/widgets/app_shell.dart`, `scrapbook_card.dart`, … |
| Features / screens | `lib/features/**` |
| Note color domain | `lib/features/notes/domain/note_colors.dart` |
| Product intent | `docs/product-brief.md`, `docs/ui-direction.md` |
| Platform chrome | Android/iOS launch icons, splash, system UI styles |

---

*Flutter design source of truth for OurSpace. Preserve business requirements from product docs; update this document when the implemented visual language changes.*
