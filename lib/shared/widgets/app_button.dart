import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, text }

/// Accessible Material button with one loading/disabled contract.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = true,
    this.variant = AppButtonVariant.primary,
    this.style,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final bool expand;
  final AppButtonVariant variant;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
    final callback = isLoading ? null : onPressed;
    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: callback,
        style: style,
        child: content,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: callback,
        style: style,
        child: content,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: callback,
        style: style,
        child: content,
      ),
    };
    return Semantics(
      liveRegion: isLoading,
      value: isLoading ? 'Loading' : null,
      child: SizedBox(width: expand ? double.infinity : null, child: button),
    );
  }
}
