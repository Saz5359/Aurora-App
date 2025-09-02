part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingFirstTime extends OnboardingState {}

final class OnboardingAuthenticated extends OnboardingState {}

final class OnboardingUnauthenticated extends OnboardingState {}

final class OnboardingFailure extends OnboardingState {
  final AppErrorType errorType;
  final String message;

  const OnboardingFailure({
    required this.errorType,
    required this.message,
  });

  @override
  List<Object?> get props => [errorType, message];
}
