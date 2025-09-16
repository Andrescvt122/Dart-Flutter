import 'package:flutter/material.dart';

// widgets/custom_bottom_navigation_bar.dart
class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
        color: Color.fromARGB(255, 238, 238, 238),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 53, 241, 28).withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Inicio', false),
          _buildNavItem(Icons.attach_money, 'Ventas', false),
          _buildNavItem(Icons.shopping_cart_outlined, 'Compras', true),
          _buildNavItem(Icons.assessment, 'Informes', false),
          _buildNavItem(Icons.settings_outlined, 'Ajustes', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          // Color para iconos no seleccionados
          color: isSelected ? Color.fromARGB(255, 33, 39, 34) : Color(0xFF6B9E83),
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            // Color para texto no seleccionado
            color: isSelected ? Color.fromARGB(255, 20, 24, 20) : Color(0xFF6B9E83),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
