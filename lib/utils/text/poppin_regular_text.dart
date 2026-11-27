import 'package:flutter/material.dart';

import '../constants.dart';

class PoppinsRegularText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const PoppinsRegularText({
    Key? key,
    required this.text,
    this.fontSize = 14,
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
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        fontFamily: Constants.fontFamily,
        //  height: Dimensions.lineHeight,
        overflow: overflow,
      ),
      //  height: Dimensions.lineHeight,
    );
  }
}
