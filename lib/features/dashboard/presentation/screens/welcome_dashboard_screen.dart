import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeDashboardScreen extends StatelessWidget {
  const WelcomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(title: const SizedBox()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text: 'Let’s begin by starting your first grow.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/welcome_dash.png',
                    height: 122,
                    width: 140,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Let’s start your first grow!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color(0xFFD5EFD8),
                      ),
                      fixedSize: WidgetStateProperty.all(const Size(150, 48)),
                    ),
                    onPressed: () => context.push('/add_grow'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 14, color: Color(0xFF686777)),
                        SizedBox(width: 5),
                        Text(
                          'Add Grow',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF686777)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
