import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primaryColor = Colors.black;
  static const Color statusBarColor = primaryColor;

  static final theme = ThemeData(
    // TODO: later
    //fontFamily: GoogleFonts.roboto().fontFamily,
  );

  static final SystemUiOverlayStyle systemUIOverlayStyle =
      SystemUiOverlayStyle.light.copyWith(statusBarColor: statusBarColor);

  AppTheme._();
}
