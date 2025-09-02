import 'package:flutter/material.dart';

enum AppErrorType { network, invalidInput, unknown }

void showAppErrorSnackBar(
  BuildContext context, {
  required String message,
  required AppErrorType errorType,
}) {
  Color background = Colors.red.shade600;

  switch (errorType) {
    case AppErrorType.network:
      background = Colors.orange.shade700;
      break;
    case AppErrorType.invalidInput:
      background = Colors.red.shade600;
      break;
    case AppErrorType.unknown:
      background = Colors.grey.shade800;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: background,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      duration: const Duration(seconds: 3),
    ),
  );
}
