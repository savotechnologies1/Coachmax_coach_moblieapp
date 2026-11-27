# CoachMax mobile UI and engineering instructions

Act as a senior mobile product designer and Flutter UI engineer. Build a premium, minimal, clean, modern, elegant, balanced, professional app that is easy to use. These rules apply throughout this coach app.

## Design before implementation

Before implementing a screen, understand its purpose and primary action, plan its visual hierarchy, choose layout and navigation, select reusable components, and consider loading, empty, and error states. Design each screen for its purpose; do not apply the same layout everywhere.

## Visual design

- Use clear page titles, a strong typography hierarchy, balanced whitespace, carefully selected colors, consistent modern icons, subtle borders, and clean surfaces.
- Favor custom headers, modern bottom navigation, clean content sections, useful asymmetric layouts, considered empty states, search and filters, contextual bottom sheets, focused onboarding, premium profiles, and responsive dashboards.
- Avoid default Flutter app bars, generic dashboard cards everywhere, basic boxed forms, old list layouts, excessive rounded cards, random gradients, heavy shadows, too many floating buttons, and unnecessary decoration.
- Material 3 is a foundation, not the finished design. Customize it to the CoachMax system.
- Use lightweight, restrained animation and respect reduced-motion preferences.
- If a screen feels generic, crowded, dated, or like a default template, improve it before finishing.

## Shared design system

- Read `docs/mobile-design-system.md` and use `lib/core/theme/` as the source of truth for palette, typography, spacing, radii, icon sizes, motion, and navigation.
- Use the documented CoachMax blue and navy palette with bundled Outfit. Keep the original logo artwork intact; its red is a logo detail, while UI red represents errors or destructive actions.
- Use semantic color roles, including readable foreground colors on dark surfaces. Do not add screen-specific hex colors or font families.
- Use `lib/shared/widgets/` for reusable controls and state patterns. Keep domain-specific UI in its screen or feature widgets.
- Use Flutter Material controls for keyboard, focus, and accessibility behavior, with the shared custom styling. Give icon-only actions labels, preserve text scaling, and expose loading and selected states.
- Maintain Android and iOS compatibility. Keep the native product name and launch colors aligned with the Flutter app.

## Structure and verification

Keep theme and branding in `core`, reusable presentation in `shared`, screen composition in `ui`, state in `bloc`, and API/data contracts in `network`, `repository`, and `dto`. Avoid mixing business or API logic into reusable widgets.

Run formatting, static analysis, and focused tests for affected behaviors. Verify narrow screens, larger text, input validation, loading, and primary actions. Report any remaining device-specific verification limits accurately.
