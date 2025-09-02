import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class WeeklyMetricCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color borderColor;
  final List<List<double>> weeklyData; // Each week has 7 values for each day

  const WeeklyMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.borderColor,
    required this.weeklyData,
  });

  @override
  State<WeeklyMetricCard> createState() => _WeeklyMetricCardState();
}

class _WeeklyMetricCardState extends State<WeeklyMetricCard> {
  int _currentWeek = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _currentWeek > 0
                  ? () {
                      setState(() {
                        _currentWeek--;
                      });
                    }
                  : null,
            ),
            Text(
              "Week ${_currentWeek + 1}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _currentWeek < widget.weeklyData.length - 1
                  ? () {
                      setState(() {
                        _currentWeek++;
                      });
                    }
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 5),

        // Bar Chart Representation
        CarouselSlider(
          options: CarouselOptions(
            height: 100,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
          ),
          items: widget.weeklyData.map((weekData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                return Column(
                  children: [
                    Text(
                      [
                        "S",
                        "M",
                        "T",
                        "W",
                        "T",
                        "F",
                        "S"
                      ][index], // Days of the week
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 10,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: weekData[index] / 100,
                          child: Container(
                            decoration: BoxDecoration(
                                color: _getBarColor(weekData[index]),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Function to get bar color based on value
  Color _getBarColor(double value) {
    if (value < 30) return Colors.blue;
    if (value < 60) return Colors.green;
    if (value < 80) return Colors.orange;
    return Colors.red;
  }
}
