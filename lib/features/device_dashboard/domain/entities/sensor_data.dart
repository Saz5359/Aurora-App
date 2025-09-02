class SensorData {
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double uvIndex;
  final DateTime timestamp;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.uvIndex,
    required this.timestamp,
  });
}
