import 'package:aurora_v1/features/device_dashboard/domain/repository/device_dashboard_repository.dart';

class GetDeviceNameUseCase {
  final DeviceDashboardRepository repository;

  GetDeviceNameUseCase(this.repository);

  Future<String> call(String plantId) {
    return repository.getDeviceName(plantId);
  }
}
