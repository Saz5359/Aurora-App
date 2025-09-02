import 'package:aurora_v1/features/dashboard/domain/repository/sensor_repository.dart';

// Fetch the device ID for a given growName.
class GetDeviceIdForGrowUseCase {
  final SensorRepository repository;

  GetDeviceIdForGrowUseCase(this.repository);

  Future<String?> call(String growName) {
    return repository.getDeviceIdForGrow(growName: growName);
  }
}
