import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

class GoogleMapsClient {
  static final String apiKey = "xxx";

  final _places = GoogleMapsPlaces(
      apiKey: apiKey,
      baseUrl: kIsWeb
          ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api'
          : null);
  final _directions = GoogleMapsDirections(
      apiKey: apiKey,
      baseUrl: kIsWeb
          ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api'
          : null);

  Future<List<Prediction>> autocomplete(String input) async {
    var response = await _places.autocomplete(input,
        language: 'en',
        region: 'DE',
        components: [Component(Component.country, 'de')]);
    return response.predictions;
  }

  Future<DirectionsResponse> directionsWithAddress(
      String origin, String destination,
      {List<google_maps_flutter.LatLng> waypoints,
      TravelMode travelMode = TravelMode.driving}) async {
    var response = await _directions.directionsWithAddress(
      origin,
      destination,
      waypoints: waypoints
          ?.map((e) => Waypoint.fromLocation(Location(e.latitude, e.longitude)))
          ?.toList(),
      travelMode: travelMode,
      alternatives: false,
      language: 'en',
      region: 'DE',
    );

    return response;
  }
}
