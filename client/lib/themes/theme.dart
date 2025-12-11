// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  //Color get backgroundTop => Color(0xFFFF8C00); // Color(0xFFFFA726); 
  Color get backgroundTop => Color(0xFF91d6d2);  //Color(0xFFB2DFDB);
  Color get backgroundBottom => Color(0xFF419ca5); // Color(0xFF80CBC4);

  //Color get backgroundBottom => Color(0xFFFF5722); // Color(0xFFFF7043);
}

extension CustomTextTheme on TextTheme {
  TextStyle get taskCardTitle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  TextStyle get taskCardBody => const TextStyle(
        color: Colors.white70,
      );


  TextStyle get pageTitle => const TextStyle(
        fontSize: 24,
        color: Color.fromARGB(160, 0, 0, 0),
      );

  TextStyle get appNavBarItem => const TextStyle(
        fontSize: 16,
        color: Colors.white70,
      );

  TextStyle get appTitle => const TextStyle(
        fontSize: 28,
        color: Color.fromARGB(160, 0, 0, 0),
        fontWeight: FontWeight.bold,
      );

  TextStyle get appBarTitle => const TextStyle(
        fontSize: 20,
        color: Color.fromARGB(160, 0, 0, 0),
      );

  TextStyle get formFieldText => const TextStyle(
        fontSize: 16,
        color: Colors.white,
      );
}


class MyAppTheme {
  static const Color primaryColor = Color(0xFF00897B);
  static const Color backgroundTop = Color(0xFFB2DFDB);
  static const Color backgroundBottom = Color(0xFF80CBC4);
  static const Color buttonLabelColor = Colors.black54;

  static final ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
  );

  static InputDecoration glassInputDecoration({String? hintText, String? labelText, Widget? suffixIcon}) => InputDecoration(
    hintText: hintText,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.white),
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.transparent,
    hoverColor: primaryColor.withAlpha(30),
    //focusColor: Colors.white.withOpacity(0.15),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
    suffixIcon: suffixIcon
  );

  static ButtonStyle glassGoBackButtonStyle() => ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    backgroundColor: Colors.white.withOpacity(0.2),
    foregroundColor: Colors.white,
    elevation: 5,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.white.withOpacity(0.4)),
    ),
  );

  static ButtonStyle glassButtonStyle() => ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    backgroundColor:  MyAppTheme.primaryColor.withAlpha(125),
    foregroundColor: Colors.white,
    elevation: 5,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.white.withOpacity(0.4)),
    ),
  );
}