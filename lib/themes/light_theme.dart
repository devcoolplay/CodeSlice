import 'package:flutter/material.dart';

import '../shared/constants.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  iconTheme: const IconThemeData(
    color: Colors.black38,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: primarySwatchColor,

);