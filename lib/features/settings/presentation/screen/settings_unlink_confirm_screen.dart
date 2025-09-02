import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsUnlinkConfirmScreen extends StatefulWidget {
  const SettingsUnlinkConfirmScreen({super.key});

  @override
  State<SettingsUnlinkConfirmScreen> createState() =>
      _SettingsUnlinkConfirmScreenState();
}

class _SettingsUnlinkConfirmScreenState
    extends State<SettingsUnlinkConfirmScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        onBack: () => context.pop(),
        title: "Unlink Device",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Are you sure you want to unlink your device?',
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
                    text:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Theme.of(context).colorScheme.secondary,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                  checkColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: 'I confirm I want to unlink my device',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF686777))),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            AppButton(
                label: 'Unlink',
                onPressed: () =>
                    context.pushReplacement('/settings/devices/unlink'),
                type: AppButtonType.delete),
            const SizedBox(
              height: 15,
            ),
            AppButton(
                label: "Cancel",
                onPressed: () => context.pop(),
                type: AppButtonType.confirm)
          ],
        ),
      ),
    );
  }
}
