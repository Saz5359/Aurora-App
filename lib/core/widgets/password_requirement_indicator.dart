import 'package:flutter/material.dart';

class PasswordRequirementIndicator extends StatelessWidget {
  final bool isValid;
  final bool shouldDisplay;
  final String label;

  const PasswordRequirementIndicator({
    super.key,
    required this.isValid,
    required this.label,
    required this.shouldDisplay,
  });

  @override
  Widget build(BuildContext context) {
    if (!shouldDisplay) return const SizedBox();

    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.warning_amber_rounded,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.red,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
