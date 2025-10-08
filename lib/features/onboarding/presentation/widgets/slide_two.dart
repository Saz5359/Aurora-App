import 'package:flutter/material.dart';

class SlideTwo extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isSmallScreen;
  final bool isMediumScreen;

  const SlideTwo({
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
        ? 22
        : isMediumScreen
            ? 30
            : 36;

    final double subtitleFontSize = isSmallScreen
        ? 16
        : isMediumScreen
            ? 24
            : 24;

    // Responsive image sizing
    final double imageHeight = isSmallScreen
        ? screenHeight * 0.25
        : isMediumScreen
            ? screenHeight * 0.5
            : screenHeight * 0.5;

    final double imageWidth = isSmallScreen
        ? screenWidth * 0.3
        : isMediumScreen
            ? screenWidth * 0.4
            : screenWidth * 0.4;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 5.0 : 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Get access to real time monitoring',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.3,
              ),
            ),

            SizedBox(height: isSmallScreen ? 20 : 40),

            // Content Row
            isSmallScreen
                ? _buildSmallLayout(subtitleFontSize, imageHeight, imageWidth)
                : _buildRegularLayout(
                    subtitleFontSize, imageHeight, imageWidth),

            // Spacer to ensure consistent height with other slides
            SizedBox(height: isSmallScreen ? 10 : 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularLayout(
      double subtitleFontSize, double imageHeight, double imageWidth) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Live data and plant happiness ratings',
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Image.asset(
            'assets/images/device_right.png',
            fit: BoxFit.contain,
            width: imageWidth,
            height: imageHeight,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallLayout(
      double subtitleFontSize, double imageHeight, double imageWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Live data and plant happiness ratings',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subtitleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Image.asset(
            'assets/images/device_right.png',
            fit: BoxFit.contain,
            width: imageWidth,
            height: imageHeight,
          ),
        ),
      ],
    );
  }
}
