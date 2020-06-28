import 'package:flutter/material.dart';
import 'package:green_ride/ui/pages/intro/intro_page.dart';
import 'package:green_ride/ui/pages/settings_page.dart';
import 'package:green_ride/ui/pages/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: onGenerateRoute,
      debugShowCheckedModeBanner: false,
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case IntroPage.route:
        return MaterialPageRoute(
            builder: (BuildContext context) => IntroPage());
      case SettingsPage.route:
        return MaterialPageRoute(
            builder: (BuildContext context) => SettingsPage());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => WelcomePage());
    }
  }
}