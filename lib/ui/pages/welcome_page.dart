import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_ride/ui/pages/intro/intro_page.dart';
import 'package:green_ride/ui/widgets/app_logo.dart';
import 'package:intl/date_symbol_data_local.dart';

class WelcomePage extends StatefulWidget {
  static const route = '/welcome';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('de_DE', null);
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;

    return Scaffold(
      body: Stack(
//        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bicycling.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
              child: Column(
            children: [
              Spacer(flex: isPortrait ? 20 : 15),
              Expanded(
                  flex: isPortrait ? 10 : 20,
                  child: FractionallySizedBox(
                      widthFactor:
                          isPortrait ? 0.3 : 0.15,
                      child: AppLogo())),
              Spacer(
                flex: 60,
              ),
              Expanded(
                flex: isPortrait ? 5 : 10,
                  child: FlatButton(
                onPressed: () => Navigator.of(context).pushNamed(IntroPage.route),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    side: BorderSide(color: Colors.white, width: 2.0)),
                color: Colors.black45,
                child: AutoSizeText("Start Intro",
                    style: GoogleFonts.oswald(
//                      textStyle: button,
                      color: Colors.white,
                    )
//                    TextStyle(
//                        color: Colors.white,
//                        fontSize: 20,
//                        fontWeight: FontWeight.bold)
                    ),
              )),
              Spacer(
                flex: 5,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
