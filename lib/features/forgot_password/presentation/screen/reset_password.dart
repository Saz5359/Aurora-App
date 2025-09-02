import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_text_form_field.dart';
import 'package:aurora_v1/core/widgets/password_requirement_indicator.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  final PageController pageController;

  const ResetPassword({super.key, required this.pageController});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool hasMinLength = false;
  bool hasUpperCase = false;
  bool hasNumberOrSpecial = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      hasNumberOrSpecial =
          password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
          onBack: () => widget.pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
          title: 'Forgot Password'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: constraints.maxHeight < 600
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create Password',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'You will need it to sign in to the application ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      PasswordRequirementIndicator(
                        label: 'Password must be at least 8 characters long.',
                        isValid: hasMinLength,
                        shouldDisplay: false,
                      ),
                      const SizedBox(height: 15),
                      PasswordRequirementIndicator(
                        label: 'Password must contain at least one upper case.',
                        isValid: hasUpperCase,
                        shouldDisplay: false,
                      ),
                      const SizedBox(height: 15),
                      PasswordRequirementIndicator(
                        label:
                            'Password must contain at least one number or special character',
                        isValid: hasNumberOrSpecial,
                        shouldDisplay: false,
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextFormField(
                              label: 'Password',
                              fieldType: FormFieldType.password,
                              controller: _passwordController,
                              onChanged: _checkPasswordStrength,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password.';
                                }
                                if (!hasMinLength ||
                                    !hasUpperCase ||
                                    !hasNumberOrSpecial) {
                                  return 'Password does not meet all requirements.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            AppTextFormField(
                              label: 'Re-type Password',
                              fieldType: FormFieldType.password,
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password.';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      AppButton(
                        label: "Continue",
                        onPressed: () => widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut),
                        type: AppButtonType.confirm,
                      ),
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
