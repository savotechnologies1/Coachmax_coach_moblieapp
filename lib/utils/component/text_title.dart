import 'package:flutter/cupertino.dart';

import '../app_colors.dart';

class TextTitle extends StatelessWidget {
  final String text;
  final double fontSize;

  const TextTitle({Key? key, required this.text, this.fontSize = 30})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.black,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
