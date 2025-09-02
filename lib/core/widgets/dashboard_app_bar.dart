import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  const DashboardAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: SizedBox(),
      title: title,
      centerTitle: true,
      elevation: 0.1,
      shadowColor: Colors.black,
      toolbarHeight: kToolbarHeight,
      actions: [
        GestureDetector(
            onTap: () => context.push("/notifications"),
            child: Icon(
              Icons.notifications_none,
              color: Colors.grey[400],
            )),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
            onTap: () => context.push("/settings"),
            child: const Icon(Icons.settings)),
        const SizedBox(
          width: 15,
        )
      ],
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
