import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/settings/presentation/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        onBack: context.pop,
        title: "Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Account',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 5),
            const Text(
              'Tell us about yourself!',
              style: TextStyle(fontSize: 16, color: Color(0xFF686777)),
            ),
            const SizedBox(height: 10),
            SettingTile(
              onTap: () => context.push('/settings/personal'),
              label: 'Personal and account information',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 10),
            SettingTile(
              onTap: () => context.push("/settings/security"),
              label: 'Password and security',
              icon: Icons.verified_user_outlined,
            ),
            const SizedBox(height: 20),
            Text(
              'Devices',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 5),
            const Text(
              'Customise your device settings',
              style: TextStyle(fontSize: 16, color: Color(0xFF686777)),
            ),
            const SizedBox(height: 10),
            SettingTile(
              onTap: () => context.push("/settings/devices"),
              label: 'Manage devices and networks',
              icon: Icons.add_box_outlined,
            ),
            const Spacer(),
            BlocConsumer<SettingsBloc, SettingsState>(
              listener: (context, state) {
                if (state is SettingsFailure) {
                  showAppErrorSnackBar(context,
                      message: state.message, errorType: state.errorType);
                } else if (state is SettingsSignOutSuccess) {
                  context.go('/login');
                }
              },
              builder: (context, state) {
                if (state is SettingsInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                return AppButton(
                  label: 'Sign Out',
                  type: AppButtonType.cancel,
                  onPressed: () {
                    context
                        .read<SettingsBloc>()
                        .add(SettingsSignOutRequested());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
