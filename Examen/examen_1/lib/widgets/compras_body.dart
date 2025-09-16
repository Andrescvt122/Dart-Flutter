import 'package:flutter/material.dart';
import '../models/proveedor_data.dart';
import 'search_bar.dart';
import 'registrar_button.dart';
import 'proveedor_card.dart';

class ComprasBody extends StatelessWidget {
  final List<ProveedorData> proveedores = [
    ProveedorData(
      nombre: 'Tech Supplies Inc.',
      subtotal: 1200.00,
      estado: EstadoCompra.completada,
    ),
    ProveedorData(
      nombre: 'Office Essentials Co.',
      subtotal: 850.00,
      estado: EstadoCompra.anulada,
    ),
    ProveedorData(
      nombre: 'Software Solutions Ltd.',
      subtotal: 550.00,
      estado: EstadoCompra.completada,
    ),
    ProveedorData(
      nombre: 'Hardware Hub',
      subtotal: 300.00,
      estado: EstadoCompra.completada,
    ),
    ProveedorData(
      nombre: 'Creative Designs Studio',
      subtotal: 1500.00,
      estado: EstadoCompra.anulada,
    ),
    ProveedorData(
      nombre: 'Creative Designs Movies',
      subtotal: 1500.00,
      estado: EstadoCompra.anulada,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          child: CustomSearchBar(), // Cambiar aquí
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: RegistrarButton(),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              return ProveedorCard(proveedor: proveedores[index]);
            },
          ),
        ),
      ],
    );
  }
}