import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          "GreenRide",
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontSize: 100,
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        AutoSizeText(
          "SAVE THE PLANET",
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontSize: 100,
          ),
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        )
      ],
    );
  }
}
