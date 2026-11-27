import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../constants.dart';

class PoppinsSubTitleRegularText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const PoppinsSubTitleRegularText({
    Key? key,
    required this.text,
    this.fontSize = 16,
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
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: Constants.fontFamily,
        //  height: Dimensions.lineHeight,
        overflow: overflow,
      ),
      // maxLines: maxLines??1,
    );
  }
}
