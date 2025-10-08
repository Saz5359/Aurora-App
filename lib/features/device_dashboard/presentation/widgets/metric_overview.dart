import 'package:aurora_v1/core/common/entities/sensor_data.dart';
import 'package:aurora_v1/features/device_dashboard/presentation/widgets/metric_card.dart';
import 'package:flutter/material.dart';

class MetricOverview extends StatelessWidget {
  final SensorData? sensorData;
  final String Function(String, double) getStatusText;
  final Color Function(String, double) getStatusColor;

  const MetricOverview(
      {super.key,
      required this.sensorData,
      required this.getStatusText,
      required this.getStatusColor});

  @override
  Widget build(BuildContext context) {
    if (sensorData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        MetricCard(
          title: "Temperature",
          status: getStatusText("Temperature", sensorData!.temperature),
          value: "${sensorData!.temperature.toStringAsFixed(1)}°C",
          icon: Image.asset(
            "assets/images/degree.png",
            width: 31,
            height: 31,
          ),
          borderColor: getStatusColor("Temperature", sensorData!.temperature),
          backgroundColor: Colors.white,
          description: "Ideal temperature for growth is between 20°C and 30°C.",
        ),
        MetricCard(
          title: "UV Index",
          status: getStatusText("UV_Index", sensorData!.uvIndex),
          value: "${sensorData!.uvIndex.toStringAsFixed(0)}%",
          icon: Image.asset(
            "assets/images/rays.png",
            width: 31,
            height: 31,
          ),
          borderColor: getStatusColor("UV_Index", sensorData!.uvIndex),
          backgroundColor: Colors.white,
          isHighlighted: true,
          description: "UV levels are dangerously high. Provide shade!",
        ),
        MetricCard(
          title: "Humidity",
          status: getStatusText("Humidity", sensorData!.humidity),
          value: "${sensorData!.humidity.toStringAsFixed(0)}%",
          icon: Image.asset(
            "assets/images/humidity-icon.png",
            width: 31,
            height: 31,
          ),
          description:
              "The ideal cannabis flowering humidity is between 40% to 60%.",
          borderColor: getStatusColor("Humidity", sensorData!.humidity),
          backgroundColor: Colors.white,
          isHighlighted: true,
        ),
        MetricCard(
          title: "Soil Moisture",
          status: getStatusText("Soil_Moisture", sensorData!.soilMoisture),
          value: "${sensorData!.soilMoisture.toStringAsFixed(0)}%",
          icon: Image.asset(
            "assets/images/rain.png",
            width: 31,
            height: 31,
          ),
          borderColor:
              getStatusColor("Soil_Moisture", sensorData!.soilMoisture),
          backgroundColor: Colors.white,
          description:
              "The ideal soil moisture for flowering is between 40% to 60%.",
        ),
      ],
    );
  }
}
