import 'package:flutter/material.dart';

import '../app_colors.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 0, right: 5, top: 15),
        child: const Icon(
          Icons.arrow_back_outlined,
          size: 24,
          color: AppColors.black,
        ),
      ),
    );
  }
}
