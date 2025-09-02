import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsDeviceConfigScreen extends StatefulWidget {
  const SettingsDeviceConfigScreen({super.key});

  @override
  State<SettingsDeviceConfigScreen> createState() =>
      _SettingsDeviceConfigScreenState();
}

class _SettingsDeviceConfigScreenState
    extends State<SettingsDeviceConfigScreen> {
  final TextEditingController _controller = TextEditingController();

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
              'Device one',
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
                    text: 'CB-69-420',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: 'Device information and Network status',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Device Name',
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
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Grow',
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
            Text(
              'Configure Device',
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
                    text: 'Device information and Network status',
                    style: TextStyle(fontSize: 16, color: Color(0xFF686777))),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => context.push('/settings/devices/wifi-config'),
              child: Row(
                children: [
                  Icon(
                    Icons.add_box_outlined,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Configure WiFi network',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => context.push("/settings/devices/people"),
              child: Row(
                children: [
                  Icon(
                    Icons.add_box_outlined,
                    size: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Manage people',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
            ),
            const Spacer(),
            AppButton(
                label: "Save",
                onPressed: () => context.pop(),
                type: AppButtonType.confirm),
            const SizedBox(
              height: 15,
            ),
            AppButton(
                label: 'Unlink Device',
                onPressed: () =>
                    context.pushReplacement('/settings/devices/unlink/confirm'),
                type: AppButtonType.delete)
          ],
        ),
      ),
    );
  }
}
