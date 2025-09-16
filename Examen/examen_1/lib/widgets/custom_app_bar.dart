import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Compras',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: Container(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}