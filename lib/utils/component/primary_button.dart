import 'package:flutter/material.dart';
import '../../shared/widgets/app_button.dart';

/// Compatibility adapter. Prefer AppButton for new screens.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.fontSize,
    this.fontStyle,
    this.backgroundColor,
    this.onClicked,
    this.enableAnimation = true,
    this.borderColor,
    this.fontColor,
    this.borderRadius,
    this.icons,
    this.isShowShadow = false,
  });
  final String? text;
  final double? width, height, fontSize, borderRadius;
  final String? fontStyle;
  final Color? backgroundColor, borderColor, fontColor;
  final VoidCallback? onClicked;
  final bool enableAnimation, isShowShadow;
  final Widget? icons;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: AppButton(
      label: text ?? '',
      onPressed: onClicked,
      icon: icons,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: fontColor,
        minimumSize: Size(48, height ?? 52),
        textStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontSize: fontSize),
        side: borderColor == null ? null : BorderSide(color: borderColor!),
        shape: borderRadius == null
            ? null
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
      ),
    ),
  );
}
