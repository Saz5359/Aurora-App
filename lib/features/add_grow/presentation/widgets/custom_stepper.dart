import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CustomStepper(
      {super.key, required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        // Generating circles and lines alternatively
        if (index % 2 == 0) {
          // Generating a circle
          int circleIndex = index ~/ 2;
          return Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleIndex == currentStep
                  ? Colors.green // The active step
                  : Colors.grey.shade400, // The inactive step
              boxShadow: circleIndex == currentStep
                  ? [
                      const BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 4,
                        blurRadius: 3,
                      ),
                    ]
                  : [],
            ),
          );
        } else {
          // Generating a connecting line between circles
          return Expanded(
            child: Container(
              height: 8,
              color: Colors.grey.shade400,
            ),
          );
        }
      }),
    );
  }
}
