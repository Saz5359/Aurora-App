import 'package:aurora_v1/features/device_setup/domain/repository/device_repository.dart';

import '../entities/device_connection.dart';

class UpdateConnectionUseCase {
  final DeviceSetupRepository repository;

  UpdateConnectionUseCase(this.repository);

  Future call(DeviceConnection connection) {
    return repository.updateConnection(connection);
  }
}
