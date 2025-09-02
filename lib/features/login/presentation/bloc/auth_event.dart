part of 'auth_bloc.dart';

/// Base class for all authentication-related events.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event fired when the user taps "Sign In" with phone & password.
final class EmailLoginRequested extends AuthEvent {
  final String phoneNumber;
  final String password;

  const EmailLoginRequested({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object> get props => [phoneNumber, password];
}

/// Event fired when the user taps "Sign In with Google".
final class GoogleLoginRequested extends AuthEvent {}

/// Event fired when the user taps "Sign In with Facebook".
final class FacebookLoginRequested extends AuthEvent {}
