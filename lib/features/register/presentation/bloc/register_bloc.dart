import 'dart:io';

import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/features/register/domain/usecases/get_facebook_credentials_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aurora_v1/core/utils/logger.dart';

import '../../domain/entities/register_request_entity.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/usecases/get_google_register_credentials_usecase.dart';
import '../../domain/usecases/register_with_google_usecase.dart';
import '../../domain/usecases/register_with_facebook_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RequestOtpUseCase _requestOtp;
  final VerifyOtpUseCase _verifyOtp;
  final RegisterUserUseCase _registerUser;
  final GetGoogleRegisterCredentialsUseCase _getGoogleCredentials;
  final RegisterWithGoogleUseCase _registerWithGoogle;
  final GetFacebookRegisterCredentialsUseCase _getFacebookCredentials;
  final RegisterWithFacebookUseCase _registerWithFacebook;

  RegisterForm _form = const RegisterForm();

  RegisterBloc({
    required RequestOtpUseCase requestOtp,
    required VerifyOtpUseCase verifyOtp,
    required RegisterUserUseCase registerUser,
    required GetGoogleRegisterCredentialsUseCase getGoogleCredentials,
    required RegisterWithGoogleUseCase registerWithGoogle,
    required GetFacebookRegisterCredentialsUseCase getFacebookCredentials,
    required RegisterWithFacebookUseCase registerWithFacebook,
  })  : _requestOtp = requestOtp,
        _verifyOtp = verifyOtp,
        _registerUser = registerUser,
        _getGoogleCredentials = getGoogleCredentials,
        _registerWithGoogle = registerWithGoogle,
        _getFacebookCredentials = getFacebookCredentials,
        _registerWithFacebook = registerWithFacebook,
        super(RegisterInitial()) {
    on<SubmitPhoneNumber>(_onSubmitPhoneNumber);
    on<SubmitOtp>(_onSubmitOtp);
    on<SubmitPassword>(_onSubmitPassword);
    on<SubmitPersonalInfo>(_onSubmitPersonalInfo);
    on<SubmitLegalInfo>(_onSubmitLegalInfo);
    on<CompleteRegistration>(_onCompleteRegistration);
    on<GoogleSignUpRequested>(_onGoogleSignUpRequested);
    on<GoogleRegisterWithCredentials>(_onGoogleRegisterWithCredentials);
    on<FacebookSignUpRequested>(_onFacebookSignUpRequested);
    on<FacebookRegisterWithCredentials>(_onFacebookRegisterWithCredentials);
  }

  /// STEP 1: Send OTP to phoneNumber using pre‑generated generatedOtp.
  Future<void> _onSubmitPhoneNumber(
      SubmitPhoneNumber event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final sent = await _requestOtp(event.phoneNumber);
      if (sent) {
        _form = _form.copyWith(
          phoneNumber: event.phoneNumber, /* otp: event.generatedOtp */
        );
        AppLogger.info('OTP sent to ${event.phoneNumber}');
        emit(RegisterStepSuccess(_form));
      } else {
        emit(const RegisterFailure(
          errorType: AppErrorType.network,
          message: 'Failed to send OTP. Please try again.',
        ));
      }
    } on SocketException {
      emit(const RegisterFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } catch (e) {
      emit(RegisterFailure(
        errorType: AppErrorType.unknown,
        message: 'Error sending OTP: ${e.toString()}',
      ));
      AppLogger.error('Error sending OTP: $e');
    }
  }

  /// STEP 2: Verify user‐entered userOtp against stored generatedOtp in form.
  Future<void> _onSubmitOtp(
      SubmitOtp event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      AppLogger.info('Verifying OTP: ${event.userOtp}');
      final verified = _verifyOtp(event.phoneNumber, event.userOtp);
      if (await verified) {
        _form = _form.copyWith(otp: event.userOtp);
        AppLogger.info('OTP verified successfully');
        emit(RegisterStepSuccess(_form));
      } else {
        emit(const RegisterFailure(
          errorType: AppErrorType.invalidInput,
          message: 'Invalid OTP. Please try again.',
        ));
      }
    } catch (e) {
      emit(RegisterFailure(
        errorType: AppErrorType.unknown,
        message: 'Error verifying OTP: ${e.toString()}',
      ));
      AppLogger.error('Error verifying OTP: $e');
    }
  }

  /// STEP 3: Store chosen password.
  void _onSubmitPassword(SubmitPassword event, Emitter<RegisterState> emit) {
    _form = _form.copyWith(password: event.password);
    AppLogger.info('Password collected');
    emit(RegisterStepSuccess(_form));
  }

  /// STEP 4: Store personal info ([fullName], [email]).
  void _onSubmitPersonalInfo(
      SubmitPersonalInfo event, Emitter<RegisterState> emit) {
    _form = _form.copyWith(fullName: event.fullName, email: event.email);
    AppLogger.info('Personal info collected');
    emit(RegisterStepSuccess(_form));
  }

  /// STEP 5: Store legal acceptance ([acceptedTerms]).
  void _onSubmitLegalInfo(SubmitLegalInfo event, Emitter<RegisterState> emit) {
    _form = _form.copyWith(acceptedTerms: event.acceptedTerms);
    AppLogger.info('Legal info collected');
    emit(RegisterStepSuccess(_form));
  }

  /// FINAL STEP: All data is in `_form` → call `RegisterUserUseCase`.
  Future<void> _onCompleteRegistration(
      CompleteRegistration event, Emitter<RegisterState> emit) async {
    // Basic validation before calling use‑case
    if (_form.phoneNumber == null ||
        _form.otp == null ||
        _form.password == null ||
        _form.acceptedTerms != true) {
      emit(const RegisterFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Please complete all steps before registering.',
      ));
      return;
    }

    emit(RegisterLoading());

    try {
      final request = RegisterRequestEntity(
        phoneNumber: _form.phoneNumber!,
        otp: _form.otp!,
        password: _form.password!,
        fullName: _form.fullName ?? '',
        email: _form.email ?? '',
        acceptedTerms: _form.acceptedTerms!,
      );

      await _registerUser(request);
      AppLogger.info('User registered successfully');
      emit(RegisterSuccess());
    } on SocketException {
      emit(const RegisterFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'weak-password' => 'The password is too weak.',
        'email-already-in-use' => 'This email is already in use.',
        _ => 'Registration failed. ${e.message}',
      };
      emit(RegisterFailure(
        errorType: AppErrorType.invalidInput,
        message: message,
      ));
      AppLogger.error(
        'FirebaseAuthException during registerUser: ${e.code} - ${e.message}',
      );
    } catch (e) {
      emit(RegisterFailure(
        errorType: AppErrorType.unknown,
        message: 'Unexpected error: ${e.toString()}',
      ));
      AppLogger.error('General exception during registerUser: $e');
    }
  }

  Future<void> _onGoogleSignUpRequested(
      GoogleSignUpRequested event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final OAuthCredential? credential = await _getGoogleCredentials();
      if (credential != null) {
        emit(GoogleCredentialReceived(credential));
        AppLogger.info('Google credentials received');
      } else {
        emit(const RegisterFailure(
          errorType: AppErrorType.invalidInput,
          message: 'Could not get Google credentials.',
        ));
      }
    } on SocketException {
      emit(const RegisterFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } catch (e) {
      emit(RegisterFailure(
        errorType: AppErrorType.unknown,
        message: 'Error obtaining Google credentials: ${e.toString()}',
      ));
      AppLogger.error('Error obtaining Google credentials: $e');
    }
  }

  Future<void> _onGoogleRegisterWithCredentials(
      GoogleRegisterWithCredentials event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      await _registerWithGoogle(event.credential);
      AppLogger.info('Google registration succeeded');
      emit(RegisterSuccess());
    } on SocketException {
      emit(const RegisterFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'account-exists-with-different-credential' =>
          'An account already exists with a different credential.',
        _ => 'Google registration failed. ${e.message}',
      };
      emit(RegisterFailure(
        errorType: AppErrorType.invalidInput,
        message: message,
      ));
      AppLogger.error(
        'FirebaseAuthException during Google register: ${e.code} - ${e.message}',
      );
    } catch (e) {
      emit(RegisterFailure(
        errorType: AppErrorType.unknown,
        message: 'Unexpected error during Google register: ${e.toString()}',
      ));
      AppLogger.error('General exception during Google register: $e');
    }
  }

  Future<void> _onFacebookSignUpRequested(
      FacebookSignUpRequested event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final OAuthCredential? credential = await _getFacebookCredentials();
      if (credential != null) {
        emit(FacebookCredentialReceived(credential));
        AppLogger.info('Facebook credentials received');
      } else {
        emit(const RegisterFailure(
          errorType: AppErrorType.invalidInput,
          message: 'Could not get Facebook credentials.',
        ));
      }
    } on SocketException {
      emit(const RegisterFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } catch (e) {
      emit(RegisterFailure(
        errorType: AppErrorType.unknown,
        message: 'Error obtaining Facebook credentials: ${e.toString()}',
      ));
      AppLogger.error('Error obtaining Facebook credentials: $e');
    }
  }

  Future<void> _onFacebookRegisterWithCredentials(
      FacebookRegisterWithCredentials event,
      Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      await _registerWithFacebook(event.credential);
      AppLogger.info('Facebook registration succeeded');
      emit(RegisterSuccess());
    } on SocketException {
      emit(const RegisterFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'account-exists-with-different-credential' =>
          'An account already exists with a different credential.',
        _ => 'Facebook registration failed. ${e.message}',
      };
      emit(RegisterFailure(
        errorType: AppErrorType.invalidInput,
        message: message,
      ));
      AppLogger.error(
        'FirebaseAuthException during Facebook register: ${e.code} - ${e.message}',
      );
    } catch (e) {
      emit(RegisterFailure(
        errorType: AppErrorType.unknown,
        message: 'Unexpected error during Facebook register: ${e.toString()}',
      ));
      AppLogger.error('General exception during Facebook register: $e');
    }
  }
}
