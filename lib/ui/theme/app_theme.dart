import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color appColor = Color(0xFF0A8919);
  static const Color appSecondaryColor = Color(0xFFBBFAC2);

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

  static TextStyle textStyleWhite = GoogleFonts.oswald(
    color: Colors.white,
    fontSize: 18,
  );
}