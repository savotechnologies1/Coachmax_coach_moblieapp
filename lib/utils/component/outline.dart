import 'package:flutter/material.dart';
import '../../shared/widgets/app_button.dart';

class OutLineButton extends StatelessWidget {
  const OutLineButton({
    super.key,
    required this.onPress,
    required this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.textColor,
    this.fontSize = 16,
    this.borderColor,
  });
  final Function onPress;
  final String text;
  final double? height, width, borderRadius;
  final double fontSize;
  final Color? textColor, borderColor;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: AppButton(
      label: text,
      onPressed: () => onPress(),
      variant: AppButtonVariant.secondary,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
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
