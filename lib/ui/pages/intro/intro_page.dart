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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.oswald(fontSize: 24, color: Colors.white);
    List<Widget> _screens = [
      Text(
        "See your ecological footprint and improve it to help us saving our planet!",
        style: textStyle,
      ),
      Text(
        "We will help you to switch from driving to work by car to going by bike!",
        style: textStyle,
      ),
      Text(
        "Start now: Define your travel to work and see how you can save our planet!",
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
