import 'package:flutter/material.dart';

// widgets/registrar_button.dart
class RegistrarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Acción del botón
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(56, 224, 122, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        'Registrar Nueva Compra',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}