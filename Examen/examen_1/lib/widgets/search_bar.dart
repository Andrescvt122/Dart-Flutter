import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color:  Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar por proveedor, fecha o estado...',
          hintStyle: TextStyle(
            color: Color(0xFF52946B),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF8E8E8E),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}