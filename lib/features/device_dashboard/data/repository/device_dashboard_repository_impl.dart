import 'package:aurora_v1/core/common/entities/sensor_data.dart';
import 'package:aurora_v1/features/device_dashboard/data/datasources/device_sensor_remote_data_source.dart';
import 'package:aurora_v1/features/device_dashboard/data/datasources/device_remote_data_source.dart';
import 'package:aurora_v1/features/device_dashboard/domain/repository/device_dashboard_repository.dart';

class DeviceDashboardRepositoryImpl implements DeviceDashboardRepository {
  final DeviceRemoteDataSource deviceRemoteDataSource;
  final DeviceSensorRemoteDataSource sensorRemoteDataSource;

  DeviceDashboardRepositoryImpl({
    required this.deviceRemoteDataSource,
    required this.sensorRemoteDataSource,
  });

  @override
  Future<String> getDeviceName(String plantId) {
    return deviceRemoteDataSource.getDeviceName(plantId);
  }

  @override
  Stream<SensorData?> streamSensorData(String deviceName) {
    return sensorRemoteDataSource.streamSensorData(deviceName);
  }
}
