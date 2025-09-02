import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsAddPeopleScreen extends StatefulWidget {
  const SettingsAddPeopleScreen({super.key});

  @override
  State<SettingsAddPeopleScreen> createState() =>
      _SettingsAddPeopleScreenState();
}

class _SettingsAddPeopleScreenState extends State<SettingsAddPeopleScreen> {
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
              'Guests',
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
                        'Add people to the device by scanning QR code on the guests device',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Select Contacts',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '238 Contacts',
                style: TextStyle(fontSize: 16, color: Color(0xFF686777)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with dynamic contact count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFB15BF4),
                      child: Text(
                        "KB", // Replace with initials dynamically
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: const Text(
                      "Kevin Bacon", // Replace with contact name dynamically
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => context
                        .pushReplacement('/settings/devices/people/added'),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Alternatively send a link',
                style: TextStyle(fontSize: 16, color: Color(0xFF686777)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFE2E3E4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2.0,
                        ),
                      ),
                      hintText: "https://grow.com/73j2j4g",
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5EFD8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Copy link functionality
                  },
                  child: const Text(
                    "Copy",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            AppButton(
                label: 'Back',
                onPressed: () => context.pop(),
                type: AppButtonType.cancel)
          ],
        ),
      ),
    );
  }
}
