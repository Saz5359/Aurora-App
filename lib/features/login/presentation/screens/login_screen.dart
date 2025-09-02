import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/validators.dart';
import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_text_form_field.dart';
import 'package:aurora_v1/core/widgets/phone_text_field.dart';
import 'package:aurora_v1/features/login/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void updateValidationState(String value) {
    setState(() {
      /* final isPhoneValid = validatePhoneNumber(
            _phoneController.text,
          ) ==
          null; */
      final isPasswordValid =
          validatePassword(_passwordController.text) == null;
      _isValid = isPasswordValid;
      _formKey.currentState!.validate(); // Revalidate to show/hide errors
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final horizontalPadding = isLargeScreen ? 40.0 : 20.0;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to dashboard on success
            context.go('/dashboard');
          } else if (state is AuthFailure) {
            showAppErrorSnackBar(context,
                message: state.message, errorType: state.errorType);
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 70, horizontalPadding, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 137,
                              width: 328,
                            ),
                          ),
                          const SizedBox(height: 45),

                          // Title
                          Text(
                            'Let’s sign you in.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form fields
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                PhoneTextField(
                                  phoneController: _phoneController,
                                  onChanged: (phone) {
                                    _phoneController.text =
                                        phone.completeNumber;
                                    // Validate phone number
                                  },
                                ),
                                const SizedBox(height: 10),
                                AppTextFormField(
                                  label: 'Password',
                                  fieldType: FormFieldType.password,
                                  controller: _passwordController,
                                  validator: validatePassword,
                                  onChanged: updateValidationState,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () => context.push('/Forgot_password'),
                            child: Text(
                              'Forgot your password?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Or sign in using
                          Center(
                            child: Text(
                              'or Sign in using',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Social buttons or loader
                          _buildSocialButtons(),

                          const SizedBox(height: 25),

                          // Register link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Don’t have an account?',
                                style: TextStyle(
                                  color: Color(0xFF04021D),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => context.push('/register'),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF749A78),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Sign In button
                          if (state is AuthLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            AppButton(
                              label: 'Sign In',
                              onPressed: _isValid
                                  ? () {
                                      context.read<AuthBloc>().add(
                                            EmailLoginRequested(
                                              phoneNumber:
                                                  _phoneController.text,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                    }
                                  : null,
                              type: AppButtonType.confirm,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            context.read<AuthBloc>().add(GoogleLoginRequested());
          },
          child: Image.asset(
            'assets/images/Google.png',
            height: 48,
            width: 48,
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            /* context.read<AuthBloc>().add(FacebookLoginRequested()); */
            Fluttertoast.showToast(
              msg: "Facebook sign-in is not implemented yet.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          },
          child: Image.asset(
            'assets/images/Facebook.png',
            height: 48,
            width: 48,
          ),
        ),
      ],
    );
  }
}
