import 'package:aurora_v1/features/device_dashboard/data/model/sensor_data_model.dart';
import 'package:aurora_v1/features/device_dashboard/domain/repository/device_dashboard_repository.dart';

class StreamDeviceSensorData {
  final DeviceDashboardRepository repository;

  StreamDeviceSensorData(this.repository);

  Stream<SensorDataModel?> call(String deviceName) {
    return repository.streamSensorData(deviceName);
  }
}
