import '../core/theme/app_typography.dart';

class Constants {
  static const appName = "CoachMax Coach";
  static const fontFamily = AppTypography.fontFamily;
  static const baseurl = String.fromEnvironment(
    'COACHMAX_API_BASE_URL',
    defaultValue: 'https://coachmax.server24.in/',
  );
  static const baseurlImg = baseurl;
}
