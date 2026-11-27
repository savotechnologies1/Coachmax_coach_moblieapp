import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../constants.dart';

class PoppinsSemiMediumText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const PoppinsSemiMediumText({
    Key? key,
    required this.text,
    this.fontSize = 12,
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: Constants.fontFamily,
        //  height: Dimensions.lineHeight,
        overflow: overflow,
      ),
      maxLines: 2,
    );
  }
}
