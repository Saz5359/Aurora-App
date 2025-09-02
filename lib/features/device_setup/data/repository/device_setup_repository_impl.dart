import 'package:aurora_v1/features/device_setup/domain/repository/device_repository.dart';
import '../../../device_setup/domain/entities/device_connection.dart';
import '../datasources/device_setup_remote_datasource.dart';

class DeviceSetupRepositoryImpl implements DeviceSetupRepository {
  final DeviceSetupRemoteDataSource remoteDs;

  DeviceSetupRepositoryImpl({required this.remoteDs});

  @override
  Future updateConnection(DeviceConnection connection) {
    return remoteDs.registerDevice(connection);
  }
}
