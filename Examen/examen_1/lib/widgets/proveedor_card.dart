import 'package:flutter/material.dart';
import '../models/proveedor_data.dart';
import 'estado_chip.dart';

// widgets/proveedor_card.dart
class ProveedorCard extends StatelessWidget {
  final ProveedorData proveedor;

  const ProveedorCard({Key? key, required this.proveedor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proveedor: ${proveedor.nombre}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Subtotal: \$${proveedor.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 114, 175, 89),
                  ),
                ),
              ],
            ),
          ),
          EstadoChip(estado: proveedor.estado),
        ],
      ),
    );
  }
}