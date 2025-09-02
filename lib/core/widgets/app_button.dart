import 'package:flutter/material.dart';

enum AppButtonType { delete, cancel, confirm }

class AppButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = switch (type) {
      AppButtonType.delete => const Color(0xFFEF6363),
      _ => const Color(0xFF0F3035),
    };

    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case AppButtonType.delete:
        return ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF8F8FA),
            padding: const EdgeInsets.all(5),
            elevation: 0,
            minimumSize: const Size(double.infinity, 56),
            side: const BorderSide(width: 1, color: Colors.black),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)));
      case AppButtonType.cancel:
        return ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF8F8FA),
          padding: const EdgeInsets.all(5),
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(width: 1, color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      case AppButtonType.confirm:
        return ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD5EFD8),
            padding: const EdgeInsets.all(5),
            elevation: 0,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)));
    }
  }
}
