import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:green_ride/ui/theme/app_theme.dart';

class NextButton extends StatelessWidget {
  final String nextPageRoute;
  final Object? arguments;

  NextButton(this.nextPageRoute, {this.arguments});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.white;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: AppTheme.appColor,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
          side: BorderSide(color: AppTheme.appColor)),
    );

    return SizedBox(
        height: 50,
        child: TextButton(
            style: flatButtonStyle,
            onPressed: () => Navigator.of(context)
                .pushNamed(nextPageRoute, arguments: arguments),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    AutoSizeText(
                      'Save',
                      style: AppTheme.textStyleAuto,
                    ),
                    Spacer(),
                    Icon(
                      Icons.save,
                      size: 32,
                      color: textColor,
                    )
                  ],
                ))));
  }
}
