import 'package:flutter/material.dart';

class SlideOne extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isSmallScreen;
  final bool isMediumScreen;

  const SlideOne({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.isSmallScreen,
    required this.isMediumScreen,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive font sizes
    final double titleFontSize = isSmallScreen
        ? 28
        : isMediumScreen
            ? 40
            : 48;

    // Responsive image sizing
    final double imageHeight = isSmallScreen
        ? screenHeight * 0.4
        : isMediumScreen
            ? screenHeight * 0.5
            : screenHeight * 0.7;

    final double imageWidth = isSmallScreen
        ? screenWidth * 0.8
        : isMediumScreen
            ? screenWidth * 0.9
            : screenWidth * 0.9;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8.0 : 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Monitor your grows',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.2,
              ),
            ),

            // Image
            Center(
              child: Image.asset(
                'assets/images/device_left.png',
                fit: BoxFit.contain,
                width: imageWidth,
                height: imageHeight,
              ),
            ),

            // Spacer to ensure consistent height with other slides
            //SizedBox(height: isSmallScreen ? 10 : 20),
          ],
        ),
      ),
    );
  }
}
