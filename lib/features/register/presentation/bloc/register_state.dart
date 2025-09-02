part of 'register_bloc.dart';

/// Carries the intermediate form data as we progress through 5 screens.
class RegisterForm extends Equatable {
  final String? phoneNumber;
  final String? otp;
  final String? password;
  final String? fullName;
  final String? email;
  final bool? acceptedTerms;

  const RegisterForm({
    this.phoneNumber,
    this.otp,
    this.password,
    this.fullName,
    this.email,
    this.acceptedTerms,
  });

  RegisterForm copyWith({
    String? phoneNumber,
    String? otp,
    String? password,
    String? fullName,
    String? email,
    bool? acceptedTerms,
  }) {
    return RegisterForm(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }

  @override
  List<Object?> get props =>
      [phoneNumber, otp, password, fullName, email, acceptedTerms];
}

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

/// Intermediate success after completing each step. Carries the accumulated [form].
final class RegisterStepSuccess extends RegisterState {
  final RegisterForm form;

  const RegisterStepSuccess(this.form);

  @override
  List<Object?> get props => [form];
}

final class RegisterSuccess extends RegisterState {}

final class RegisterFailure extends RegisterState {
  final AppErrorType errorType;
  final String message;

  const RegisterFailure({
    required this.errorType,
    required this.message,
  });

  @override
  List<Object?> get props => [errorType, message];
}

// Google credential was retrieved
final class GoogleCredentialReceived extends RegisterState {
  final OAuthCredential credential;

  const GoogleCredentialReceived(this.credential);

  @override
  List<Object?> get props => [credential];
}

// Facebook credential was retrieved
final class FacebookCredentialReceived extends RegisterState {
  final OAuthCredential credential;

  const FacebookCredentialReceived(this.credential);

  @override
  List<Object?> get props => [credential];
}
