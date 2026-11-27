import 'package:flutter/material.dart';

/// Compatibility helper: all field states are supplied by AppTheme.
abstract final class TextFieldStyleDecoration {
  static InputDecoration inputDecoration(
    String? hintText,
    BuildContext context, {
    String? prefixIconName,
    Widget? suffixIconWidget,
    Widget? prefixIconWidget,
    Color? fillColor,
    Widget? counterText,
  }) => InputDecoration(
    hintText: hintText,
    fillColor: fillColor,
    prefixIcon:
        prefixIconWidget ??
        (prefixIconName == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(prefixIconName, width: 24, height: 24),
              )),
    suffixIcon: suffixIconWidget,
    counter: counterText,
  );
}
