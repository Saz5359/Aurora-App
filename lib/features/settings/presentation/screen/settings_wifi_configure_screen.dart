import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsWifiConfigureScreen extends StatelessWidget {
  SettingsWifiConfigureScreen({super.key});

  final TextEditingController _networkController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        onBack: () => context.pop(),
        title: "Devices and Networks",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Configure Wifi',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: 'You will to connect the device to your network',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _networkController,
              decoration: InputDecoration(
                labelText: 'Network',
                labelStyle: const TextStyle(
                  color: Colors.black, // Gray label color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded border
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E4), // Light gray border
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E4), // Border when not focused
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary, // Border when focused
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Colors.black, // Gray label color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded border
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E4), // Light gray border
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFE2E3E4), // Border when not focused
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary, // Border when focused
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            AppButton(
                label: "Save",
                onPressed: () => context.pop(),
                type: AppButtonType.confirm),
            const SizedBox(
              height: 10,
            ),
            AppButton(
                label: 'Cancel',
                onPressed: () => context.pop(),
                type: AppButtonType.cancel)
          ],
        ),
      ),
    );
  }
}
