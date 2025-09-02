import 'dart:math';
import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/device_setup/presentation/widgets/device_gif.dart';
import 'package:flutter/material.dart';

class AddDevicePairingMode extends StatefulWidget {
  final void Function()? onCancel;
  final PageController pageController;

  const AddDevicePairingMode(
      {super.key, required this.pageController, this.onCancel});

  @override
  State<AddDevicePairingMode> createState() => _AddDevicePairingModeState();
}

class _AddDevicePairingModeState extends State<AddDevicePairingMode> {
  bool isLoading = false;
  bool isFailed = false;

  // ignore: unused_element
  void _onButtonPressed() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a delay (like a network request)
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        isFailed =
            Random().nextBool(); // Randomly decide if it fails or succeeds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(onBack: widget.onCancel, title: "Add Device"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "Turn on device",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isFailed)
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Don't have a Device",
                            style: TextStyle(
                                color: Color(0xFF749A78),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      const SizedBox(height: 10),
                      const DeviceGif(),
                      const SizedBox(height: 20),
                      RichText(
                        text: const TextSpan(
                          text:
                              "The device indicator light will turn from rainbow to white showing it is ready to be connected",
                          style:
                              TextStyle(color: Color(0xFF686777), fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            'Alternatively',
                            style: TextStyle(
                                color: Color(0xFF686777), fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Manually add device',
                              style: TextStyle(
                                  color: Color(0xFF749A78),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Spacer(), // Adjusts to push content to the bottom
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF8FB599)),
                            strokeWidth: 2.0,
                          ),
                        )
                      else
                        AppButton(
                            label: isFailed ? 'Try Again' : 'Device Is on',
                            onPressed: () => widget.pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                            type: AppButtonType.confirm),
                      const SizedBox(height: 15),
                      AppButton(
                          label: "Cancel",
                          onPressed: widget.onCancel,
                          type: AppButtonType.cancel),
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

//////////////////////////////// Original Code /////////////////////////////////////////
/* import 'dart:math';

import 'package:aurora_demo_app/core/widgets/custom_app_bar.dart';
import 'package:aurora_demo_app/core/widgets/custom_button.dart';
import 'package:aurora_demo_app/features/add_device/presentation/widgets/device_gif.dart';
import 'package:flutter/material.dart';

class AddDevicePairingMode extends StatefulWidget {
  final void Function()? onCancel;
  final PageController pageController;

  const AddDevicePairingMode(
      {super.key, required this.pageController, this.onCancel});

  @override
  State<AddDevicePairingMode> createState() => _AddDevicePairingModeState();
}

class _AddDevicePairingModeState extends State<AddDevicePairingMode> {
  bool isLoading = false;
  bool isFailed = false;

  // ignore: unused_element
  void _onButtonPressed() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a delay (like a network request)
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        isFailed =
            Random().nextBool(); // Randomly decide if it fails or succeeds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(navigateBack: widget.onCancel, title: "Add Device"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "Turn on device pairing mode",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isFailed)
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Don't have a Device",
                            style: TextStyle(
                                color: Color(0xFF749A78),
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      const SizedBox(height: 10),
                      const DeviceGif(),
                      const SizedBox(height: 20),
                      RichText(
                        text: const TextSpan(
                          text:
                              "The device indicator light will turn from rainbow to white showing it is ready to be connected",
                          style:
                              TextStyle(color: Color(0xFF686777), fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            'Alternatively',
                            style: TextStyle(
                                color: Color(0xFF686777), fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Manually add device',
                              style: TextStyle(
                                  color: Color(0xFF749A78),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Spacer(), // Adjusts to push content to the bottom
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF8FB599)),
                            strokeWidth: 2.0,
                          ),
                        )
                      else
                        CustomButton(
                            label: isFailed ? 'Try Again' : 'Add Device',
                            onPressed: () => widget.pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                            type: ButtonType.confirm),
                      const SizedBox(height: 15),
                      CustomButton(
                          label: "Cancel",
                          onPressed: widget.onCancel,
                          type: ButtonType.cancel),
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
} */
