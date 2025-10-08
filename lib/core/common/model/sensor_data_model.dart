import 'package:aurora_v1/core/common/entities/sensor_data.dart';

class SensorDataModel extends SensorData {
  SensorDataModel({
    required super.temperature,
    required super.humidity,
    required super.soilMoisture,
    required super.uvIndex,
    required super.timestamp,
    required super.soilHumidity,
    required super.uvVoltage,
  });

  factory SensorDataModel.fromMap(
      Map<String, dynamic> map, DateTime timestamp) {
    return SensorDataModel(
      temperature: (map['Temperature']).toDouble(),
      humidity: (map['Humidity']).toDouble(),
      soilMoisture: (map['Soil_Moisture']).toDouble(),
      uvIndex: (map['UV_Index']).toDouble(),
      timestamp: timestamp,
      soilHumidity: (map['Soil_Humidity']).toDouble(),
      uvVoltage: (map['UV_Voltage']).toDouble(),
    );
  }
}
