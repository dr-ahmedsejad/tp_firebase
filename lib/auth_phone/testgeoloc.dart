import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String initialIsoCode = ''; // Stockera la valeur initiale de isoCode

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // Fonction pour obtenir la localisation de l'appareil
  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Vous pouvez utiliser la position pour déterminer le pays et ensuite récupérer le code iso du pays
    // Exemple : String countryIsoCode = _getCountryIsoCode(position.countryCode);
    // Dans cet exemple, je vais utiliser une valeur factice "US" pour les besoins de la démonstration.
    String countryIsoCode = "US";

    setState(() {
      initialIsoCode = countryIsoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhoneNumberInput Example'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              print(number.toString());
            },
            initialValue: PhoneNumber(isoCode: initialIsoCode),
            textFieldController: TextEditingController(),
          ),
        ),
      ),
    );
  }
}
