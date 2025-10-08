import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/settings/presentation/widgets/sesstion_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsManagePeopleScreen extends StatelessWidget {
  const SettingsManagePeopleScreen({super.key});

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
                            text: 'Add people to help manage the device',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF686777))),
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SessionItem(
                      icon: Icons.person_outline,
                      title: 'Kevin Michael Allin',
                      onDeactivate: () =>
                          context.push("/settings/devices/people/remove"),
                    ),
                    SessionItem(
                      icon: Icons.person_outline,
                      title: 'Belle Guness',
                      onDeactivate: () =>
                          context.push("/settings/devices/people/remove"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Spacer(),
                    AppButton(
                        label: "Add People",
                        onPressed: () =>
                            context.push("/settings/devices/people/add"),
                        type: AppButtonType.cancel),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                        label: "Cancel",
                        onPressed: () => context.pop(),
                        type: AppButtonType.cancel),
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
