# CoachMax Coach

Flutter coaching workspace for assigned sessions, attendance, player profiles, temporary players, and parent conversations.

Repository: [savotechnologies1/Coachmax_coach_moblieapp](https://github.com/savotechnologies1/Coachmax_coach_moblieapp).

Read [AGENTS.md](AGENTS.md) before changing UI and [the mobile design system](docs/mobile-design-system.md) for palette, typography, components, and project boundaries.

```sh
flutter pub get
flutter run --dart-define=COACHMAX_API_BASE_URL=https://your-api-host/
flutter analyze --no-pub
flutter test
```

The API URL defaults to the existing CoachMax deployment. Outfit is bundled locally with its font license. Android and iOS both use the display name **CoachMax Coach**.
