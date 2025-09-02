import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordUpdated extends StatelessWidget {
  final PageController pageController;

  const PasswordUpdated({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
          onBack: () => pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
          title: 'Forgot Password'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Password Updated',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Your Password has been updated',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Spacer(),
                      AppButton(
                          label: "Login",
                          onPressed: () => context.go("/login"),
                          type: AppButtonType.confirm)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
