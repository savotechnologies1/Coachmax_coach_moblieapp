import '../core/theme/brand_colors.dart';

/// Compatibility aliases for older helpers. New UI uses BrandColors directly.
abstract final class AppColors {
  static const primary = BrandColors.primary;
  static const primaryColor = BrandColors.primary;
  static const textColor = BrandColors.text;
  static const black = BrandColors.text;
  static const whiteColor = BrandColors.surface;
  static const transparent = BrandColors.transparent;
  static const grayColor = BrandColors.border;
  static const dividerColor = BrandColors.divider;
  static const subtextColor = BrandColors.textMuted;
  static const hintColor = BrandColors.textMuted;
  static const lightGrey = BrandColors.textMuted;
  static const lightPrimary = BrandColors.primary;
  static const contianertextborder = BrandColors.border;
  static const lightRedColor = BrandColors.error;
  static const redColor = BrandColors.error;
  static const flushDoneColor = BrandColors.successText;
}
