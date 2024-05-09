import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('IntlPhoneNumberInput with Adjusted Padding'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.toString());
              },

              inputDecoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                hintText: 'Entrez votre numéro de téléphone',
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0), // Ajustez ces valeurs selon vos besoins
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                useBottomSheetSafeArea: true,
                trailingSpace: false,
                leadingPadding: 5,
                // showFlags: true,
                setSelectorButtonAsPrefixIcon: true
              ),
              initialValue: PhoneNumber(isoCode: 'US'),
              textFieldController: TextEditingController(),
            ),
          ),
        ),
      ),
    );
  }
}
