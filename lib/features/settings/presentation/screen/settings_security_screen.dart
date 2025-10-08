import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/settings/presentation/widgets/sesstion_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsSecurityScreen extends StatelessWidget {
  const SettingsSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        onBack: () => context.pop(),
        title: "Password and Security",
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Active sessions',
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
                          text: 'Where you are logged in',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF686777))),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SessionItem(
                    icon: Icons.phone_iphone,
                    title: 'iPhone X - JHB, South Africa',
                    onDeactivate: () =>
                        context.push("/settings/personal/sessions/deactivate"),
                  ),
                  SessionItem(
                    icon: Icons.computer,
                    title: 'Windows PC - CP, South Africa',
                    onDeactivate: () =>
                        context.push("/settings/personal/sessions/deactivate"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Login',
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
                          text: 'Update/ Change Password',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFF686777))),
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => context.push("/forgot_password"),
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
                          'Change Password',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
