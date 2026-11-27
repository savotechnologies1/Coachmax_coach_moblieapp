import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../constants.dart';

class PoppinsTitleRegularText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const PoppinsTitleRegularText({
    Key? key,
    required this.text,
    this.fontSize = 20,
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
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.onSurface,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        fontFamily: Constants.fontFamily,
        //  height: Dimensions.lineHeight,
        overflow: overflow,
      ),
      maxLines: 2,
    );
  }
}
