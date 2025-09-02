import 'package:aurora_v1/features/dashboard/domain/repository/sensor_repository.dart';
import '../entities/sensor_data.dart';

/// Use case: Stream the latest sensor data for a given [deviceId].
class StreamSensorDataUseCase {
  final SensorRepository repository;

  StreamSensorDataUseCase(this.repository);

  Stream<SensorData?> call(String deviceId) {
    return repository.streamLatestSensorData(deviceId);
  }
}
