import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:green_ride/google_maps/google_maps_client.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:green_ride/ui/theme/app_theme.dart';

class GoogleMapsService {
  Map<Route, Direction> cachedDirections = {};

  GoogleMapsService.I();

  Future<Direction> directionsWithAddress(String origin, String destination,
      {List<LatLng> waypoints,
      directions.TravelMode travelMode = directions.TravelMode.driving}) async {
    var route = Route(origin, destination, waypoints, travelMode);
    if (cachedDirections.containsKey(route)) {
      return cachedDirections[route];
    } else {
      directions.DirectionsResponse response = await GoogleMapsClient()
          .directionsWithAddress(origin, destination,
              waypoints: waypoints, travelMode: travelMode);

      var polyline = calculatePolyline(response, travelMode);

      var duration = response.routes.first.legs.first.duration.text;
      var distance = response.routes.first.legs.first.distance.text;
      var distanceMeter = response.routes.first.legs.first.distance.value;

      var startLocation = response.routes.first.legs.first.startLocation;
      var startLatLng = LatLng(startLocation.lat, startLocation.lng);
      var endLocation = response.routes.first.legs.first.endLocation;
      var endLatLng = LatLng(endLocation.lat, endLocation.lng);

      var direction = Direction(
          polyline: polyline,
          duration: duration,
          distance: distance,
          distanceMeter: distanceMeter,
          originLatLng: startLatLng,
          destinationLatLng: endLatLng);

      cachedDirections[route] = direction;
      return direction;
    }
  }

  Polyline calculatePolyline(directions.DirectionsResponse response, directions.TravelMode travelMode) {
    var polyline = response.routes.first.overviewPolyline;
    var decodedPolyline = decodePolyline(polyline.points);
    return Polyline(
        polylineId: PolylineId(polyline.points),
        points: decodedPolyline.map((e) => LatLng(e[0], e[1])).toList(),
        visible: true,
        color: travelMode == directions.TravelMode.bicycling ? AppTheme.appColor : Colors.grey.shade400);
  }
}

class Route {
  final String origin;
  final String destination;
  final List<LatLng> waypoints;
  final directions.TravelMode travelMode;

  Route(this.origin, this.destination, this.waypoints, this.travelMode);

  @override
  bool operator ==(Object o) {
    return o is Route &&
        o.origin == origin &&
        o.destination == destination &&
        listEquals(o.waypoints, waypoints) &&
        o.travelMode == travelMode;
  }

  @override
  int get hashCode =>
      origin.hashCode ^
      destination.hashCode ^
      waypoints.hashCode ^
      travelMode.hashCode;
}

class Direction {
  final Polyline polyline;
  final String duration;
  final String distance;
  final num distanceMeter;
  final LatLng originLatLng;
  final LatLng destinationLatLng;

  Direction({
    this.polyline,
    this.duration,
    this.distance,
    this.distanceMeter,
    this.originLatLng,
    this.destinationLatLng,
  });
}
