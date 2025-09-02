part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final LoginUser user;

  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthFailure extends AuthState {
  final AppErrorType errorType;
  final String message;

  const AuthFailure({
    required this.errorType,
    required this.message,
  });

  @override
  List<Object> get props => [errorType, message];
}
