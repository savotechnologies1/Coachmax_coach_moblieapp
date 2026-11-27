import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../dimensions.dart';

class MyContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;

  const MyContainer({Key? key, required this.child, this.padding, this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding:
          padding ??
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingHorizontal),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        border: Border.all(color: AppColors.grayColor),
        borderRadius: BorderRadius.circular(Dimensions.radius),
      ),
      child: child,
    );
  }
}
