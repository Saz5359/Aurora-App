import 'package:aurora_v1/core/common/entities/sensor_data.dart';
import 'package:aurora_v1/features/dashboard/domain/repository/sensor_repository.dart';

import '../datasources/sensor_remote_datasource.dart';

class SensorRepositoryImpl implements SensorRepository {
  final SensorRemoteDataSource remoteDataSource;

  SensorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String?> getDeviceIdForGrow({required String growName}) {
    return remoteDataSource.getDeviceIdForGrow(growName: growName);
  }

  @override
  Stream<SensorData?> streamLatestSensorData(String deviceId) {
    return remoteDataSource.streamLatestSensorData(deviceId);
  }
}
