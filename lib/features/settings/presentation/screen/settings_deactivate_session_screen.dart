import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsDeactivateSessionScreen extends StatelessWidget {
  const SettingsDeactivateSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Text(
                  'Session has been deactivated',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              AppButton(
                  label: "Return",
                  onPressed: () => context.pop(),
                  type: AppButtonType.confirm)
            ],
          ),
        ),
      ),
    );
  }
}
