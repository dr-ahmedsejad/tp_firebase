import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'home.dart';

void main() async {
  // S'assure que le framework Flutter est initialisé
  // avant le lancement de l'application.
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialise Firebase et attend que l'initialisation
    // soit complète avant de poursuivre (Rendre MyApp).
    await Firebase.initializeApp();
    runApp(MaterialApp(home: MyApp()));
  } catch (e) {
    print('Erreur lors de l\'initialisation de Firebase: $e');
  }
}

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
  String tel = "";
  bool otpVisibility = false;
  String? otp;
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationID = "";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // Fonction pour obtenir la localisation de l'appareil
  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        // Récupérez le code ISO du pays à partir des informations de localisation
        String? countryIsoCode = placemarks[0].isoCountryCode;

        setState(() {
          initialIsoCode = countryIsoCode!;
        });
      }
    } catch (e) {
      print('Erreur lors de l\'obtention de la localisation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth par numéro de téléphone',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InternationalPhoneNumberInput(
              inputDecoration: InputDecoration(
                labelText: 'Numéro de téléphone',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onInputChanged: (PhoneNumber number) {
                print("####################");
                print(number.phoneNumber.toString());
                tel = number.phoneNumber.toString();
                print("####################");
              },
              onFieldSubmitted: (value) {},
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                useBottomSheetSafeArea: true,
                trailingSpace: false,
                leadingPadding: 5,
                setSelectorButtonAsPrefixIcon: true,
              ),
              initialValue: PhoneNumber(isoCode: initialIsoCode),
              textFieldController: TextEditingController(),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: otpVisibility,
              child: OtpTextField(
                numberOfFields: 6,
                borderColor: Colors.black,
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  // Callback appelé lorsqu'un chiffre est saisi
                  otp = code;
                  print(code);
                },
                onSubmit: (String verificationCode) {
                  // Callback appelé lorsque le code OTP est entièrement saisi
                  otp = verificationCode;
                  print("Code OTP complet: $verificationCode");
                },
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
                child: Text(otpVisibility ? "Vérifier" : "Se connecter"),
                onPressed: () => otpVisibility ? verifyOTP() : loginWithPhone())
          ],
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: tel,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {

        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp!);

    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {}
      },
    );
  }
}
