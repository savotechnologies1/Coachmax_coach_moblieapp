import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'brand_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: BrandColors.primary)
        .copyWith(
          primary: BrandColors.primary,
          onPrimary: BrandColors.onPrimary,
          primaryContainer: BrandColors.primarySoft,
          onPrimaryContainer: BrandColors.navy,
          secondary: BrandColors.navy,
          onSecondary: BrandColors.onNavy,
          secondaryContainer: BrandColors.surfaceMuted,
          onSecondaryContainer: BrandColors.text,
          tertiary: BrandColors.primary,
          onTertiary: BrandColors.onPrimary,
          tertiaryContainer: BrandColors.primarySoft,
          onTertiaryContainer: BrandColors.navy,
          surfaceContainerLowest: BrandColors.surface,
          surfaceContainerLow: BrandColors.background,
          surfaceContainer: BrandColors.surfaceMuted,
          surfaceContainerHigh: BrandColors.surfaceMuted,
          surfaceContainerHighest: BrandColors.divider,
          surfaceTint: BrandColors.transparent,
          surface: BrandColors.surface,
          onSurface: BrandColors.text,
          onSurfaceVariant: BrandColors.textMuted,
          outline: BrandColors.border,
          outlineVariant: BrandColors.divider,
          error: BrandColors.error,
          onError: BrandColors.onPrimary,
          errorContainer: BrandColors.errorSoft,
        );
    final text = AppTypography.textTheme.apply(
      fontFamily: AppTypography.fontFamily,
      bodyColor: BrandColors.text,
      displayColor: BrandColors.text,
    );
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.controlRadius)),
    );
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
          borderSide: BorderSide(color: color, width: width),
        );
    final actionFill = WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) return BrandColors.disabled;
      if (states.contains(WidgetState.pressed))
        return BrandColors.primaryPressed;
      return BrandColors.primary;
    });
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: BrandColors.background,
      dividerColor: BrandColors.divider,
      iconTheme: const IconThemeData(color: BrandColors.textSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: BrandColors.background,
        foregroundColor: BrandColors.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandColors.surface,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        hintStyle: text.bodyMedium?.copyWith(color: BrandColors.textMuted),
        labelStyle: text.bodyMedium,
        errorStyle: text.bodySmall?.copyWith(color: BrandColors.error),
        errorMaxLines: 3,
        border: border(BrandColors.border),
        enabledBorder: border(BrandColors.border),
        focusedBorder: border(BrandColors.primary, 2),
        errorBorder: border(BrandColors.error),
        focusedErrorBorder: border(BrandColors.error, 2),
        disabledBorder: border(BrandColors.divider),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: shape,
          textStyle: text.labelLarge,
        ).copyWith(backgroundColor: actionFill),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandColors.primary,
          foregroundColor: BrandColors.onPrimary,
          minimumSize: const Size(48, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: shape,
          elevation: 0,
          textStyle: text.labelLarge,
        ).copyWith(backgroundColor: actionFill),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.primary,
          minimumSize: const Size(48, AppSpacing.controlHeight),
          side: const BorderSide(color: BrandColors.border),
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.primary,
          minimumSize: const Size(48, 48),
          textStyle: text.labelMedium,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: BrandColors.primary,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: BrandColors.primary,
        selectionColor: BrandColors.primarySoft,
        selectionHandleColor: BrandColors.primary,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: BrandColors.navy,
        contentTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          color: BrandColors.onNavy,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: BrandColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: BrandColors.primarySoft,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? BrandColors.primary
                : BrandColors.textMuted,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          text.labelSmall?.copyWith(color: BrandColors.textMuted),
        ),
      ),
    );
  }
}
