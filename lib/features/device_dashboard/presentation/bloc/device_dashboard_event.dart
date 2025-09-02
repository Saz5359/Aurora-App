part of 'device_dashboard_bloc.dart';

abstract class DeviceDashboardEvent extends Equatable {
  const DeviceDashboardEvent();

  @override
  List<Object?> get props => [];
}

class StartSensorDataStream extends DeviceDashboardEvent {
  final String plantId;

  const StartSensorDataStream(this.plantId);

  @override
  List<Object?> get props => [plantId];
}
