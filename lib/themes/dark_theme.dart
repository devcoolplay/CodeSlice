import 'package:flutter/material.dart';

import '../shared/constants.dart';

ThemeData darkTheme = ThemeData(
  highlightColor: Colors.grey[400],
  disabledColor: Colors.white,
  iconTheme: IconThemeData(
    color: Colors.grey[400],
  ),
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black54,
    foregroundColor: Colors.white,
  ),
  secondaryHeaderColor: Colors.grey[800]!,
  colorScheme: ColorScheme.dark(
    background: Colors.black54,
    primary: primarySwatchColor,
    secondary: Colors.grey[800]!,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: primarySwatchColor,
);