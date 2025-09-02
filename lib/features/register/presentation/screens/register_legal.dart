import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/app_check_box.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/register_bloc.dart';

enum SignUpMethod { phone, google, facebook }

class RegisterLegalPage extends StatefulWidget {
  final Function()? onBack;
  final SignUpMethod signUpMethod;
  final OAuthCredential? credential;

  const RegisterLegalPage({
    super.key,
    required this.onBack,
    required this.signUpMethod,
    this.credential,
  });

  @override
  State<RegisterLegalPage> createState() => _RegisterLegalPageState();
}

class _RegisterLegalPageState extends State<RegisterLegalPage> {
  bool _termsChecked = false;
  bool _privacyChecked = false;
  bool _ageChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(title: "Legal Agreement", onBack: widget.onBack),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            // All five steps done; navigate to Dashboard or Home:
            context.go("/dashboard");
          }
        },
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: constraints.maxHeight < 600
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Legal Stuff',
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
                                    'Before you continue please confirm the following',
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Terms and conditions & POPI Act',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppCheckBox(
                          text: "I accept the terms and conditions",
                          isChecked: _termsChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _termsChecked = value ?? false;
                            });
                          },
                        ),
                        AppCheckBox(
                          text:
                              "I accept that my information can be used in accordance with the POPI Act",
                          isChecked: _privacyChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _privacyChecked = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Age Verification',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text:
                                'You must be over 18 to use this application. Please confirm your age.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        AppCheckBox(
                          text: "I confirm I’m over 18",
                          isChecked: _ageChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _ageChecked = value ?? false;
                            });
                          },
                        ),
                        const Spacer(),

                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            : AppButton(
                                label: 'Finish Registration',
                                onPressed: (_termsChecked &&
                                        _privacyChecked &&
                                        _ageChecked)
                                    ? () {
                                        final bloc =
                                            context.read<RegisterBloc>();

                                        if (widget.signUpMethod ==
                                            SignUpMethod.google) {
                                          bloc.add(
                                              GoogleRegisterWithCredentials(
                                            credential: widget.credential!,
                                          ));
                                        } else if (widget.signUpMethod ==
                                            SignUpMethod.facebook) {
                                          bloc.add(
                                              FacebookRegisterWithCredentials(
                                            credential: widget.credential!,
                                          ));
                                        } else {
                                          bloc.add(SubmitLegalInfo(true));
                                          bloc.add(CompleteRegistration());
                                        }
                                      }
                                    : null,
                                type: AppButtonType.confirm,
                                /* isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : null, */
                              ),
                        const SizedBox(height: 10),

                        // “Cancel” button
                        AppButton(
                          label: "Cancel",
                          onPressed: () {
                            context.go("/register");
                          },
                          type: AppButtonType.cancel,
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
