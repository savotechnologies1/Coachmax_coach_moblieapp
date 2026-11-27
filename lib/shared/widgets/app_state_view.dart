import 'package:flutter/material.dart';
import '../../core/theme/brand_colors.dart';
import 'app_button.dart';

/// Inline or full-page empty/error state with an optional recovery action.
class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.event_available_outlined,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 32, color: BrandColors.primary),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: BrandColors.textMuted),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 16),
          AppButton(
            label: actionLabel!,
            onPressed: onAction,
            expand: false,
            variant: AppButtonVariant.secondary,
          ),
        ],
      ],
    ),
  );
}
