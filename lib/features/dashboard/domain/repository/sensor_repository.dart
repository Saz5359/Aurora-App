import 'package:aurora_v1/core/common/entities/sensor_data.dart';

/// Thrown when a failure occurs in Sensor operations.
class SensorException implements Exception {
  final String message;
  SensorException(this.message);
}

abstract class SensorRepository {
  Future<String?> getDeviceIdForGrow({required String growName});
  Stream<SensorData?> streamLatestSensorData(String deviceId);
}
