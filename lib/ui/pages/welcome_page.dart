import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:green_ride/ui/pages/intro/intro_page.dart';
import 'package:green_ride/ui/theme/app_theme.dart';
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
    Future.delayed(Duration(milliseconds: 200))
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.black45,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
          side: BorderSide(color: Colors.white, width: 2.0)),
    );

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
                  flex: isPortrait ? 10 : 21,
                  child: FractionallySizedBox(
                      widthFactor: isPortrait ? 0.3 : 0.16, child: AppLogo())),
              Spacer(
                flex: 60,
              ),
              Expanded(
                  flex: isPortrait ? 5 : 10,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(IntroPage.route),
                    style: flatButtonStyle,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: AutoSizeText("Start Intro",
                            style: AppTheme.textStyleAuto
//                    TextStyle(
//                        color: Colors.white,
//                        fontSize: 20,
//                        fontWeight: FontWeight.bold)
                            )),
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
