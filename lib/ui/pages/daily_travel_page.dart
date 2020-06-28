import 'dart:async';

//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:green_ride/google_maps/google_maps_helper.dart';
import 'package:green_ride/google_maps/google_maps_service.dart';
import 'package:green_ride/ui/theme/app_theme.dart';
import 'package:green_ride/ui/theme/map_style.dart';
import 'package:green_ride/ui/widgets/custom_container.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:green_ride/weather/weather_service.dart';
import 'package:lottie/lottie.dart' hide Marker;

import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:weather_icons/weather_icons.dart';

class DailyTravelPage extends StatefulWidget {
  static const String route = '/dailytravel';

  final DailyTravelPageArguments arguments;

  DailyTravelPage({Key key, this.arguments}) : super(key: key);

  @override
  _DailyTravelPageState createState() => _DailyTravelPageState();
}

class _DailyTravelPageState extends State<DailyTravelPage>
    with SingleTickerProviderStateMixin {
  static const mapsBlue = Color(0xFF4185F3);

  static var textStyle = AppTheme.textStyleSmall;

  SheetController sheetController;
  AnimationController _animationController;

  bool get isExpanded => state?.isExpanded ?? false;

  bool get isCollapsed => state?.isCollapsed ?? true;

  double get progress => state?.progress ?? 0.0;

  DailyTravelPageArguments get arguments => widget.arguments;

  bool tapped = false;
  bool show = false;

  ValueNotifier<SheetState> sheetState = ValueNotifier(SheetState.inital());

  SheetState get state => sheetState.value;

  set state(SheetState value) => sheetState.value = value;

  Completer<GoogleMapController> _mapController = Completer();

  static final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(51.163361, 10.447694),
    zoom: 5.0,
  );

  final Set<Polyline> polylines = {};
  final Set<Marker> markers = {};
  BitmapDescriptor marker;

  Direction directionDriving;
  Direction directionBicycling;

  WeatherInfo weather;

  Completer<BitmapDescriptor> markerAssetImageCompleter = Completer();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);

    sheetController = SheetController();
    Future.delayed(const Duration(milliseconds: 0), () {
      sheetController.snapToExtent(0.6);
    });

    List<Future> directionFutures = [
      GetIt.I<GoogleMapsService>()
          .directionsWithAddress(arguments.origin, arguments.destination),
      GetIt.I<GoogleMapsService>().directionsWithAddress(
          arguments.origin, arguments.destination,
          travelMode: directions.TravelMode.bicycling)
    ];

    Future.wait(directionFutures).then((value) {
      directionDriving = value[0];
      directionBicycling = value[1];

      markerAssetImageCompleter.future.then((value) {
        marker = value;

        markers.add(Marker(
            markerId: MarkerId('1'),
            position: directionBicycling.originLatLng,
            icon: marker,
            anchor: Offset(0.5, 0.5)));

        markers.add(Marker(
            markerId: MarkerId('2'),
            position: directionBicycling.destinationLatLng,
            icon: marker,
            anchor: Offset(0.5, 0.5)));
      });

      GetIt.I<WeatherService>()
          .getWeather(directionBicycling.originLatLng.latitude,
              directionBicycling.originLatLng.longitude)
          .then((value) => setState(() => weather = value));

      LatLngBounds bounds = LatLngBounds(
          southwest: directionBicycling.originLatLng,
          northeast: directionBicycling.destinationLatLng);

      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
      this._mapController.future.then((mapController) =>
          mapController.moveCamera(cameraUpdate).then((void v) {
            check(cameraUpdate, mapController).then((value) {
              mapController.getVisibleRegion().then((value) {
                mapController.moveCamera(CameraUpdate.newLatLngBounds(value, 100));
              });
            });

//                Future.delayed(Duration(seconds: 0)).then((value) =>
//                    mapController.moveCamera(CameraUpdate.zoomOut()).then((value) => mapController.moveCamera(mapController.getLatLng(screenCoordinate))))));
          }));

      setState(() {
        polylines.add(directionDriving.polyline);
        polylines.add(directionBicycling.polyline);
      });
    });
  }

  Future check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    _mapController.future.then((mapController) => mapController.moveCamera(u));
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      await check(u, c);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
//          GestureDetector(
//            onTap: () => setState(() => tapped = !tapped),
//            child: AnimatedContainer(
//              duration: const Duration(seconds: 1),
//              height: tapped ? 200 : 0,
//              color: Colors.red,
//            ),
//          ),
          Expanded(
            child: buildSheet(),
          ),
        ],
      ),
    );
  }

  Widget buildSheet() {
    return SlidingSheet(
      duration: const Duration(milliseconds: 900),
      controller: sheetController,
      shadowColor: Colors.black26,
      elevation: 12,
      maxWidth: 500,
      cornerRadius: 16,
      cornerRadiusOnFullscreen: 0.0,
      closeOnBackdropTap: true,
      closeOnBackButtonPressed: true,
      addTopViewPaddingOnFullscreen: true,
      isBackdropInteractable: true,
//      border: Border.all(
//        color: Colors.grey.shade300,
//        width: 3,
//      ),
      snapSpec: SnapSpec(
        snap: true,
        positioning: SnapPositioning.relativeToAvailableSpace,
        snappings: const [
          SnapSpec.headerFooterSnap,
          0.6,
          SnapSpec.expanded,
        ],
        onSnap: (state, snap) {
          print('Snapped to $snap');
        },
      ),
      parallaxSpec: const ParallaxSpec(
        enabled: false,
        amount: 0.35,
        endExtent: 0.6,
      ),
      listener: (state) {
        final needsRebuild = (this.state?.isCollapsed != state.isCollapsed) ||
            (this.state.isExpanded != state.isExpanded) ||
            (this.state.isAtTop != state.isAtTop) ||
            (this.state.isAtBottom != state.isAtBottom);
        this.state = state;

        if (needsRebuild) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => (() => setState(() {})));
//          _mapController.future.then((value) =>
//              value.animateCamera(CameraUpdate.));
        }
      },
      body: _buildBody(),
      headerBuilder: buildHeader,
      footerBuilder: buildFooter,
      builder: buildChild,
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
    return GestureDetector(
        onTap: () {
          if (this.state.extent == this.state.minExtent) {
            sheetController.snapToExtent(SnapSpec.expanded);
          } else {
            sheetController.snapToExtent(SnapSpec.headerFooterSnap);
          }
        },
        child: CustomContainer(
          animate: true,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: !state.isAtTop ? 4 : 0,
          shadowColor: Colors.black12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.topCenter,
                child: ValueListenableBuilder(
                  valueListenable: sheetState,
                  builder: (context, state, _) {
                    return CustomContainer(
                      width: 16,
                      height: 4,
                      borderRadius: 2,
                      color: Colors.grey.withOpacity(
                          .5 * (1 - interval(0.7, 1.0, state.progress))),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text(
                    directionBicycling?.duration ?? '0h 0m',
                    style: textStyle.copyWith(
                      color: const Color(0xFF008042),
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(' + (directionBicycling?.distance ?? '0 km') + ')',
                    style: textStyle.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Driving by car would take you ' +
                    (directionDriving?.duration ?? '0h 0m') +
                    ' (' +
                    (directionDriving?.distance ?? '0 km') +
                    ').',
                style: textStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ));
  }

  Widget buildFooter(BuildContext context, SheetState state) {
    Widget button(Widget icon, Text text, VoidCallback onTap,
        {BorderSide border, Color color}) {
      final child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          const SizedBox(width: 8),
          text,
        ],
      );

      const shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      );

      return border == null
          ? RaisedButton(
              color: color,
              onPressed: onTap,
              elevation: 2,
              shape: shape,
              child: child,
            )
          : OutlineButton(
              color: color,
              onPressed: onTap,
              borderSide: border,
              shape: shape,
              child: child,
            );
    }

    return CustomContainer(
      animate: true,
      elevation: !isCollapsed && !state.isAtBottom ? 4 : 0,
      shadowDirection: ShadowDirection.top,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      shadowColor: Colors.black12,
      child: Row(
        children: <Widget>[
          button(
            Icon(
              Icons.navigation,
              color: Colors.white,
              size: 24,
            ),
            Text(
              'Start',
              style: textStyle.copyWith(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            () async {
              GoogleMapsHelper.startNavigation(
                  origin: directionBicycling.originLatLng,
                  destination: directionBicycling.destinationLatLng);
//                  waypoints: [LatLng(spot.latitude, spot.longitude)])
              // Inherit from context...
//              await SheetController.of(context).hide();
//              Future.delayed(const Duration(milliseconds: 1500), () {
//                // or use the controller
//                sheetController.show();
//              });
            },
            color: mapsBlue,
          ),
          const SizedBox(width: 8),
          button(
            !isExpanded
                ? Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Icon(
                      WeatherIcons.thermometer_exterior,
                      size: 20,
//              !isExpanded ? Icons.list : Icons.map,
                      color: mapsBlue,
                    ))
                : Icon(Icons.map, color: mapsBlue),
            Text(
              !isExpanded ? 'Show weather' : 'Show map',
              style: textStyle.copyWith(
                fontSize: 15,
              ),
            ),
            !isExpanded
                ? () => sheetController
                    .scrollTo(state.maxScrollExtent)
                    .then((value) => setState(() {}))
                : () =>
                    sheetController.collapse().then((value) => setState(() {})),
            color: Colors.white,
            border: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChild(BuildContext context, SheetState state) {
    final divider = Container(
      height: 1,
      color: Colors.grey.shade300,
    );

    final titleStyle = textStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    const padding = EdgeInsets.symmetric(horizontal: 16);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        divider,
        const SizedBox(height: 16),
        Row(
          children: [
            Lottie.asset('assets/animations/tree.json',
                controller: _animationController, onLoaded: (composition) {
              _animationController.duration = composition.duration;
              _animationController.repeat();
            }, height: 200),
            Expanded(
                child: RichText(
              text: TextSpan(
                text: 'You will save the amount of CO\u2082 that ',
                style: textStyle.copyWith(
                  fontSize: 16,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: getAmountOfTrees(),
                      style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' trees would have to absorb!'),
                ],
              ),
            )),
            SizedBox(
              width: 12,
            )
          ],
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => setState(() => show = !show),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Traffic',
                  style: titleStyle,
                ),
                const SizedBox(height: 16),
                buildChart(context),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        divider,
        const SizedBox(height: 32),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: padding,
              child: Text(
                'Steps',
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 8),
            buildSteps(context),
          ],
        ),
        const SizedBox(height: 32),
        divider,
//        const SizedBox(height: 32),
//        Icon(
//          Icons.map,
//          color: Colors.grey.shade900,
//          size: 48,
//        ),
//        const SizedBox(height: 16),
//        Align(
//          alignment: Alignment.center,
//          child: Text(
//            'Pull request are welcome!',
//            style: textStyle.copyWith(
//              color: Colors.grey.shade700,
//            ),
//            textAlign: TextAlign.center,
//          ),
//        ),
//        const SizedBox(height: 8),
//        Align(
//          alignment: Alignment.center,
//          child: Text(
//            '(Stars too)',
//            style: textStyle.copyWith(
//              fontSize: 12,
//              color: Colors.grey,
//            ),
//          ),
//        ),
        const SizedBox(height: 32),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: padding,
              child: Text(
                'Weather',
                style: titleStyle,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                weather != null
                    ? BoxedIcon(
                  WeatherIcons.fromString(weather.weatherIcon,
                      // Fallback is optional, throws if not found, and not supplied.
                      fallback: WeatherIcons.na),
                  size: 40,
                )
                    : BoxedIcon(WeatherIcons.na),
                Text((weather?.temperature?.toStringAsFixed(1) ?? "---") + " °C",
                    style: AppTheme.textStyle)
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildSteps(BuildContext context) {
    final steps = [
      Step('Go to your bike.', '30 seconds'),
      Step("Sit on your bike.",
          '10 seconds'),
      Step("Start pedaling.", '5 seconds'),
      Step("Happy bicycling!", 'Forever'),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, i) {
        final step = steps[i];

        return Padding(
          padding: const EdgeInsets.fromLTRB(56, 16, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                step.instruction,
                style: textStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Text(
                    '${step.time}',
                    style: textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget buildChart(BuildContext context) {
    final series = [
      charts.Series<Traffic, String>(
        id: 'traffic',
        data: [
          Traffic(0.5, '14:00'),
          Traffic(0.6, '14:30'),
          Traffic(0.5, '15:00'),
          Traffic(0.7, '15:30'),
          Traffic(0.8, '16:00'),
          Traffic(0.6, '16:30'),
        ],
        colorFn: (traffic, __) {
          if (traffic.time == '14:30')
            return charts.Color.fromHex(code: '#F0BA64');
          return charts.MaterialPalette.gray.shade300;
        },
        domainFn: (Traffic traffic, _) => traffic.time,
        measureFn: (Traffic traffic, _) => traffic.intesity,
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: show ? 256 : 128,
      color: Colors.transparent,
      child: charts.BarChart(
        series,
        animate: true,
        domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: charts.MaterialPalette.gray.shade500,
            ),
          ),
        ),
        defaultRenderer: charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(5),
        ),
      ),
    );
  }

  Future<void> showBottomSheetDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final controller = SheetController();
    bool isDismissable = false;

    await showSlidingBottomSheet(
      context,
      // The parentBuilder can be used to wrap the sheet inside a parent.
      // This can be for example a Theme or an AnnotatedRegion.
      parentBuilder: (context, sheet) {
        return Theme(
          data: ThemeData.dark(),
          child: sheet,
        );
      },
      // The builder to build the dialog. Calling rebuilder on the dialogController
      // will call the builder, allowing react to state changes while the sheet is shown.
      builder: (context) {
        return SlidingSheetDialog(
          controller: controller,
          duration: const Duration(milliseconds: 500),
          snapSpec: const SnapSpec(
            snap: true,
            initialSnap: 0.7,
            snappings: [
              0.3,
              0.7,
            ],
          ),
          scrollSpec: const ScrollSpec(
            showScrollbar: true,
          ),
          color: Colors.teal,
          maxWidth: 500,
          minHeight: 700,
          isDismissable: isDismissable,
          dismissOnBackdropTap: true,
          isBackdropInteractable: true,
          onDismissPrevented: (backButton, backDrop) async {
            HapticFeedback.heavyImpact();

            if (backButton || backDrop) {
              const duration = Duration(milliseconds: 300);
              await controller.snapToExtent(0.2,
                  duration: duration, clamp: false);
              await controller.snapToExtent(0.4, duration: duration);
              // or Navigator.pop(context);
            }

            // Or pop the route
            // if (backButton) {
            //   Navigator.pop(context);
            // }

            print('Dismiss prevented');
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Confirm purchase',
                    style: textTheme.headline4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sagittis tellus lacus, et pulvinar orci eleifend in.',
                          style: textTheme.subtitle1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Icon(
                        isDismissable ? Icons.check : Icons.error,
                        color: Colors.white,
                        size: 56,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          footerBuilder: (context, state) {
            return Container(
              color: Colors.teal.shade700,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: textTheme.subtitle1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FlatButton(
                    onPressed: () {
                      if (!isDismissable) {
                        isDismissable = true;
                        SheetController.of(context).rebuild();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Approve',
                      style: textTheme.subtitle1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        buildMap(),
//        Align(
//          alignment: Alignment.topRight,
//          child: Padding(
//            padding: EdgeInsets.fromLTRB(
//                0, MediaQuery.of(context).padding.top + 16, 16, 0),
//            child: FloatingActionButton(
//              backgroundColor: Colors.white,
//              onPressed: () async {
//                await showBottomSheetDialog(context);
//              },
//              child: Icon(
//                Icons.layers,
//                color: mapsBlue,
//              ),
//            ),
//          ),
//        ),
      ],
    );
  }

  Widget buildMap() {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return FutureBuilder(
        future: BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: devicePixelRatio),
            'assets/images/marker.png'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (!markerAssetImageCompleter.isCompleted) {
              markerAssetImageCompleter.complete(snapshot.data);
            }
//            markers.add(Marker(
//                markerId: MarkerId(spot.name),
//                position: LatLng(spot.latitude, spot.longitude),
//                icon: BitmapDescriptor.defaultMarkerWithHue(HSLColor.fromColor(spot.getCategoryColor()).hue)));
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              polylines: polylines,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                controller.setMapStyle(MapStyle.style);
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            );
          }
          return Container();
        });
//    return GestureDetector(
//      onTap: () => setState(() => tapped = !tapped),
//      child: Column(
//        children: <Widget>[
//          Expanded(
//            child: Image.asset(
//              'assets/images/maps_screenshot.png',
//              width: double.infinity,
//              height: double.infinity,
//              alignment: Alignment.center,
//              fit: BoxFit.cover,
//            ),
//          ),
//          const SizedBox(height: 56),
//        ],
//      ),
//    );
  }

  double interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  String getAmountOfTrees() {
    // doppelte distanz hin und zurück
    // 365 tage
    // meter -> kilometer
    // 0,2 kg CO2 pro kilometer
    // 30 kg CO2 pro jahr pro baum
    var trees = (directionDriving?.distanceMeter ?? 0) * 2 * (365 / 7 * arguments.daysOfWeek) / 1000 * 0.2 / 30;
        return trees.toInt().toString();
  }
}

class DailyTravelPageArguments {
  final String origin;
  final String destination;
  final int daysOfWeek;

  DailyTravelPageArguments(this.origin, this.destination, this.daysOfWeek);
}

class Step {
  final String instruction;
  final String time;

  Step(
    this.instruction,
    this.time,
  );
}

class Traffic {
  final double intesity;
  final String time;

  Traffic(
    this.intesity,
    this.time,
  );
}
