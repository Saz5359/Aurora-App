import 'package:aurora_v1/features/onboarding/presentation/widgets/slide_one.dart';
import 'package:aurora_v1/features/onboarding/presentation/widgets/slide_two.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5EFD8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;

            // Responsive breakpoints
            final bool isSmall =
                width < 375; // iPhone SE and similar small devices
            final bool isMedium = width >= 375 && width < 600;
            final bool isLarge = width >= 600;

            // Responsive sizing
            final double logoHeight = isSmall
                ? 60
                : isMedium
                    ? 60
                    : 100;

            final double carouselHeight = isSmall
                ? height * 0.55
                : isMedium
                    ? height * 0.70
                    : height * 0.65;

            final double horizontalPadding = 15.0;
            final double verticalPadding = isSmall ? 10.0 : 20.0;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: height,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      // Logo Section
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/onboard1.png',
                              width: isSmall ? width * 0.8 : 337,
                              height: logoHeight,
                              fit: BoxFit.contain,
                            ),
                            Image.asset(
                              'assets/images/onboard2.png',
                              width: isSmall ? width * 0.8 : 337,
                              height: logoHeight,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Carousel Section
                      SizedBox(
                        height: carouselHeight,
                        child: CarouselSlider(
                          items: [
                            SlideOne(
                              screenWidth: width,
                              screenHeight: height,
                              isSmallScreen: isSmall,
                              isMediumScreen: isMedium,
                            ),
                            SlideTwo(
                              screenWidth: width,
                              screenHeight: height,
                              isSmallScreen: isSmall,
                              isMediumScreen: isMedium,
                            ),
                          ],
                          options: CarouselOptions(
                            height: carouselHeight,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() => _currentIndex = index);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [0, 1].asMap().entries.map((entry) {
                          return Container(
                            width: isSmall ? 12 : 16,
                            height: isSmall ? 12 : 16,
                            margin: EdgeInsets.symmetric(
                                horizontal: isSmall ? 3 : 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (entry.key == _currentIndex)
                                  ? const Color(0xFF686777)
                                  : const Color(0xFFD9D9D9),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Get Started Button
                      SizedBox(
                        height: isSmall ? 50 : 58,
                        child: ElevatedButton(
                          onPressed: () => context.go("/login"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isSmall ? 14 : 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isSmall ? 10 : 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
