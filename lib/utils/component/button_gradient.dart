import 'package:flutter/material.dart';
import '../../shared/widgets/app_button.dart';

/// Legacy name retained for compatibility; primary actions now use a solid fill.
class ButtonGradient extends StatelessWidget {
  const ButtonGradient({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 52,
    this.textColor,
    this.gradient,
  });
  final String text;
  final Function onPressed;
  final double? height;
  final Color? textColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) => AppButton(
    label: text,
    onPressed: () => onPressed(),
    style: FilledButton.styleFrom(
      minimumSize: Size(48, height ?? 52),
      foregroundColor: textColor,
    ),
  );
}
