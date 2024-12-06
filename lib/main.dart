import 'package:flutter/material.dart';
import 'package:remotor/presenter/screens/mouse_screen.dart';
import 'presenter/screens/scanner_screen.dart';
import 'presenter/screens/home_screen.dart';

void main() {
  runApp(RemoteMouseApp());
}

class RemoteMouseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remote Mouse',
      initialRoute: '/', // Vue par défaut au lancement
      routes: {
        '/': (context) => HomeScreen(), // Vue d'accueil
        '/scanner': (context) => ScannerScreen(), // Vue du scanner
        '/mouse': (context) => MouseScreen(), // Vue de la souris
      },
    );
  }
}
