import 'dart:io';

import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/onboarding/domain/usecases/is_first_time_usecase.dart';
import 'package:aurora_v1/features/onboarding/domain/usecases/is_user_authenticated_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final IsFirstTimeUseCase _isFirstTimeUseCase;
  final IsUserAuthenticatedUseCase _isUserAuthenticatedUseCase;

  OnboardingBloc({
    required IsFirstTimeUseCase isFirstTimeUseCase,
    required IsUserAuthenticatedUseCase isUserAuthenticatedUseCase,
  })  : _isFirstTimeUseCase = isFirstTimeUseCase,
        _isUserAuthenticatedUseCase = isUserAuthenticatedUseCase,
        super(OnboardingInitial()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    try {
      final bool firstTime = await _isFirstTimeUseCase();
      if (firstTime) {
        AppLogger.info('OnboardingBloc: First‐time user detected.');
        emit(OnboardingFirstTime());
        return;
      }

      final bool authenticated = await _isUserAuthenticatedUseCase();
      if (authenticated) {
        AppLogger.info('OnboardingBloc: Firebase user already signed in.');
        emit(OnboardingAuthenticated());
      } else {
        AppLogger.info('OnboardingBloc: No Firebase user found.');
        emit(OnboardingUnauthenticated());
      }
    } on SocketException {
      AppLogger.error('OnboardingBloc: Network error while checking status.');
      emit(const OnboardingFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } catch (e, st) {
      AppLogger.error(
        'OnboardingBloc: Unknown error in _onCheckOnboardingStatus: $e',
        stackTrace: st,
      );
      emit(OnboardingFailure(
        errorType: AppErrorType.unknown,
        message: 'Unexpected error occurred. Please restart the app.',
      ));
    }
  }
}
