import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../constants.dart';

class ViewAllText extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  VoidCallback? onClicked;
  final int? maxLines;

  ViewAllText({
    Key? key,
    this.fontSize = 12,
    this.color,
    this.onClicked,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Text(
        "viewAll",
        textAlign: textAlign,
        style: TextStyle(
          color: AppColors.lightPrimary,
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontFamily: Constants.fontFamily,
          //  height: Dimensions.lineHeight,
          overflow: overflow,
        ),
        maxLines: maxLines,
      ),
    );
  }
}
