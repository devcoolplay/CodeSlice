import 'package:flutter/material.dart';

import '../shared/constants.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black54,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black54,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: primarySwatchColor,
);