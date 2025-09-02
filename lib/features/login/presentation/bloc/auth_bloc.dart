import 'dart:io';

import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/login/domain/entities/login_user.dart';
import 'package:aurora_v1/features/login/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:aurora_v1/features/login/domain/usecases/sign_in_with_facebook.dart';
import 'package:aurora_v1/features/login/domain/usecases/sign_in_with_google.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// The [AuthBloc] coordinates login-related user interactions.
/// It depends on three use-cases, each representing a distinct sign-in method.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailUseCase _signInWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignInWithFacebookUseCase _signInWithFacebook;

  AuthBloc({
    required SignInWithEmailUseCase signInWithEmail,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignInWithFacebookUseCase signInWithFacebook,
  })  : _signInWithEmail = signInWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _signInWithFacebook = signInWithFacebook,
        super(AuthInitial()) {
    // Handle email/password login events
    on<EmailLoginRequested>(_onEmailLoginRequested);

    // Handle Google login events
    on<GoogleLoginRequested>(_onGoogleLoginRequested);

    // Handle Facebook login events
    on<FacebookLoginRequested>(_onFacebookLoginRequested);
  }

  /// Handler for email/password login:
  /// - Validates input
  /// - Calls the use-case
  /// - Emits appropriate states depending on success or error
  Future<void> _onEmailLoginRequested(
    EmailLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Input validation: ensure phone & password aren't empty
    if (event.phoneNumber.trim().isEmpty || event.password.trim().isEmpty) {
      emit(const AuthFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Phone number and password must not be empty.',
      ));
      return;
    }

    emit(AuthLoading());

    try {
      final LoginUser? user = await _signInWithEmail(
        event.phoneNumber,
        event.password,
      );

      if (user != null) {
        emit(AuthSuccess(user: user));
        AppLogger.info("User logged in: ${user.email}");
      } else {
        emit(const AuthFailure(
          errorType: AppErrorType.invalidInput,
          message: 'Invalid login credentials.',
        ));
      }
    } on SocketException {
      // Network connectivity issue
      emit(const AuthFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again later.',
      ));
    } on FirebaseAuthException catch (e) {
      // Map specific FirebaseAuthException codes to user-friendly messages
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'invalid-credential':
          message = 'Invalid login credentials.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          message = 'No user found for that phone number.';
          break;
        case 'wrong-password':
          message = 'Incorrect password provided.';
          break;
        default:
          // Covers 'invalid-credential', 'too-many-requests', etc.
          message = 'Authentication failed. ${e.message}';
          break;
      }
      emit(AuthFailure(
        errorType: AppErrorType.invalidInput,
        message: message,
      ));
      AppLogger.error(
        'FirebaseAuthException during email login: ${e.code} - ${e.message}',
      );
    } catch (e) {
      // Any other unexpected error
      emit(const AuthFailure(
        errorType: AppErrorType.unknown,
        message: 'Unexpected error occurred. Please try again.',
      ));
      AppLogger.error('General exception during email login: $e');
    }
  }

  /// Handler for Google sign-in:
  /// - Calls the use-case
  /// - Emits appropriate states for success or error
  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final LoginUser? user = await _signInWithGoogle();

      if (user != null) {
        emit(AuthSuccess(user: user));
        AppLogger.info("Google sign-in successful: ${user.email}");
      } else {
        emit(const AuthFailure(
          errorType: AppErrorType.invalidInput,
          message: 'Google sign-in canceled or failed.',
        ));
      }
    } on SocketException {
      emit(const AuthFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again later.',
      ));
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'An account already exists with a different credential.';
          break;
        case 'invalid-credential':
          message = 'Invalid Google credentials.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          message = 'No user found for that Google account.';
          break;
        default:
          message = 'Google authentication failed. ${e.message}';
          break;
      }
      emit(AuthFailure(
        errorType: AppErrorType.invalidInput,
        message: message,
      ));
      AppLogger.error(
        'FirebaseAuthException during Google login: ${e.code} - ${e.message}',
      );
    } catch (e) {
      emit(const AuthFailure(
        errorType: AppErrorType.unknown,
        message: 'Unexpected error occurred during Google sign-in.',
      ));
      AppLogger.error('General exception during Google login: $e');
    }
  }

  /// Handler for Facebook sign-in:
  /// - Calls the use-case
  /// - Emits appropriate states for success or error
  Future<void> _onFacebookLoginRequested(
    FacebookLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final LoginUser? user = await _signInWithFacebook();

      if (user != null) {
        emit(AuthSuccess(user: user));
        AppLogger.info("Facebook sign-in successful: ${user.email}");
      } else {
        emit(const AuthFailure(
          errorType: AppErrorType.invalidInput,
          message: 'Facebook sign-in canceled or failed.',
        ));
      }
    } on SocketException {
      emit(const AuthFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again later.',
      ));
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'An account already exists with a different credential.';
          break;
        case 'invalid-credential':
          message = 'Invalid Facebook credentials.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          message = 'No user found for that Facebook account.';
          break;
        default:
          message = 'Facebook authentication failed. ${e.message}';
          break;
      }
      emit(AuthFailure(
        errorType: AppErrorType.invalidInput,
        message: message,
      ));
      AppLogger.error(
        'FirebaseAuthException during Facebook login: ${e.code} - ${e.message}',
      );
    } catch (e) {
      emit(const AuthFailure(
        errorType: AppErrorType.unknown,
        message: 'Unexpected error occurred during Facebook sign-in.',
      ));
      AppLogger.error('General exception during Facebook login: $e');
    }
  }
}
