import 'package:flutter/material.dart';
import '../models/proveedor_data.dart';
// widgets/estado_chip.dart
class EstadoChip extends StatelessWidget {
  final EstadoCompra estado;

  const EstadoChip({Key? key, required this.estado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (estado) {
      case EstadoCompra.completada:
        backgroundColor = Color(0xFFE8F5E8);
        textColor = Color.fromARGB(255, 25, 26, 25);
        text = 'Completada';
        break;
      case EstadoCompra.anulada:
        backgroundColor = Color(0xFFFFEBEE);
        textColor = Color(0xFFD32F2F);
        text = 'Anulada';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}