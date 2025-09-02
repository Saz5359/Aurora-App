import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PlantContainer extends StatelessWidget {
  final double value;
  final void Function()? details;

  const PlantContainer({super.key, required this.value, this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 183,
      decoration: BoxDecoration(
          color: const Color(0xFFF8F8FA),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 200, 199, 199),
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 1.5),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 10,
            percent: value,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text(
              value.isZero ? '--%' : '${(value * 100).toInt()}%',
              style: const TextStyle(
                  color: Colors.lightGreen, fontSize: 32, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plant Happiness',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  RichText(
                    text: const TextSpan(
                        text:
                            'We need more data from your plant to calculate its happiness score.',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF686777))),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      GestureDetector(
                        onTap: details,
                        child: const Text(
                          "More Details",
                          style: TextStyle(
                              color: Color(0xFF749A78),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//'Your plant happiness score is quite low! Ensure your plants are kept in ideal environmental conditions'
