import 'package:flutter/material.dart';

class SlideOne extends StatelessWidget {
  const SlideOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monitor your grows',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        AspectRatio(
          aspectRatio: 1.1,
          child: Image.asset(
            'assets/images/device_left.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
