import 'package:aurora_v1/core/common/entities/sensor_data.dart';
import 'package:aurora_v1/features/device_dashboard/domain/repository/device_dashboard_repository.dart';

class StreamDeviceSensorData {
  final DeviceDashboardRepository repository;

  StreamDeviceSensorData(this.repository);

  Stream<SensorData?> call(String deviceName) {
    return repository.streamSensorData(deviceName);
  }
}
