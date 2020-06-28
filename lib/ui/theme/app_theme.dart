import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color appColor = Color(0xFF0A8919);
  static const Color appSecondaryColor = Color(0xFFbbfac2);
  static const Color appSecondaryColorLight = Color(0xFFEFF1FE);
  static const Color green = Color(0xFF12B284);

  static TextStyle textStyleAuto = GoogleFonts.oswald(
    color: Colors.white,
    fontSize: 100,
  );

  static TextStyle textStyle = GoogleFonts.oswald(
    color: Colors.black,
    fontSize: 18,
  );

  static TextStyle textStyleSmall = GoogleFonts.oswald(
    color: Colors.black,
    fontSize: 16,
  );
}