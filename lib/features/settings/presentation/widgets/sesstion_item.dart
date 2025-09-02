import 'package:flutter/material.dart';

class SessionItem extends StatelessWidget {
  final IconData icon; // Icon representing the device
  final String title; // Device name and location
  final VoidCallback
      onDeactivate; // Callback for the "Deactivate session" action

  const SessionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis),
            ),

            const SizedBox(height: 5),
            GestureDetector(
              onTap: onDeactivate,
              child: const Text(
                'Deactivate session',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 15), // Spacing between items
          ],
        ),
      ],
    );
  }
}
