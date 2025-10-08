import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/settings/presentation/widgets/device_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsDevicesScreen extends StatelessWidget {
  const SettingsDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        onBack: () => context.pop(),
        title: "Devices and Networks",
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
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
                    Text(
                      'Current Devices',
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
                            text: 'Current devices linked to your Grow',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF686777))),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () =>
                          context.push("/settings/devices/device-config"),
                      child: const DeviceItem(
                        deviceIcon: Icons.tv,
                        deviceName: 'Device One',
                        signalIcon: Icons.wifi,
                        percentage: '57%',
                        percentageColor: Colors.orange,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          context.push("/settings/devices/device-config"),
                      child: const DeviceItem(
                        deviceIcon: Icons.tv,
                        deviceName: 'Device Two',
                        signalIcon: Icons.wifi,
                        percentage: '63%',
                        percentageColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Spacer(),
                    AppButton(
                        label: 'Add New device',
                        onPressed: null,
                        /* () => context.push("/device_setup"), */
                        type: AppButtonType.cancel),
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
            ),
          ),
        ),
      ),
    );
  }
}
