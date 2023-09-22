import 'package:flutter/material.dart';

import '../shared/constants.dart';

ThemeData lightTheme = ThemeData(
  disabledColor: Colors.black,
  iconTheme: IconThemeData(
    color: Colors.grey[600],
  ),
  highlightColor: Colors.grey[600]!,
  //brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: primarySwatchColor,
    secondary: Colors.grey,
  ),
  //secondaryHeaderColor: Colors.grey[800]!,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: primarySwatchColor,
);