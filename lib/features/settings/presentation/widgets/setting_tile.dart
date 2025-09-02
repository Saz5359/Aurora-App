import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final Function()? onTap;
  final String label;
  final IconData icon;

  const SettingTile({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 25,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              // Ensures text fits properly within available space
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                overflow:
                    TextOverflow.ellipsis, // Adds "..." if text is too long
                maxLines: 1, // Ensures a single line of text
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
