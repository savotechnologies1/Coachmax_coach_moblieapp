import 'package:flutter/material.dart';

import '../constants.dart';
import '../dimensions.dart';

class PoppinsTitleMediumText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const PoppinsTitleMediumText({
    Key? key,
    required this.text,
    this.fontSize = Dimensions.textExtraLargeSize,
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        fontFamily: Constants.fontFamily,
        //  height: Dimensions.lineHeight,
        overflow: overflow,
      ),
      maxLines: maxLines ?? 2,
    );
  }
}
