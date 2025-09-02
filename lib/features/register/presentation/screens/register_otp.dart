import 'dart:async';
import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register_bloc.dart';

class RegisterOtpPage extends StatefulWidget {
  final Function()? onBack;

  const RegisterOtpPage({super.key, required this.onBack});

  @override
  State<RegisterOtpPage> createState() => _RegisterOtpPageState();
}

class _RegisterOtpPageState extends State<RegisterOtpPage> {
  final List<String> _otpValues = List.filled(4, '');
  Timer? _countdownTimer;
  int _remainingTime = 300;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _otpError = 'OTP has expired, please request a new code.';
        });
      }
    });
  }

  void _resetTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _remainingTime = 300;
      _otpError = null;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  bool get _allFieldsFilled => _otpValues.every((val) => val.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(title: "Verify OTP", onBack: widget.onBack),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter the 4-digit code',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        final form = (state is RegisterStepSuccess)
                            ? state.form
                            : const RegisterForm();
                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Enter the code sent to ${form.phoneNumber ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // OTP Input Fields (4 boxes)
                    SizedBox(
                      height: 69,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: SizedBox(
                              width: 50,
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.isNotEmpty && value.length == 1) {
                                    _otpValues[index] = value;
                                    if (index < 3) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  } else if (value.isEmpty && index > 0) {
                                    _otpValues[index] = '';
                                    FocusScope.of(context).previousFocus();
                                  }
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Inline OTP Error (if expired or incorrect)
                    if (_otpError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _otpError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),

                    // Countdown Timer
                    Row(
                      children: [
                        Text(
                          'Code Expires:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatTime(_remainingTime),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF686777),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Resend & Change Number links
                    GestureDetector(
                      onTap: _resetTimer,
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF749A78),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: widget.onBack,
                      child: const Text(
                        'Change Mobile Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF749A78),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Spacer(),

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
                            label: "Continue",
                            onPressed: (_allFieldsFilled) ? _onSubmit : null,
                            type: AppButtonType.confirm);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    // Clear any previous inline error
    setState(() {
      _otpError = null;
    });

    final enteredOtp = _otpValues.join();
    final bloc = context.read<RegisterBloc>();

    final currentState = bloc.state;

    bloc.add(SubmitOtp(
      phoneNumber: currentState is RegisterStepSuccess
          ? currentState.form.phoneNumber ?? ''
          : '',
      userOtp: enteredOtp,
    ));
  }
}
