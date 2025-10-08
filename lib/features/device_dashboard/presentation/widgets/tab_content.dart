import 'package:flutter/material.dart';

class TabContent extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String data;

  const TabContent(
      {super.key,
      required this.title,
      required this.description,
      required this.imagePath,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          'Seedling: $title',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Color(0xFF686777)),
        ),
        const SizedBox(height: 10),
        Image.asset(
          imagePath,
          height: 301,
          width: 349,
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            text: data,
            style: const TextStyle(fontSize: 16, color: Color(0xFF686777)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
