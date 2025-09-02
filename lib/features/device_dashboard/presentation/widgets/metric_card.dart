import 'package:aurora_v1/features/device_dashboard/presentation/widgets/weekly_metric_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatefulWidget {
  final String title;
  final String status;
  final String value;
  final Widget icon;
  final String? description;
  final Color borderColor;
  final Color backgroundColor;
  final bool isHighlighted;

  const MetricCard({
    super.key,
    required this.title,
    required this.status,
    required this.value,
    required this.icon,
    this.description,
    required this.borderColor,
    required this.backgroundColor,
    this.isHighlighted = false,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  bool _isExpanded = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _slides = [
      //Slide 1
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 5.0),
          Text(
            widget.status,
            style: TextStyle(
              fontSize: 16.0,
              color: widget.borderColor,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2, // Adjust this for relative space allocation
                child: Text(
                  widget.description ?? "",
                  style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ),
              Expanded(
                flex: 1, // Adjust this for relative space allocation
                child: Image.asset(
                  "assets/images/humidity.png",
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),

      //Slide 2
      ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          WeeklyMetricCard(
            title: "Humidity",
            value: "56%",
            icon: Icons.water_drop,
            borderColor: Colors.blue,
            weeklyData: [
              [10, 50, 60, 80, 30, 20, 40], // Week 1 data
              [20, 40, 70, 60, 50, 30, 10], // Week 2 data
            ],
          ),
        ],
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: widget.borderColor, width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Adjust opacity for depth
            blurRadius: 3.0, // Higher value = softer shadow
            spreadRadius: 1.0, // Controls shadow size
            offset: const Offset(0, 6), // Moves shadow downwards
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row for Header (Title, Status, Value, Expand Icon)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      widget.status,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: widget.borderColor == Colors.white
                            ? Color(0xFF686777)
                            : widget.borderColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 20,
                  color: widget.borderColor == Colors.white
                      ? Color(0xFF686777)
                      : widget.borderColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: Colors.black54,
                  size: 32.0,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),

          // Expandable Content - Carousel with Text
          if (_isExpanded && widget.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  CarouselSlider(
                    items: _slides,
                    options: CarouselOptions(
                      height: 160,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() => _currentIndex = index);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _slides.asMap().entries.map((entry) {
                      return Container(
                        width: 11,
                        height: 11,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (entry.key == _currentIndex)
                              ? const Color(0xFF686777)
                              : const Color(0xFFD9D9D9),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
