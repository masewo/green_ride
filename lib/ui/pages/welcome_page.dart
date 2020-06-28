import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_ride/ui/pages/intro/intro_page.dart';

class WelcomePage extends StatefulWidget {
  static const route = '/welcome';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

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
              Spacer(flex: orientation == Orientation.portrait ? 20 : 15),
              Expanded(
                  flex: orientation == Orientation.portrait ? 10 : 20,
                  child: FractionallySizedBox(
                      widthFactor:
                          orientation == Orientation.portrait ? 0.3 : 0.15,
                      child: Column(
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
                      ))),
              Spacer(
                flex: 60,
              ),
              Expanded(
                flex: orientation == Orientation.portrait ? 5 : 10,
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
