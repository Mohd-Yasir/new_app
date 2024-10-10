import 'package:flutter/material.dart';
import 'view/dashboard_page.dart';

void main() {
  runApp(SiviApp());
}

class SiviApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sivi Tutor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
