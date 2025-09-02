import 'dart:io';

import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/settings/domain/usecases/sign_out_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SignOutUseCase _signOut;

  SettingsBloc({required SignOutUseCase signOutUseCase})
      : _signOut = signOutUseCase,
        super(SettingsInitial()) {
    on<SettingsSignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignOutRequested(
    SettingsSignOutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsInProgress());

    try {
      await _signOut();
      AppLogger.info('User signed out successfully.');
      emit(SettingsSignOutSuccess());
    } on SocketException {
      AppLogger.error('No network when signing out.');
      emit(const SettingsFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again later.',
      ));
    } on FirebaseAuthException catch (e) {
      AppLogger.error(
        'FirebaseAuthException during sign out: ${e.code} - ${e.message}',
      );
      emit(SettingsFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Sign out failed: ${e.message}',
      ));
    } catch (e, st) {
      AppLogger.error('Unexpected error during sign out',
          error: e, stackTrace: st);
      emit(SettingsFailure(
        errorType: AppErrorType.unknown,
        message: 'An unexpected error occurred. Please try again.',
      ));
    }
  }
}
