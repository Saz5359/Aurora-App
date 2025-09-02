import 'package:aurora_v1/features/forgot_password/presentation/screen/password_updated.dart';
import 'package:aurora_v1/features/forgot_password/presentation/screen/request_reset_password.dart';
import 'package:aurora_v1/features/forgot_password/presentation/screen/reset_code.dart';
import 'package:aurora_v1/features/forgot_password/presentation/screen/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onCancel() => context.pop();

    final PageController pageController = PageController();

    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        RequestResetPassword(
            pageController: pageController, navigateBack: onCancel),
        ResetCode(
          pageController: pageController,
          onCancel: onCancel,
        ),
        ResetPassword(pageController: pageController),
        PasswordUpdated(pageController: pageController)
      ],
    );
  }
}
