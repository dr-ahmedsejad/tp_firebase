import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Test'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Firebase initialisé avec succès",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
