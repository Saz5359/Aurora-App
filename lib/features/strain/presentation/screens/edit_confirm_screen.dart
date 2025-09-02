import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditConfirmScreen extends StatelessWidget {
  final Plant grow;
  const EditConfirmScreen({super.key, required this.grow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(onBack: () => context.pop(), title: "Custom Strain"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Edit strain",
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF04021D),
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text:
                      'By editing the current strain info, the grow will be changed to a custom strain. ',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ),
            const Spacer(),
            AppButton(
                label: "Continue",
                onPressed: () =>
                    context.pushReplacement('/strain/edit', extra: grow),
                type: AppButtonType.cancel),
            const SizedBox(
              height: 10,
            ),
            AppButton(
                label: "Back",
                onPressed: () => context.pop(),
                type: AppButtonType.confirm),
          ],
        ),
      ),
    );
  }
}
