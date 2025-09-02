import 'package:aurora_v1/features/device_dashboard/data/model/sensor_data_model.dart';

abstract class DeviceDashboardRepository {
  Future<String> getDeviceName(String plantId);
  Stream<SensorDataModel?> streamSensorData(String deviceName);
}
