import 'package:flutter/material.dart';

class StepAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function()? onBack;

  const StepAppBar({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onBack,
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Color(0xFFAFCEB2),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF04021D),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 65,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          color: Colors.grey,
          height: 0.5,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
