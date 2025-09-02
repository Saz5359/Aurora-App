//import 'dart:math';

import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/phone_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../bloc/register_bloc.dart';

class RegisterNumberPage extends StatefulWidget {
  const RegisterNumberPage({super.key});

  @override
  State<RegisterNumberPage> createState() => _RegisterNumberPageState();
}

class _RegisterNumberPageState extends State<RegisterNumberPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  //late String _generatedOtp;
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    //_generatedOtp = _generateOtp();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /* String _generateOtp() {
    return (Random().nextInt(9000) + 1000).toString();
  } */

  void _validatePhoneNumber(String phone) {
    setState(() {
      _isPhoneValid = RegExp(r'^\+?\d{10,15}$').hasMatch(phone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          //final isSmall = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: size.height * 0.18,
                        width: size.width * 1,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Header Text
                    Text(
                      'Let’s sign you up.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Phone Field
                    Form(
                      key: _formKey,
                      child: PhoneTextField(
                        phoneController: _phoneController,
                        onChanged: (phone) {
                          _phoneController.text = phone.completeNumber;
                          _validatePhoneNumber(phone.completeNumber);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          );
                        }

                        return AppButton(
                          label: "Sign Up",
                          onPressed: _isPhoneValid
                              ? () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    context.read<RegisterBloc>().add(
                                          SubmitPhoneNumber(
                                            phoneNumber:
                                                _phoneController.text.trim(),
                                            //generatedOtp: _generatedOtp,
                                          ),
                                        );
                                  }
                                }
                              : null,
                          type: AppButtonType.confirm,
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Social Sign-Up Text
                    Center(
                      child: Text(
                        'or Sign up using',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Social Sign-In Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => context
                              .read<RegisterBloc>()
                              .add(GoogleSignUpRequested()),
                          child: Image.asset(
                            "assets/images/Google.png",
                            height: 48,
                            width: 48,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            /* context
                                    .read<RegisterBloc>()
                                    .add(FacebookSignUpRequested()); */

                            Fluttertoast.showToast(
                              msg: "Facebook sign-in is not implemented yet.",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                            );
                          },
                          child: Image.asset(
                            "assets/images/Facebook.png",
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Terms Text
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'You may receive an SMS for security and login purposes. By proceeding, you agree to our ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: 'terms and services.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Footer Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Already have an account?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text("|",
                            style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.secondary)),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            'Login',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
