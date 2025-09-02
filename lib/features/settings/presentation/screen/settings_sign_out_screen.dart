import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/settings_bloc.dart';

class SettingsSignOutScreen extends StatelessWidget {
  const SettingsSignOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Text(
                  'You have been signed out',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              BlocConsumer<SettingsBloc, SettingsState>(
                listener: (context, state) {
                  if (state is SettingsFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is SettingsSignOutSuccess) {
                    context.go('/login');
                  }
                },
                builder: (context, state) {
                  if (state is SettingsInProgress) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return AppButton(
                    label: 'Login',
                    type: AppButtonType.confirm,
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
      ),
    );
  }
}
