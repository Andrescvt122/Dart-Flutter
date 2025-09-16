import 'package:flutter/material.dart';
import 'package:examen_1/widgets/custom_app_bar.dart';
import 'package:examen_1/widgets/custom_bottom_navigation_bar.dart';
import 'package:examen_1/widgets/compras_body.dart';
class ComprasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(),
      body: ComprasBody(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}