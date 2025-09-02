import '../../domain/entities/sensor_data.dart';

class SensorDataModel extends SensorData {
  SensorDataModel({
    required super.humidity,
    required super.soilHumidity,
    required super.soilMoisture,
    required super.temperature,
    required super.uvIndex,
    required super.uvVoltage,
    required super.timestamp,
  });

  factory SensorDataModel.fromMap(
      Map<String, dynamic> map, DateTime timestamp) {
    return SensorDataModel(
      humidity: (map['Humidity'] ?? 0).toDouble(),
      soilHumidity: (map['Soil_Humidity'] ?? 0).toDouble(),
      soilMoisture: (map['Soil_Moisture'] ?? 0).toDouble(),
      temperature: (map['Temperature'] ?? 0).toDouble(),
      uvIndex: (map['UV_Index'] ?? 0).toDouble(),
      uvVoltage: (map['UV_Voltage'] ?? 0).toDouble(),
      timestamp: timestamp,
    );
  }
}
