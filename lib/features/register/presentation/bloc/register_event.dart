part of 'register_bloc.dart';

/// All possible events during the 5‑screen registration flow.
sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

final class SubmitPhoneNumber extends RegisterEvent {
  final String phoneNumber;

  const SubmitPhoneNumber({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        phoneNumber,
      ];
}

final class SubmitOtp extends RegisterEvent {
  final String phoneNumber;
  final String userOtp;

  const SubmitOtp({
    required this.userOtp,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [userOtp, phoneNumber];
}

final class SubmitPassword extends RegisterEvent {
  final String password;

  const SubmitPassword(this.password);

  @override
  List<Object?> get props => [password];
}

final class SubmitPersonalInfo extends RegisterEvent {
  final String fullName;
  final String email;

  const SubmitPersonalInfo({
    required this.fullName,
    required this.email,
  });

  @override
  List<Object?> get props => [fullName, email];
}

final class SubmitLegalInfo extends RegisterEvent {
  final bool acceptedTerms;

  const SubmitLegalInfo(this.acceptedTerms);

  @override
  List<Object?> get props => [acceptedTerms];
}

// User taps “Sign up with Google” → obtain Google credential
final class GoogleSignUpRequested extends RegisterEvent {}

// Complete sign‐up using the Google credential
final class GoogleRegisterWithCredentials extends RegisterEvent {
  final OAuthCredential credential;

  const GoogleRegisterWithCredentials({
    required this.credential,
  });

  @override
  List<Object?> get props => [credential];
}

// User taps “Sign up with Facebook” → obtain Facebook credential
final class FacebookSignUpRequested extends RegisterEvent {}

// Complete sign‐up using the Facebook credential
final class FacebookRegisterWithCredentials extends RegisterEvent {
  final OAuthCredential credential;

  const FacebookRegisterWithCredentials({
    required this.credential,
  });

  @override
  List<Object?> get props => [credential];
}

final class CompleteRegistration extends RegisterEvent {}
