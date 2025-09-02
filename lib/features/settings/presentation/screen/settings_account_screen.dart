import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsAccountScreen extends StatefulWidget {
  const SettingsAccountScreen({super.key});

  @override
  State<SettingsAccountScreen> createState() => _SettingsAccountScreenState();
}

class _SettingsAccountScreenState extends State<SettingsAccountScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StepAppBar(
        onBack: null,
        title: "Account Deletion",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sorry to see you go!',
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
                          text:
                              'We at grow respect your privacy, would you like us to remove your data from our system as well in accordance with the South African PoPI act',
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
                label: 'Delete Account',
                onPressed: () {},
                type: AppButtonType.delete),
            const SizedBox(
              height: 15,
            ),
            AppButton(
                label: 'Cancel', onPressed: () {}, type: AppButtonType.confirm),
          ],
        ),
      ),
    );
  }
}
