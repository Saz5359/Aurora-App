import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddDeviceConfigureWifi extends StatelessWidget {
  final String name;

  const AddDeviceConfigureWifi({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(onBack: () => context.pop(), title: 'Add Device'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Configure Wifi',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: 'Advanced network settings ',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Connected',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.verified_user_outlined,
                              color: Colors.black),
                          title: const Text(
                            'Network speed',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          trailing: const Text(
                            '39.9Mbps',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          onTap: () {
                            // Handle "Network speed" tap
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.verified_user_outlined,
                              color: Colors.black),
                          title: const Flexible(
                            child: Text(
                              'Security',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: const Text(
                            'WPA/WPA2-Personal',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          onTap: () {
                            // Handle "Security" tap
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      AppButton(
                        label: "Forget Network",
                        onPressed: () => context.pop(),
                        type: AppButtonType.cancel,
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                          label: "Disconnect",
                          onPressed: () => context.pop(),
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
