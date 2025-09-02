import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/features/register/presentation/screens/register_legal.dart';
import 'package:aurora_v1/features/register/presentation/screens/register_number.dart';
import 'package:aurora_v1/features/register/presentation/screens/register_otp.dart';
import 'package:aurora_v1/features/register/presentation/screens/register_password.dart';
import 'package:aurora_v1/features/register/presentation/screens/register_personal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  void onBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If we’re not on the first page, go back one page instead of popping entire screen
        if (_pageController.page != null && _pageController.page! > 0.0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return false;
        }
        return true; // Actually pop if on first screen
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterStepSuccess) {
                // Automatically move to the next page when a step succeeds:
                final currentPage = _pageController.page?.toInt() ?? 0;
                if (currentPage < 4) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              } else if (state is GoogleCredentialReceived) {
                context.go("/register/legal", extra: {
                  'onBack': onBack,
                  'signUpMethod': SignUpMethod.google,
                  'credential': state.credential,
                });
              } else if (state is RegisterFailure) {
                showAppErrorSnackBar(
                  context,
                  errorType: state.errorType,
                  message: state.message,
                );
              }
            },
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                RegisterNumberPage(),
                RegisterOtpPage(
                  onBack: onBack,
                ),
                RegisterPasswordPage(
                  onBack: onBack,
                ),
                RegisterPersonalPage(
                  onBack: onBack,
                ),
                RegisterLegalPage(
                  onBack: onBack,
                  signUpMethod: SignUpMethod.phone,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
