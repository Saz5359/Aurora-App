import 'package:aurora_v1/core/common/entities/sensor_data.dart';

abstract class DeviceDashboardRepository {
  Future<String> getDeviceName(String plantId);
  Stream<SensorData?> streamSensorData(String deviceName);
}
