import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:green_ride/google_maps/google_maps_client.dart';
import 'package:green_ride/ui/theme/app_theme.dart';

class TypeAheadLocationTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Icon icon;

  TypeAheadLocationTextField(this.controller, this.hint, this.icon);

  @override
  _TypeAheadLocationTextFieldState createState() =>
      _TypeAheadLocationTextFieldState();
}

class _TypeAheadLocationTextFieldState
    extends State<TypeAheadLocationTextField> {
  TextEditingController get controller => widget.controller;

  String get hint => widget.hint;

  Icon get icon => widget.icon;

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<Prediction>(
      textFieldConfiguration: TextFieldConfiguration<Prediction>(
          keyboardAppearance: Theme.of(context).brightness,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(40.0),
                ),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(40.0),
                ),
                borderSide:
                    const BorderSide(color: AppTheme.appColor, width: 1.0),
              ),
              filled: true,
              focusColor: Colors.green,
              hintText: hint,
              fillColor: Colors.white,
              prefixIcon: Container(width: 80, child: icon),
              contentPadding: EdgeInsets.all(12)),
          textAlign: TextAlign.left,
          controller: controller,
          minLines: 2,
          maxLines: 2,
          keyboardType: TextInputType.multiline,
          style: AppTheme.textStyle),//TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      suggestionsCallback: (String pattern) async {
        return GoogleMapsClient().autocomplete(pattern);
      },
      itemBuilder: (BuildContext context, Prediction prediction) {
        return Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Text(
                  '${prediction.structuredFormatting.mainText}'
                  '${prediction.structuredFormatting.secondaryText != null ? ', ${prediction.structuredFormatting.secondaryText}' : ''}',
                  style: AppTheme.textStyleSmall,
                )),
              ],
            ));
      },
      keepSuggestionsOnLoading: false,
      loadingBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
              height: 30,
              child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator())),
        );
      },
      noItemsFoundBuilder: (context) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
                height: 30,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Keine Ergebnisse gefunden',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).disabledColor, fontSize: 18.0),
                  ),
                )));
      },
      getImmediateSuggestions: false,
      suggestionsBoxVerticalOffset: 1,
      debounceDuration: Duration(seconds: 1),
      onSuggestionSelected: (Prediction prediction) {
        controller.text =
            '${prediction.structuredFormatting.mainText}\n${prediction.structuredFormatting.secondaryText}';
      },
    );
  }
}
