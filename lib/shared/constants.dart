
/// Here we have some common constants that are used for different parts of the app

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_devicon/flutter_devicon.dart';

// Language syntax highlighting imports
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/htmlbars.dart';
import 'package:highlight/languages/css.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/ruby.dart';
import 'package:highlight/languages/typescript.dart';
import 'package:highlight/languages/bash.dart';
import 'package:highlight/languages/coffeescript.dart';
import 'package:highlight/languages/php.dart';

const Map<int, Color> _color = {
  50:Color.fromRGBO(12,24,251, .1),
  100:Color.fromRGBO(12,24,251, .2),
  200:Color.fromRGBO(12,24,251, .3),
  300:Color.fromRGBO(12,24,251, .4),
  400:Color.fromRGBO(12,24,251, .5),
  500:Color.fromRGBO(12,24,251, .6),
  600:Color.fromRGBO(12,24,251, .7),
  700:Color.fromRGBO(12,24,251, .8),
  800:Color.fromRGBO(12,24,251, .9),
  900:Color.fromRGBO(12,24,251, 1),
};

const MaterialColor primarySwatchColor = MaterialColor(0xff0c18fb, _color);

const Map<String, IconData> availableLanguageIcons = {
  "python": FlutterDEVICON.python_plain,
  "java": FlutterDEVICON.java_plain,
  "c": FlutterDEVICON.c_plain,
  "c++": FlutterDEVICON.cplusplus_plain,
  "c#": FlutterDEVICON.csharp_plain,
  "javascript": FlutterDEVICON.javascript_plain,
  "html": FlutterDEVICON.html5_plain,
  "css": FlutterDEVICON.css3_plain,
  "flutter": FlutterDEVICON.flutter_plain,
  "rust": FlutterDEVICON.rust_plain,
  "ruby": FlutterDEVICON.ruby_plain,
  "typescript": FlutterDEVICON.typescript_plain,
  "bash": FlutterDEVICON.bash_plain,
  "coffeescript": FlutterDEVICON.coffeescript_original,
  "php": FlutterDEVICON.php_plain,
  "other": FlutterDEVICON.devicon_plain,
};

var availableLanguageHighlighting = {
  "python": python,
  "java": java,
  "c": cpp,
  "c++": cpp,
  "c#": cs,
  "javascript": javascript,
  "html": htmlbars,
  "css": css,
  "dart": dart,
  "rust": rust,
  "ruby": ruby,
  "typescript": typescript,
  "bash": bash,
  "coffeescript": coffeescript,
  "php": php,
  "other": cpp,
};

var settingsTextButtonStyle = TextButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
  alignment: Alignment.centerLeft,
  textStyle: const TextStyle(
    color: Colors.black54,
  ),
);

const settingsContainerDecoration = BoxDecoration(
    border: Border(
        bottom: BorderSide(
            color: Color.fromRGBO(209, 209, 209, 1)
        )
    )
);

const authInputDecoration = InputDecoration(
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red)
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red)
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primarySwatchColor),
  ),
);

const textInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(12.5)),
  ),
  //fillColor: Colors.white,
  filled: true,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.5)),
      borderSide: BorderSide(width: 1.0)
  ),
);

const settingsInputDecoration = InputDecoration(
  disabledBorder: InputBorder.none,
);

const searchInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  icon: Icon(CupertinoIcons.search),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.5)),
      borderSide: BorderSide(color: Colors.grey, width: 1.0)
  ),
);