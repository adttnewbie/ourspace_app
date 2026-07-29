# Accessibility

> a11y requirements for OurSpace Flutter. Complements [design.md](../design.md) § Accessibility.

**Related:** [copy-catalog.md](./copy-catalog.md) · [screen-specs/](./screen-specs/) · [coding-standard.md](./coding-standard.md)

---

## 1. Goals

- Two users on personal phones; thumbs first.
- TalkBack (Android) and VoiceOver (iOS) can complete: pair, read home, CRUD own notes, open settings.
- Status never conveyed by color alone.
- Honor reduced motion / `disableAnimations`.

---

## 2. Touch targets

| Control | Minimum |
| --- | --- |
| Bottom nav item | 56 logical px height |
| Text buttons | ≥ 40–48 height |
| Icon-only | ≥ 40×40 (prefer 48) |
| Color swatch | 32 visual but hit area ≥ 40 |
| Pairing hold | ~208 circle |

Use `minimumSize` on buttons; padding on custom ink.

---

## 3. Screen readers (TalkBack / VoiceOver)

| Rule | Practice |
| --- | --- |
| Icon-only | `Semantics(label: '…', button: true)` or `tooltip` + Semantics |
| Decorative | `ExcludeSemantics` / `critical: false` on tape, dots, pure ornament |
| Images | Gallery: caption as label; decorative stickers excluded |
| Live updates | Offline banner: `liveRegion: true` where supported |
| Custom hold button | Announce state changes: holding / waiting / paired / expired via Semantics |
| Tabs | Selected state exposed |

Test at least once per release on one Android + one iOS device with screen reader on.

---

## 4. Semantics & focus order

- Logical reading order top → bottom; nav last or as platform landmark.
- Dialogs: focus trapped in route/dialog scope (Flutter default modal barrier).
- After delete confirm, focus returns to list sensibly (avoid lost focus).
- Form fields: explicit labels (`AppLabel` + `TextField` semantics).

---

## 5. Contrast

- Primary text `foreground` `#332838` on cream/paper — maintain WCAG-ish AA for body where feasible.
- Pastel scrap **backgrounds** with dark plum text — verify each tone (pink/mint/yellow/blue/lavender).
- Do not use yellow text on yellow scrap.
- Error/destructive text on pink cards: use destructive or foreground, not light-on-light.
- Active nav yellow + dark label.

---

## 6. Dynamic text / font scaling

- Use `sp`-like logical font sizes via theme `TextTheme` (Flutter scales with MediaQuery textScaler).
- Avoid fixed-height boxes that clip 200% text on critical copy (greeting, errors, pairing instructions).
- Allow sticky note body to grow / scroll in editor.
- Large page titles may ellipsize only after generous max lines.

---

## 7. Keyboard / switch (where applicable)

- Android/iOS external keyboard: form fields focusable; submit pairing nickname with action.
- Web/desktop embed (if ever): visible focus rings from design tokens (`ring`).
- v1 primary is touch phone — still keep Material focus indicators.

---

## 8. Reduced motion

| Setting | Behavior |
| --- | --- |
| `MediaQuery.disableAnimations == true` | Skip long transitions; hold progress may become determinate instant or short |
| Skeleton pulse | Static placeholder blocks acceptable |
| Pairing success | Short or instant before navigate |

Do not rely on motion alone to communicate hold completion — also use progress value / text.

---

## 9. Color-blind / non-color cues

- Selected color swatch: scale + ring, not only fill.
- Status chips: text labels (`planned`, offline copy), not only hue.
- Ownership: show nickname text, not only color coding.

---

## 10. Localization & language

- `MaterialApp.locale` / supported locales include `id`.
- Semantics labels in Indonesian to match UI.
- Copy catalog ids map to spoken strings.

---

## 11. Platform system UI

- Status bar icons contrast on `#fff8f1`.
- Respect `SafeArea` / notches / home indicator — never put primary actions in unsafe zones (bottom nav already padded).
- Keyboard insets: editors/`padding` viewInsets so actions remain tappable.

---

## 12. QA checklist (a11y)

- [ ] TalkBack: pairing hold + waiting announced  
- [ ] TalkBack: create note dialog labels  
- [ ] VoiceOver: bottom nav labels  
- [ ] Font scale 1.5×: home + notes readable  
- [ ] Reduced motion: no long decorative animation  
- [ ] Contrast spot-check scrap tones  
- [ ] Offline banner not color-only  
