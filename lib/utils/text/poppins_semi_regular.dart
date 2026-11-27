import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../constants.dart';

class PoppinsSemiRegularText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const PoppinsSemiRegularText({
    Key? key,
    required this.text,
    this.fontSize = 12,
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
        color: color ?? AppColors.black,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        fontFamily: Constants.fontFamily,
        //  height: Dimensions.lineHeight,
        overflow: overflow,
      ),
      maxLines: maxLines ?? 2,
    );
  }
}
