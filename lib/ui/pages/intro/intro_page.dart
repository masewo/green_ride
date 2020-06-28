import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_ride/ui/pages/intro/background.dart';
import 'package:green_ride/ui/pages/intro/nav_container.dart';

class IntroPage extends StatefulWidget {
  static const String route = '/intro';

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.oswald(fontSize: 24, color: Colors.white);
    List<Widget> _screens = [
      Text(
        "Starting Intro!",
        style: textStyle,
      ),
      Text(
        "This app is awesome! Believe me!",
        style: textStyle,
      ),
      Text(
        "Finished Intro!",
        style: textStyle,
      )
    ];

    return Scaffold(
        body:
            Stack(alignment: AlignmentDirectional.topStart, children: <Widget>[
      Background(assetName: 'assets/images/bicycling.jpg'),
      NavContainer(children: _screens)
    ]));
  }
}
