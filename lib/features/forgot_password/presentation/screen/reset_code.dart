import 'dart:async';
import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetCode extends StatefulWidget {
  final PageController pageController;
  final void Function()? onCancel;

  const ResetCode({super.key, required this.pageController, this.onCancel});

  @override
  State<ResetCode> createState() => _ResetCodeState();
}

class _ResetCodeState extends State<ResetCode> {
  final TextEditingController otpController = TextEditingController();
  List<String> otpValues = List.filled(4, '');

  static const int countdownDurationInSeconds = 300;
  late int remainingTime;
  Timer? countdownTimer;
  String? otpError; // To display OTP error directly under the fields

  @override
  void initState() {
    super.initState();
    remainingTime = countdownDurationInSeconds;
    startTimer();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          otpError = 'OTP has expired, please resend code.';
        });
      }
    });
  }

  void resetTimer() {
    countdownTimer?.cancel();
    setState(() {
      remainingTime = countdownDurationInSeconds;
      otpError = null; // Clear any previous errors
    });
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  bool allFieldsFilled() {
    return otpValues.every((value) => value.isNotEmpty);
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight, // Fill available screen height
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Text
                      const Text(
                        'Enter the Code',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  'Enter the four-digit code that was sent to you at ',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700])),
                          const TextSpan(
                              text: /* widget.phoneNumber */ 'Number',
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 16,
                                  color: Color(0xFF749A78),
                                  fontWeight: FontWeight.w700))
                        ]),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 69,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  height: 56,
                                  width: 50,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      if (value.isNotEmpty &&
                                          value.length == 1) {
                                        otpValues[index] = value;
                                        if (index < 3) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      } else if (value.isEmpty && index > 0) {
                                        otpValues[index] = '';
                                        FocusScope.of(context).previousFocus();
                                      }
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      Text(
                        otpError ?? '',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Code Expires:',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            formatTime(remainingTime),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF686777),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: resetTimer,
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF749A78)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Change Mobile Number',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF749A78)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Spacer(), // Pushes the button to the bottom if space is available

                      AppButton(
                          label: "Reset Password",
                          onPressed: () => widget.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut),
                          type: AppButtonType.confirm),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                          label: "Cancel",
                          onPressed: widget.onCancel,
                          type: AppButtonType.cancel)
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
