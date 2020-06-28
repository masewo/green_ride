import 'package:flutter/material.dart';
import 'package:green_ride/ui/theme/app_theme.dart';

class NextButton extends StatelessWidget {

  final String nextPageRoute;

  NextButton(this.nextPageRoute);

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;

    return SizedBox(
        height: 50,
        child: FlatButton(
            color: AppTheme.appColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
                side:
                BorderSide(color: AppTheme.appColor)),
            onPressed: () =>
                Navigator.of(context).pushNamed(nextPageRoute),
            child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                          color: textColor, fontSize: 18),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      size: 32,
                      color: textColor,
                    )
                  ],
                ))));
  }
}
