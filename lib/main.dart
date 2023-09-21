import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:green_ride/google_maps/google_maps_service.dart' hide Route;
import 'package:green_ride/ui/pages/daily_travel_page.dart';
import 'package:green_ride/ui/pages/intro/intro_page.dart';
import 'package:green_ride/ui/pages/settings_page.dart';
import 'package:green_ride/ui/pages/welcome_page.dart';
import 'package:green_ride/weather/weather_service.dart';

void main() {
  GetIt.I.registerLazySingleton<GoogleMapsService>(() => GoogleMapsService.I());
  GetIt.I.registerLazySingleton<WeatherService>(() => WeatherService.I());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenRide',
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
      case DailyTravelPage.route:
        return MaterialPageRoute(
            builder: (BuildContext context) => DailyTravelPage(
                  arguments: settings.arguments as DailyTravelPageArguments,
                ));
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => WelcomePage());
    }
  }
}
