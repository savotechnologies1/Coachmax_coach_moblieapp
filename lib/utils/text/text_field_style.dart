import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../constants.dart';
import '../dimensions.dart';

class TextFieldStyle {
  TextStyle textStyle(BuildContext context, {textSize}) {
    return TextStyle(
      color: Theme.of(context).brightness == Brightness.light
          ? AppColors.black
          : AppColors.whiteColor,
      fontSize: 14,
      fontFamily: Constants.fontFamily,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle hintStyle(BuildContext context, {textSize}) {
    return TextStyle(
      color: /*Theme.of(context).brightness == Brightness.light ?
        AppColors.black : */
          AppColors.hintColor,
      fontSize: 14,
      fontFamily: Constants.fontFamily,
      fontWeight: FontWeight.w400,
    );
  }
}
