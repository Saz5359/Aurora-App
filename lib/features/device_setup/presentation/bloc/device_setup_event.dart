part of 'device_setup_bloc.dart';

sealed class DeviceSetupEvent extends Equatable {
  const DeviceSetupEvent();
  @override
  List<Object?> get props => [];
}

final class ConnectionStatusUpdated extends DeviceSetupEvent {
  final DeviceConnection connection;
  const ConnectionStatusUpdated(this.connection);
  @override
  List<Object?> get props => [connection];
}
