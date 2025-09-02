import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final String heading;
  final String description;
  final IconData icon;

  const NotificationTile(
      {super.key,
      required this.heading,
      required this.description,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF749A78),
        size: 30,
      ),
      title: Text(
        heading,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 13, color: Color(0xFF686777)),
      ),
    );
  }
}
