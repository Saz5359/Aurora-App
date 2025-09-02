part of 'device_setup_bloc.dart';

sealed class DeviceSetupState extends Equatable {
  const DeviceSetupState();
  @override
  List<Object?> get props => [];
}

final class DeviceSetupInitial extends DeviceSetupState {}

final class DeviceSetupInProgress extends DeviceSetupState {}

final class DeviceSetupSuccess extends DeviceSetupState {
  final bool isConnected;
  const DeviceSetupSuccess({required this.isConnected});
  @override
  List<Object?> get props => [isConnected];
}

class DeviceSetupFailure extends DeviceSetupState {
  final AppErrorType errorType;
  final String message;
  const DeviceSetupFailure({
    required this.errorType,
    required this.message,
  });

  @override
  List<Object?> get props => [errorType, message];
}
