part of 'device_dashboard_bloc.dart';

abstract class DeviceDashboardState extends Equatable {
  const DeviceDashboardState();

  @override
  List<Object?> get props => [];
}

class DeviceDashboardInitial extends DeviceDashboardState {}

class DeviceDashboardLoading extends DeviceDashboardState {}

class DeviceDashboardLoaded extends DeviceDashboardState {
  final SensorDataModel sensorData;

  const DeviceDashboardLoaded(this.sensorData);

  @override
  List<Object?> get props => [sensorData];
}

class DeviceDashboardError extends DeviceDashboardState {
  final AppErrorType errorType;
  final String message;

  const DeviceDashboardError(this.message, this.errorType);

  @override
  List<Object?> get props => [message];
}
