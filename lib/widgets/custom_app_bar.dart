import 'package:flutter/material.dart';
import '../routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.about),
          tooltip: 'Sobre o App',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}