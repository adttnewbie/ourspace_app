---
name: Tactile Memory
colors:
  surface: "#faf9f5"
  surface-dim: "#dbdad6"
  surface-bright: "#faf9f5"
  surface-container-lowest: "#ffffff"
  surface-container-low: "#f4f4f0"
  surface-container: "#efeeea"
  surface-container-high: "#e9e8e4"
  surface-container-highest: "#e3e2df"
  on-surface: "#1b1c1a"
  on-surface-variant: "#514347"
  inverse-surface: "#2f312e"
  inverse-on-surface: "#f2f1ed"
  outline: "#837377"
  outline-variant: "#d5c2c6"
  surface-tint: "#864d61"
  primary: "#864d61"
  on-primary: "#ffffff"
  primary-container: "#ffb7ce"
  on-primary-container: "#7b4458"
  inverse-primary: "#fab3ca"
  secondary: "#685f25"
  on-secondary: "#ffffff"
  secondary-container: "#eee199"
  on-secondary-container: "#6d6329"
  tertiary: "#1e667a"
  on-tertiary: "#ffffff"
  tertiary-container: "#93d4eb"
  on-tertiary-container: "#0d5d70"
  error: "#ba1a1a"
  on-error: "#ffffff"
  error-container: "#ffdad6"
  on-error-container: "#93000a"
  primary-fixed: "#ffd9e3"
  primary-fixed-dim: "#fab3ca"
  on-primary-fixed: "#360b1e"
  on-primary-fixed-variant: "#6a364a"
  secondary-fixed: "#f1e39c"
  secondary-fixed-dim: "#d4c782"
  on-secondary-fixed: "#201c00"
  on-secondary-fixed-variant: "#50470f"
  tertiary-fixed: "#b4ebff"
  tertiary-fixed-dim: "#8fd0e6"
  on-tertiary-fixed: "#001f27"
  on-tertiary-fixed-variant: "#004e5f"
  background: "#faf9f5"
  on-background: "#1b1c1a"
  surface-variant: "#e3e2df"
typography:
  display-lg:
    fontFamily: Bricolage Grotesque
    fontSize: 48px
    fontWeight: "800"
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Bricolage Grotesque
    fontSize: 32px
    fontWeight: "700"
    lineHeight: 40px
  headline-sm:
    fontFamily: Bricolage Grotesque
    fontSize: 24px
    fontWeight: "600"
    lineHeight: 32px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: "500"
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: "400"
    lineHeight: 24px
  label-caps:
    fontFamily: Space Mono
    fontSize: 12px
    fontWeight: "700"
    lineHeight: 16px
    letterSpacing: 0.1em
  handwritten-note:
    fontFamily: Bricolage Grotesque
    fontSize: 20px
    fontWeight: "400"
    lineHeight: 28px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 24px
  element-gap: 16px
  stack-overlap: -12px
  tape-width: 64px
---

## Brand & Style

The design system is built on a **Digital Scrapbook** aesthetic, designed to evoke the warmth of a shared physical journal. It targets couples who want a private, creative sanctuary to archive their relationship.

The style combines **Minimalist structure** with **Tactile layers**. It utilizes paper textures, "washi tape" accents, and hand-drawn doodles to create an intimate, joyful, and cozy atmosphere. The UI should feel like a collection of physical artifacts pinned to a board rather than a sterile software interface.

**Key Visual Principles:**

- **Layering:** Elements should overlap slightly to suggest depth.
- **Imperfection:** Use organic, slightly irregular lines and "torn" edges for containers.
- **Personalization:** UI decorations should mimic stickers and ink sketches.

## Colors

The palette is a vibrant, "Sun-Drenched Pastel" collection that feels optimistic and celebratory.

