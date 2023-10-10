import 'package:flutter/material.dart';

import '../shared/constants.dart';

ThemeData darkTheme = ThemeData(
  highlightColor: Colors.grey[400],
  disabledColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(primarySwatchColor),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    )
  ),
  iconTheme: IconThemeData(
    color: Colors.grey[400],
  ),
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black54,
    foregroundColor: Colors.white,
  ),
  secondaryHeaderColor: Colors.grey[800]!,
  colorScheme: const ColorScheme.dark(
    background: Colors.black54,
    primary: primarySwatchColor,
    secondary: Colors.white,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: primarySwatchColor,
);