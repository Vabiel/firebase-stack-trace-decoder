import 'package:flutter/material.dart';

class AppTheme {
  static const borderColor = Color(0xff9b9b9b);

  static final theme = ThemeData(
      // TODO: later
      //fontFamily: GoogleFonts.roboto().fontFamily,
      );

  static final boxBorder = BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: borderColor),
  );

  AppTheme._();
}
