import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_text_form_field.dart';
import 'package:aurora_v1/core/widgets/password_requirement_indicator.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register_bloc.dart';

class RegisterPasswordPage extends StatefulWidget {
  final Function()? onBack;

  const RegisterPasswordPage({
    super.key,
    required this.onBack,
  });

  @override
  State<RegisterPasswordPage> createState() => _RegisterPasswordPageState();
}

class _RegisterPasswordPageState extends State<RegisterPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasNumberOrSpecial = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasNumberOrSpecial =
          password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        title: "Create Password",
        onBack: widget.onBack,
      ),
      body: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create Password',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text:
                                'You will need it to sign in to the application ',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 20),
                        PasswordRequirementIndicator(
                          label: 'Password must be at least 8 characters long.',
                          isValid: _hasMinLength,
                          shouldDisplay: true,
                        ),
                        const SizedBox(height: 15),
                        PasswordRequirementIndicator(
                            label:
                                'Password must contain at least one upper case.',
                            isValid: _hasUpperCase,
                            shouldDisplay: true),
                        const SizedBox(height: 15),
                        PasswordRequirementIndicator(
                            label:
                                'Password must contain at least one number or special character.',
                            isValid: _hasNumberOrSpecial,
                            shouldDisplay: true),
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
                                  if (!_hasMinLength ||
                                      !_hasUpperCase ||
                                      !_hasNumberOrSpecial) {
                                    return 'Password does not meet all requirements.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              AppTextFormField(
                                label: 'Re-type Password',
                                fieldType: FormFieldType.password,
                                controller: _confirmController,
                                onChanged: (value) => setState(() {}),
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
                        const SizedBox(height: 20),
                        const Spacer(),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            : AppButton(
                                label: 'Continue',
                                onPressed: (!(_formKey.currentState
                                            ?.validate() ??
                                        false))
                                    ? null
                                    : () {
                                        context.read<RegisterBloc>().add(
                                              SubmitPassword(
                                                _passwordController.text.trim(),
                                              ),
                                            );
                                      },
                                type: AppButtonType.confirm,
                              ),
                      ],
                    ),
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
