import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_ride/ui/pages/daily_travel_page.dart';
import 'package:green_ride/ui/widgets/app_logo.dart';
import 'package:intl/intl.dart';
import 'package:green_ride/ui/theme/app_theme.dart';
import 'package:green_ride/ui/widgets/next_button.dart';
import 'package:green_ride/ui/widgets/type_ahead_location_text_field.dart';

class SettingsPage extends StatefulWidget {
  static const String route = '/settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DateTime? selectedDateTime;

  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  List<Weekday> selectedWeekdays = [
    Weekday("M", selected: true),
    Weekday("T", selected: true),
    Weekday("W", selected: true),
    Weekday("T", selected: true),
    Weekday("F", selected: true),
    Weekday("S"),
    Weekday("S"),
  ];

  @override
  void initState() {
//    selectedDateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;

    final Widget textFieldOrigin = buildTextField(
        controller: originController,
        hint: 'Origin',
        icon: Icon(Icons.place, size: 40, color: Colors.grey[400]),
        withShadow: !isPortrait);
    final Widget textFieldDestination = buildTextField(
        controller: destinationController,
        hint: 'Destination',
        icon: Icon(Icons.outlined_flag, size: 40, color: Colors.grey[400]),
        withShadow: true);

    var weekdaySelector = buildWeekdaySelector();
    var timeContainer = buildTimeContainer(CupertinoDatePickerMode.time);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Column(
          children: [
//            Expanded(
//                child: Image.asset(
//                'assets/images/bicycling2.jpg',
//                fit: BoxFit.scaleDown,
//              ),
//            ),
            Expanded(
                child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment(0, 0),
                            image:
                                ExactAssetImage('assets/images/bicycling2.jpg'),
                            fit: BoxFit.cover)))),
//                child: FittedBox(
//      child: Image.asset('assets/images/bicycling2.jpg'),
//      fit: BoxFit.fill,
//    ),
//    Image.asset('assets/images/bicycling2.jpg',
//                    fit: BoxFit.fill)
//    ),
            Expanded(
              child: Container(
                color: AppTheme.appSecondaryColor,
              ),
            )
          ],
        ),
        SafeArea(
            child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(children: [
                        FractionallySizedBox(
                            widthFactor: isPortrait ? 0.3 : 0.16,
                            child: AppLogo()),
                        Spacer(),
                        Row(
                          children: [
                            Spacer(flex: isPortrait ? 1 : 1),
                            Expanded(
                                flex: isPortrait ? 3 : 3,
                                child: AutoSizeText(
                                  isPortrait
                                      ? "Tell us about your\ndaily travel to work"
                                      : "Tell us about your daily travel to work",
                                  style: GoogleFonts.oswald(
                                    color: Colors.white,
                                    fontSize: 100,
                                  ),
                                  maxLines: isPortrait ? 2 : 1,
                                  textAlign: TextAlign.center,
                                )),
                            Spacer(flex: isPortrait ? 1 : 1)
                          ],
                        ),
//                        Align(
//                            alignment: Alignment.centerLeft,
//                            child: AutoSizeText(
//                              "Tell us about your\ndaily travel to work",
//                              style: GoogleFonts.oswald(
//                                color: Colors.white,
//                                fontSize: 100,
//                              ),
//                              maxLines: 2,
//                              textAlign: TextAlign.center,
//                            )
////                            Text(
////                                'Tell us about your\ndaily travel to work',
////                                textAlign: TextAlign.start,
////                                style: TextStyle(
////                                    color: textColor,
////                                    fontSize: 24,
////                                    fontWeight: FontWeight.bold))
//                            ),
                        Spacer(),
                        isPortrait ? textFieldOrigin : Container(),
                      ]),
                    ),
                    isPortrait
                        ? textFieldDestination
                        : Row(
                            children: [
                              Expanded(child: textFieldOrigin),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(child: textFieldDestination)
                            ],
                          ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          isPortrait
                              ? Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Expanded(child: weekdaySelector),
                                      Expanded(child: timeContainer)
                                    ],
                                  ))
                              : Row(
                                  children: [
                                    Expanded(child: weekdaySelector),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(child: timeContainer)
                                  ],
                                ),
                          Spacer(),
                          NextButton(DailyTravelPage.route,
                              arguments: DailyTravelPageArguments(
                                  originController.text.trim(),
                                  destinationController.text.trim(),
                                  selectedWeekdays
                                      .map((w) => w.selected ? 1 : 0)
                                      .toList()
                                      .reduce(
                                          (a, b) => a + b)))
                        ],
                      ),
                    ),
                  ],
                )))
      ]),
    );
  }

  Widget buildTextField(
      {TextEditingController? controller,
      String? hint,
      Icon? icon,
      bool withShadow = false}) {
    // TODO: remove me later
    if (hint == 'Origin' && controller?.text == '' && kDebugMode)
      controller?.text = 'Merowingerstraße 1\n85051 Ingolstadt';
    if (hint == 'Destination' && controller?.text == '' && kDebugMode)
      controller?.text = 'Auto-Union-Straße 1\n85045 Ingolstadt';

    return Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(const Radius.circular(40.0)),
          boxShadow: [
            BoxShadow(
              color: withShadow ? Colors.blueGrey[400]! : Colors.transparent,
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: -5.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal
                5.0, // vertical
              ),
            )
          ],
        ),
        child: Theme(
            data: ThemeData(
              primaryColor: AppTheme.appColor,
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: TypeAheadLocationTextField(controller, hint, icon))));
  }

  Widget buildWeekdaySelector() {
    Icon icon = Icon(Icons.calendar_today, size: 30, color: Colors.grey[400]);

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(const Radius.circular(40.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey[400]!,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: -5.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal
                    5.0, // vertical
                  ),
                )
              ],
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    icon,
                    SizedBox(
                      width: 22,
                    ),
                    Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: selectedWeekdays
                                .asMap()
                                .entries
                                .map((entry) =>
                                    buildWeekday(entry.key, entry.value))
                                .toList())),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ))));
  }

  Widget buildWeekday(int index, Weekday weekday) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
                onTap: () => setState(() => selectedWeekdays[index].selected =
                    !selectedWeekdays[index].selected),
                child: Container(
                  decoration: BoxDecoration(
                      color: selectedWeekdays[index].selected
                          ? AppTheme.appColor
                          : AppTheme.appSecondaryColor,
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(20.0))),
                  height: 30,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: AutoSizeText(
                            weekday.day,
                            style: AppTheme.textStyleAuto,
                          ))),
                ))));
  }

  Widget buildTimeContainer(CupertinoDatePickerMode mode) {
    String? formattedDateTime;
    Icon icon;

    switch (mode) {
      case CupertinoDatePickerMode.time:
        if (selectedDateTime != null) {
          DateFormat formatter = new DateFormat.Hm('de');
          formattedDateTime = formatter.format(selectedDateTime!);
        }
        icon = Icon(Icons.access_time, size: 30, color: Colors.grey[400]);
        break;
      case CupertinoDatePickerMode.date:
        if (selectedDateTime != null) {
          DateFormat formatter = DateFormat.yMMMMd('de');
          formattedDateTime = formatter.format(selectedDateTime!);
        }
        icon = Icon(Icons.calendar_today, size: 30, color: Colors.grey[400]);
        break;
      default:
        icon = Icon(Icons.help_outline, size: 30, color: Colors.grey[400]);
        break;
    }

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: GestureDetector(
            onTap: () => showIOSDateTimePicker(
                mode,
                selectedDateTime,
                (newDateTime) =>
                    setState(() => selectedDateTime = newDateTime)),
            child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(40.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey[400]!,
                      blurRadius:
                          10.0, // has the effect of softening the shadow
                      spreadRadius:
                          -5.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal
                        5.0, // vertical
                      ),
                    )
                  ],
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        icon,
                        SizedBox(
                          width: 22,
                        ),
                        Text(
                          formattedDateTime ?? 'Arrival time',
                          style: formattedDateTime != null
                              ? AppTheme.textStyle
                              : AppTheme.textStyle
                                  .copyWith(color: Colors.grey[400]),
                        ),
                      ],
                    )))));
  }

  Future<dynamic> showIOSDateTimePicker(CupertinoDatePickerMode mode,
      DateTime? dateTime, Function(DateTime? dateTime) setDateTime) {
    FocusNode().requestFocus();
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              message: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: CupertinoDatePicker(
                      mode: mode,
                      initialDateTime: dateTime,
                      minimumDate: DateTime(2020),
                      maximumDate: DateTime(2025),
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDateTime) {
                        dateTime = newDateTime;
                        setDateTime(dateTime);
                      })),
            ));
  }
}

class Weekday {
  final String day;
  bool selected;

  Weekday(this.day, {this.selected = false});
}
