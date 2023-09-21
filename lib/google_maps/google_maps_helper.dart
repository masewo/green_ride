import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GoogleMapsHelper {
  static Future<bool> startNavigation(
      {required LatLng origin,
      required LatLng destination,
      List<LatLng>? waypoints}) {
    return launchUrlString('https://www.google.com/maps/dir/?api=1'
        '&origin='
        '${origin.latitude},${origin.longitude}'
        '&destination='
        '${destination.latitude},${destination.longitude}'
        '${waypoints != null && waypoints.isNotEmpty ? '&waypoints='
            '${waypoints.map((e) => '${e.latitude},${e.longitude}').toList().join('%7C')}'
            '&travelmode=bicycling&dir_action=navigate' : ''}', mode: LaunchMode.externalApplication);
  }
}
