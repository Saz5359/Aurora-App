import 'package:flutter/material.dart';

class AppCheckBox extends StatelessWidget {
  final String text;
  final bool isChecked;
  final Function(bool?)? onChanged;

  const AppCheckBox(
      {super.key, required this.text, required this.isChecked, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: isChecked,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: text,
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
