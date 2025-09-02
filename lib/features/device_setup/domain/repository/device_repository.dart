import 'package:aurora_v1/features/device_setup/domain/entities/device_connection.dart';

abstract class DeviceSetupRepository {
  Future updateConnection(DeviceConnection connection);
}
