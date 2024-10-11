import 'package:flutter/material.dart';
import 'view/dashboard_page.dart';

void main() {
  runApp(const SiviApp());
}

class SiviApp extends StatelessWidget {
  const SiviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sivi Intern Assignment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}
