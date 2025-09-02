part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsInProgress extends SettingsState {}

class SettingsSignOutSuccess extends SettingsState {}

class SettingsFailure extends SettingsState {
  final AppErrorType errorType;
  final String message;

  const SettingsFailure({
    required this.errorType,
    required this.message,
  });

  @override
  List<Object?> get props => [errorType, message];
}
