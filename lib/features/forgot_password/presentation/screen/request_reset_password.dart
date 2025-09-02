import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/phone_text_field.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';

class RequestResetPassword extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final void Function()? navigateBack;
  final PageController pageController;

  RequestResetPassword(
      {super.key, required this.pageController, this.navigateBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(onBack: navigateBack, title: 'Forgot Password'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: constraints.maxHeight < 600
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text:
                                'Provide your account’s mobile phone number for which you want to reset your password',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF686777)),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      PhoneTextField(phoneController: phoneController),
                      const SizedBox(height: 20),
                      const Spacer(),
                      const Text(
                        'You will receive an SMS code for verification. ',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF686777)),
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                          label: "Request reset password link",
                          onPressed: () => pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut),
                          type: AppButtonType.confirm),
                      const SizedBox(height: 10),
                      AppButton(
                          label: "Cancel",
                          onPressed: navigateBack,
                          type: AppButtonType.cancel),
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
