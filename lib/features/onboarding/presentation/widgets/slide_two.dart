import 'package:flutter/material.dart';

class SlideTwo extends StatelessWidget {
  final double screenHeight;

  const SlideTwo({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get access to real time monitoring',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Live data and plant happiness ratings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Image.asset(
                'assets/images/device_right.png',
                fit: BoxFit.contain,
                width: screenHeight * 0.18,
                height: screenHeight * 0.35,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
