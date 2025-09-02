class SensorData {
  final double humidity;
  final double soilHumidity;
  final double soilMoisture;
  final double temperature;
  final double uvIndex;
  final double uvVoltage;
  final DateTime timestamp;

  SensorData({
    required this.humidity,
    required this.soilHumidity,
    required this.soilMoisture,
    required this.temperature,
    required this.uvIndex,
    required this.uvVoltage,
    required this.timestamp,
  });
}
