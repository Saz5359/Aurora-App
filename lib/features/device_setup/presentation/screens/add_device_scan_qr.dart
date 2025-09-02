import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/device_setup/presentation/widgets/device_gif.dart';
import 'package:flutter/material.dart';

class AddDeviceScanQr extends StatelessWidget {
  final PageController pageController;

  const AddDeviceScanQr({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
          onBack: () => pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
          title: "Add Device"),
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
                          "Scan the QR code of the device",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Don\'t have a Device',
                          style: TextStyle(
                            color: Color(0xFF749A78),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const DeviceGif(),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: const TextSpan(
                          text:
                              "The QR code will be automatically detected when you position it between the guide lines",
                          style:
                              TextStyle(color: Color(0xFF686777), fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                              'Input code',
                              style: TextStyle(
                                color: Color(0xFF749A78),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Spacer(), // Handles vertical spacing dynamically
                      AppButton(
                          label: "Cancel",
                          onPressed: () => pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut),
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
