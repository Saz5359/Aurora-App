import 'package:flutter/material.dart';

class WiFiTile extends StatelessWidget {
  final String name;
  final bool connected;
  final VoidCallback? onTap;

  const WiFiTile({
    super.key,
    required this.name,
    required this.connected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.wifi, color: Colors.grey),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (connected)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                'Connected',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF749A78),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(
            width: 3,
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }
}