- **Primary (Pastel Pink):** Used for heart-actions, primary buttons, and romantic highlights.
- **Secondary (Sunny Yellow):** Used for "Washi tape" accents, reminders, and joyful notes.
- **Tertiary (Sky Blue):** Used for secondary interactions and background sections.
- **Quaternary (Mint Green):** Used for growth-related trackers (anniversaries, goals).
- **Neutral (Cream):** A warm, off-white background (#FDFCF8) that mimics high-quality heavy-stock paper rather than a digital screen.

All colors should maintain high saturation but remain in the pastel family to ensure a soft, cozy legibility.

## Typography

This design system uses a trio of fonts to balance playfulness with clarity.

1.  **Bricolage Grotesque (Headings):** Chosen for its quirky, expressive terminals that mimic high-character handwriting and vintage press.
2.  **Plus Jakarta Sans (Body):** A soft, modern sans-serif that ensures long-form memories and chat messages remain highly readable.
3.  **Space Mono (Captions/Labels):** Used sparingly to represent "Typewriter" metadata (dates, timestamps, locations).

**Mobile Scaling:**
For mobile devices, `display-lg` should scale down to `32px` to prevent clipping, while `body-md` remains at `16px` for optimal legibility.

## Layout & Spacing

The layout philosophy follows a **Dynamic Stack** model rather than a rigid grid.

- **The Canvas:** Use a 12-column grid on desktop but allow elements to "tilt" (rotate by 1-2 degrees) and overlap using negative spacing (`stack-overlap`).
- **Margins:** Generous outer margins (24px on mobile) to create a "contained journal" look.
- **Rhythm:** Spacing is based on an 8px base unit. However, vertical spacing between different "sections" (e.g., between a photo and a text note) should be irregular to feel hand-placed.
- **Safe Zones:** While elements can tilt, critical UI like navigation bars and input fields must remain strictly horizontal and aligned.

## Elevation & Depth

Depth is achieved through **Physical Layering** rather than traditional software shadows.

- **Paper Layers:** Cards use a "Stacked Paper" effect. This is created using a 1px solid border in a slightly darker version of the surface color, plus a crisp, offset shadow (4px 4px 0px) rather than a blurred one.
- **Shadow Character:** Shadows should be low-blur and high-opacity (e.g., `rgba(0,0,0,0.1)`), mimicking the look of a card lifted slightly off a table.
- **Washi Tape:** Use semi-transparent overlays at the top or corners of cards to "anchor" them to the background.
- **Torn Edges:** Important section dividers should use a mask-image or SVG path to create a rough, torn-paper texture.

## Shapes

The shape language is organic and soft.

- **Primary Containers:** Use `rounded-lg` (16px) for cards and photos to mimic rounded photo-print corners.
- **Interactive Elements:** Buttons use a "Squircle" or Pill-shape for a friendly, touchable feel.
- **Doodles:** Icons and decorative separators should look hand-drawn with varying stroke weights.
- **The "Tape":** Rectangular accents used for buttons or labels should have slightly jagged "torn" ends on the left and right sides.

## Components

### Buttons

- **Primary:** High-contrast background (Primary Pink), bold 2px border, and a "tilted" hover state.
- **Ghost:** Use a "Doodle" style with a hand-drawn stroke border and no fill.

### Cards (Memory Tiles)

- Cards should have a `2deg` or `-2deg` rotation applied randomly to their containers.
- Every card must feature a "Tape" or "Sticker" element in the corner to justify its placement on the "Canvas."

### Input Fields

- Designed to look like a "ruled notebook" line. Use a solid bottom border only, with a small hand-drawn "pen" icon as a suffix.

### Chips & Tags

- Designed as "Dymo labels" or small stickers. High saturation backgrounds with white `Space Mono` text.

### Interactive "Doodles"

- Checkboxes should appear as hand-drawn squares that get a "cross-out" or "heart" when checked.
- Progress bars should look like a colored pencil fill-in.

### Navigation

- A floating bottom bar that looks like a "Bookmark" strip, using fabric-like textures or simple felt-tip pen icons.
