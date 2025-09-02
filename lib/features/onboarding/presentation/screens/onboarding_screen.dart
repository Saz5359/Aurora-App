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
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<Widget> slides = [
      const SlideOne(),
      SlideTwo(screenHeight: screenHeight),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFD5EFD8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          'assets/images/onboard1.png',
                          width: 337,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/onboard2.png',
                          width: 337,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CarouselSlider(
                        items: slides,
                        options: CarouselOptions(
                          height: screenHeight * 0.6,
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

                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: slides.asMap().entries.map((entry) {
                          return Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
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
                      SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () => context.go("/login"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
