import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding_bloc.dart';

class OnboardingGate extends StatefulWidget {
  const OnboardingGate({super.key});

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  @override
  void initState() {
    super.initState();
    // Fire the one‐time check
    context.read<OnboardingBloc>().add(CheckOnboardingStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingFirstTime) {
          // First launch ever
          context.go('/welcome');
        } else if (state is OnboardingAuthenticated) {
          // Already signed in
          context.go('/dashboard');
        } else if (state is OnboardingUnauthenticated) {
          // Not signed in and not first‐time
          context.go('/login');
        } else if (state is OnboardingFailure) {
          if (state.errorType == AppErrorType.network) {
            context.go("network_error");
          } else {
            showAppErrorSnackBar(context,
                message: state.message, errorType: state.errorType);
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingLoading || state is OnboardingInitial) {
                return CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.tertiary,
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
