import 'package:flutter/material.dart';
import 'screens/compras_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stich Design',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: ComprasScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}