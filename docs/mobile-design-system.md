# CoachMax mobile design system

The coach app uses the CoachMax brand foundation from `../../coachmax_admin_frontend/design.md`: blue for actions, navy for identity, neutral content surfaces, and Outfit typography. This implementation follows the user's request to adopt that foundation for mobile. The original academy logo is preserved; its red is an identity detail rather than an additional UI accent.

## Roles

| Role | Value | Use |
| --- | --- | --- |
| Primary | #0047FF | Primary actions, links, focus, selected controls |
| Primary pressed | #0039CC | Pressed action state |
| Primary soft | #E0EBFF | Selected navigation and informational surfaces |
| Navy | #031549 | Brand entry screens and session spotlight |
| On navy | #FFFFFF / #CDD8F0 | Primary / supporting text on dark surfaces |
| Background / surface | #F9FAFB / #FFFFFF | Page and content surfaces |
| Main / supporting / muted text | #101828 / #475467 / #667085 | Readable text hierarchy |
| Border / divider | #D0D5DD / #EAECF0 | Fields and restrained section separation |
| Success | #039855; text #027A48 | Confirmed and present states |
| Error | #D92D20 | Errors and destructive actions |
| Warning | #B54708 | Pending or caution states |

`lib/core/theme/brand_colors.dart` owns every color. Use `primary` on light surfaces and `onNavyAccent` for accent text on navy. Pair status color with a label or icon. Do not place small blue text on navy.

## Typography and layout

Outfit is bundled as a variable font for offline use. Its SIL Open Font License is stored beside the font. Source: https://github.com/google/fonts/tree/main/ofl/outfit.

`AppTypography` defines the text scale; `Theme.of(context).textTheme` is the preferred interface. Use 32/28 px page headings, 24/20 px section headings, 16 px primary body, 14 px secondary body, and 12 px captions. Keep meaningful content readable with system text scaling.

`AppSpacing` defines a 4/8/16/24/32 spacing rhythm, 24 px page inset, 8 px field/button corners, and 16 px content corners. Controls have a 52 px minimum height and may grow when text scales. Use separators and open sections for lists; reserve a contained surface for genuinely grouped or highlighted information.

Icons use 18, 22, and 28 px sizes from `AppIcons`. `AppMotion` defines 160 ms feedback and 240 ms transitions; respect reduced motion. Avoid decorative gradients and heavy shadows.

## Reusable components

- `AppButton`: primary, secondary, and text actions; keeps labels visible during loading, prevents repeat taps, and accepts real icon widgets.
- `AppTextField`: persistent visible label, themed focus/error borders, validation, keyboard/autofill support, and password visibility controls.
- `AppBottomNavigation`: labeled destinations, visible selected state, accessible semantics, and reduced-motion support.
- `AppStateView`: empty/error content with an optional recovery action.

Older `utils/component` button and field helpers are compatibility adapters to the same system. New screens should use `shared/widgets` directly. Legacy typography wrappers inherit Outfit through the shared font constant; do not add more wrappers named after fonts.

## Screen composition

Entry screens use a solid navy identity surface, the unmodified logo, an editorial headline, and one clear action. Sign-in uses a quiet neutral page, a focused form, inline errors, and a single primary action. The dashboard uses a restrained navy session spotlight and separated schedule rows. The spotlight reflects the first assigned class returned by the existing API; it does not claim to calculate the next chronological session.

Native Android and iOS display names are `CoachMax Coach`; native launch backgrounds match the Flutter navy surface. Check launch appearance on physical Android/iOS devices before release.

## Project boundaries

```text
lib/
  core/theme/       palette, typography, theme, spacing, icons, motion
  shared/widgets/  reusable presentation and interaction contracts
  ui/auth/         entry and authentication composition
  ui/dashboard/    coaching screens and domain-specific presentation
  bloc/            feature state and orchestration
  repository/      repository interfaces/implementations
  network/         transport and generated API clients
  dto/             serialized API models
  utils/           supporting utilities and compatibility adapters
```

Keep network calls and feature state out of shared widgets. Extract domain-specific screen sections when they are reused or become independently complex. Do not move unrelated API/data code solely for visual changes.

Run `flutter analyze --no-pub` and `flutter test`. The widget tests cover form validation, loading behavior, navigation, contrast, missing asset references, and compact/large-text layouts. They write review screenshots to the operating system temp directory under `coachmax-brand-previews`.
