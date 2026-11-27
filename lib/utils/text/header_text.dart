import 'package:flutter/material.dart';

import '../constants.dart';
import '../dimensions.dart';

/*
* Size: 20
* Weight: 500
* */
class HeaderText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const HeaderText({
    Key? key,
    required this.text,
    this.fontSize = Dimensions.textLargeSize,
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
        fontWeight: fontWeight ?? FontWeight.bold,
        fontFamily: Constants.fontFamily,
        //  height: Dimensions.lineHeight,
        overflow: overflow,
      ),
    );
  }
}
