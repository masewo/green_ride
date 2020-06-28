import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:green_ride/ui/theme/app_theme.dart';

class GoogleMapsClient {
  static final String apiKey = "xxx";

  final _places = GoogleMapsPlaces(apiKey: apiKey);
  final _directions = GoogleMapsDirections(apiKey: apiKey);

  Future<List<Prediction>> autocomplete(String input) async {
    var response = await _places.autocomplete(input,
        language: 'de',
        region: 'DE',
        components: [Component(Component.country, 'de')]);
    return response.predictions;
  }

  Future<google_maps_flutter.Polyline> directionsWithAddress(String origin,
      String destination, [List<google_maps_flutter.LatLng> waypoints]) async {
    var response = await _directions.directionsWithAddress(
      origin,
      destination,
      waypoints: waypoints
          ?.map((e) => Waypoint.fromLocation(Location(e.latitude, e.longitude)))
          ?.toList(),
      travelMode: TravelMode.driving,
      alternatives: false,
      language: 'de',
      region: 'DE',
    );

    var polyline = response.routes.first.overviewPolyline;
    var decodedPolyline = decodePolyline(polyline.points);
    return google_maps_flutter.Polyline(
        polylineId: google_maps_flutter.PolylineId(polyline.points),
        points: decodedPolyline
            .map((e) => google_maps_flutter.LatLng(e[0], e[1]))
            .toList(),
        visible: true,
        color: AppTheme.appSecondaryColor);
  }
}
