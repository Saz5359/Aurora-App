import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:aurora_v1/features/device_dashboard/data/model/sensor_data_model.dart';
import 'package:aurora_v1/features/device_dashboard/presentation/bloc/device_dashboard_bloc.dart';
import 'package:aurora_v1/features/device_dashboard/presentation/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DeviceDashScreen extends StatefulWidget {
  final String growName;
  final String plantId;
  const DeviceDashScreen(
      {super.key, required this.growName, required this.plantId});

  @override
  State<DeviceDashScreen> createState() => _DeviceDashScreenState();
}

class _DeviceDashScreenState extends State<DeviceDashScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() => setState(() {}));
    context
        .read<DeviceDashboardBloc>()
        .add(StartSensorDataStream(widget.plantId));
  }

  String _getTabKey(int index) {
    switch (index) {
      case 1:
        return "UV_Index";
      case 2:
        return "Humidity";
      case 3:
        return "Soil_Moisture";
      case 4:
        return "Temperature";
      default:
        return "Overview";
    }
  }

  String _getStatusText(String key, double value) {
    if (key == "Temperature") {
      return value < 15
          ? "Too Cold"
          : value > 30
              ? "Too Hot"
              : "Good";
    } else if (key == "Humidity") {
      return value < 40
          ? "Dry"
          : value > 70
              ? "Too Humid"
              : "Good";
    } else if (key == "UV_Index") {
      return value > 7 ? "Too High" : "Safe";
    } else if (key == "Soil_Moisture") {
      return value < 20
          ? "Thirsty"
          : value > 80
              ? "Overwatered"
              : "Good";
    } else if (key == "Overview") {
      return calculatePlantHealth();
    }
    return "Loading";
  }

  Color _getStatusColor(String key, double value) {
    if (key == "Temperature") {
      return value < 15
          ? Colors.blue
          : value > 30
              ? Colors.red
              : Colors.green;
    } else if (key == "Humidity") {
      return value < 40 || value > 70 ? Colors.red : Colors.blue;
    } else if (key == "UV_Index") {
      return value > 7 ? Colors.red : Colors.green;
    } else if (key == "Soil_Moisture") {
      return value < 20 || value > 80 ? Colors.red : Colors.green;
    } else if (key == "Overview") {
      return calculatePlantHealth() == 'Excellent'
          ? Colors.green
          : calculatePlantHealth() == 'Good'
              ? Colors.lightGreen
              : calculatePlantHealth() == 'Moderate'
                  ? Colors.orange
                  : Colors.red;
    }
    return Colors.grey;
  }

  String calculatePlantHealth() {
    final state = context.watch<DeviceDashboardBloc>().state;
    SensorDataModel? data;
    if (state is DeviceDashboardLoaded) {
      data = state.sensorData;
    }

    if (data == null) {
      AppLogger.info("Sensor data is null, cannot calculate health.");
      return 'Loading';
    }

    final List<String> statuses = [
      _getStatusText("Soil_Moisture", data.soilMoisture),
      _getStatusText("UV_Index", data.uvIndex),
      _getStatusText("Temperature", data.temperature),
      _getStatusText("Humidity", data.humidity),
    ];

    int goodCount = 0;
    int moderateCount = 0;
    // ignore: unused_local_variable
    int poorCount = 0;

    for (final status in statuses) {
      if (_isGood(status)) {
        goodCount++;
      } else if (_isModerate(status)) {
        moderateCount++;
      } else {
        poorCount++;
      }
    }

    if (goodCount == 4) return 'Excellent';
    if (goodCount >= 2 && moderateCount >= 2) return 'Good';
    if (moderateCount >= 2) return 'Moderate';
    return 'Poor';
  }

  bool _isGood(String status) {
    return status == 'Good' || status == 'Safe';
  }

  bool _isModerate(String status) {
    return [
      'Dry',
      'Too Humid',
      'Too Cold',
      'Too Hot',
      'Thirsty',
      'Overwatered',
    ].contains(status);
  }

  double calculateHealthPercent(SensorDataModel? data) {
    if (data == null) {
      AppLogger.info("Sensor data is null, cannot calculate health percent.");
      return 0.0;
    }

    AppLogger.info("Calculating health percent with data: $data");
    final List<String> statuses = [
      _getStatusText("Soil_Moisture", data.soilMoisture),
      _getStatusText("UV_Index", data.uvIndex),
      _getStatusText("Temperature", data.temperature),
      _getStatusText("Humidity", data.humidity),
    ];

    final totalScore =
        statuses.map((s) => _getHealthScore(s)).reduce((a, b) => a + b);
    return (totalScore / statuses.length).clamp(0.0, 1.0);
  }

  double _getHealthScore(String status) {
    if (status == 'Good' || status == 'Safe') {
      return 0.75;
    } else if ([
      'Too Cold',
      'Too Hot',
      'Dry',
      'Too Humid',
      'Thirsty',
      'Overwatered',
    ].contains(status)) {
      return 0.5;
    } else {
      return 0.0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceDashboardBloc, DeviceDashboardState>(
      listener: (context, state) {
        if (state is DeviceDashboardError) {
          showAppErrorSnackBar(context,
              message: state.message, errorType: state.errorType);
        }
      },
      builder: (context, state) {
        if (state is DeviceDashboardLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          );
        }

        final blocState = context.watch<DeviceDashboardBloc>().state;
        SensorDataModel? data;
        if (blocState is DeviceDashboardLoaded) {
          data = blocState.sensorData;
        }

        AppLogger.info(
            "Current tab index: ${_tabController.index}, data: $data: ${data?.temperature}");

        // Compute your progress values here, feeding in `data`
        final key = _getTabKey(_tabController.index);
        final num rawValue = {
          "Temperature": data?.temperature ?? 0,
          "Humidity": data?.humidity ?? 0,
          "UV_Index": data?.uvIndex ?? 0,
          "Soil_Moisture": data?.soilMoisture ?? 0,
          "Overview": data != null ? 50 : 10,
          calculateHealthPercent(data) * 100: 0,
        }[key]!;
        final value = rawValue.clamp(0.0, 100.0);
        final progress = value / 100;

        return Scaffold(
          appBar: DashboardAppBar(
            title: Image.asset(
              "assets/images/dash.png",
              height: 32,
              width: 104,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(0xFFAFCEB2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Device",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Grow Day: 23",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Seedling",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF686777)),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 12,
                            width: 11,
                            decoration: BoxDecoration(
                              color: const Color(0xFF749A78),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          const Text(
                            " Device Online",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF686777)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 20.0,
                      percent: progress,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            key == "Temperature"
                                ? "${rawValue.toStringAsFixed(1)}°C"
                                : "${rawValue.toStringAsFixed(0)}%",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color:
                                    _getStatusColor(key, rawValue.toDouble())),
                          ),
                          Text(
                            _getStatusText(key, rawValue.toDouble()),
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF686777)),
                          ),
                        ],
                      ),
                      progressColor: _getStatusColor(key, rawValue.toDouble()),
                      backgroundColor: Colors.grey[300]!,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1000,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    key,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF686777),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.green,
                      indicatorWeight: 3,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                      tabs: [
                        Tab(icon: Image.asset("assets/images/Leaf.png")),
                        Tab(icon: Image.asset("assets/images/rays.png")),
                        Tab(
                            icon:
                                Image.asset("assets/images/humidity-icon.png")),
                        Tab(icon: Image.asset("assets/images/rain.png")),
                        Tab(icon: Image.asset("assets/images/degree.png")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 1000,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildMetricsOverview(
                            data, _getStatusText, _getStatusColor),
                        _buildTabContent(
                            "UV Light",
                            "Ideal Light: Moderate",
                            "assets/images/grow.png",
                            "At this stage, your plants have not yet established their root systems. Creating a high-humidity environment in your nursery or clone room will reduce transpiration through the leaves and take the pressure off the immature root systems, allowing the root system to catch up before ramping up VPD and transpiration.\nMany growers opt to start clones and seedlings in mother or veg rooms, in which case they may use plastic humidity domes to help retain moisture (and in some cases heat), allowing them to share space with more mature plants without similar environmental constraints. However, if you use these domes, ensure they have proper ventilation to prevent building up too much moisture and to ensure exchange of CO2."),
                        _buildTabContent(
                            "Humidity",
                            "Ideal Humidity: 65-80%",
                            "assets/images/grow.png",
                            "At this stage, your plants have not yet established their root systems. Creating a high-humidity environment in your nursery or clone room will reduce transpiration through the leaves and take the pressure off the immature root systems, allowing the root system to catch up before ramping up VPD and transpiration.\nMany growers opt to start clones and seedlings in mother or veg rooms, in which case they may use plastic humidity domes to help retain moisture (and in some cases heat), allowing them to share space with more mature plants without similar environmental constraints. However, if you use these domes, ensure they have proper ventilation to prevent building up too much moisture and to ensure exchange of CO2."),
                        _buildTabContent(
                            "Soil",
                            "Ideal Soil Level: Sufficient",
                            "assets/images/grow.png",
                            "At this stage, your plants have not yet established their root systems. Creating a high-humidity environment in your nursery or clone room will reduce transpiration through the leaves and take the pressure off the immature root systems, allowing the root system to catch up before ramping up VPD and transpiration.\nMany growers opt to start clones and seedlings in mother or veg rooms, in which case they may use plastic humidity domes to help retain moisture (and in some cases heat), allowing them to share space with more mature plants without similar environmental constraints. However, if you use these domes, ensure they have proper ventilation to prevent building up too much moisture and to ensure exchange of CO2."),
                        _buildTabContent(
                            "Temperature",
                            "Ideal Temperature: 22-28°C",
                            "assets/images/grow.png",
                            "At this stage, your plants have not yet established their root systems. Creating a high-humidity environment in your nursery or clone room will reduce transpiration through the leaves and take the pressure off the immature root systems, allowing the root system to catch up before ramping up VPD and transpiration.\nMany growers opt to start clones and seedlings in mother or veg rooms, in which case they may use plastic humidity domes to help retain moisture (and in some cases heat), allowing them to share space with more mature plants without similar environmental constraints. However, if you use these domes, ensure they have proper ventilation to prevent building up too much moisture and to ensure exchange of CO2."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildTabContent(
    String title, String description, String imagePath, String data) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 20),
      Text(
        'Seedling: $title',
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(height: 10),
      Text(
        description,
        style: const TextStyle(fontSize: 16, color: Color(0xFF686777)),
      ),
      const SizedBox(height: 10),
      Image.asset(
        imagePath,
        height: 301,
        width: 349,
      ),
      const SizedBox(height: 20),
      RichText(
        text: TextSpan(
          text: data,
          style: const TextStyle(fontSize: 16, color: Color(0xFF686777)),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget _buildMetricsOverview(
    SensorDataModel? sensorData, getStatusText, getStatusColor) {
  if (sensorData == null) {
    return const Center(child: CircularProgressIndicator());
  }
  AppLogger.info("Current data: ${sensorData.temperature}");

  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      MetricCard(
        title: "Temperature",
        status: getStatusText("Temperature", sensorData.temperature),
        value: "${sensorData.temperature.toStringAsFixed(1)}°C",
        icon: Image.asset(
          "assets/images/degree.png",
          width: 31,
          height: 31,
        ),
        borderColor: getStatusColor("Temperature", sensorData.temperature),
        backgroundColor: Colors.white,
        description: "Ideal temperature for growth is between 20°C and 30°C.",
      ),
      MetricCard(
        title: "UV Index",
        status: getStatusText("UV_Index", sensorData.uvIndex),
        value: "${sensorData.uvIndex.toStringAsFixed(0)}%",
        icon: Image.asset(
          "assets/images/rays.png",
          width: 31,
          height: 31,
        ),
        borderColor: getStatusColor("UV_Index", sensorData.uvIndex),
        backgroundColor: Colors.white,
        isHighlighted: true,
        description: "UV levels are dangerously high. Provide shade!",
      ),
      MetricCard(
        title: "Humidity",
        status: getStatusText("Humidity", sensorData.humidity),
        value: "${sensorData.humidity.toStringAsFixed(0)}%",
        icon: Image.asset(
          "assets/images/humidity-icon.png",
          width: 31,
          height: 31,
        ),
        description:
            "The ideal cannabis flowering humidity is between 40% to 60%.",
        borderColor: getStatusColor("Humidity", sensorData.humidity),
        backgroundColor: Colors.white,
        isHighlighted: true,
      ),
      MetricCard(
        title: "Soil Moisture",
        status: getStatusText("Soil_Moisture", sensorData.soilMoisture),
        value: "${sensorData.soilMoisture.toStringAsFixed(0)}%",
        icon: Image.asset(
          "assets/images/rain.png",
          width: 31,
          height: 31,
        ),
        borderColor: getStatusColor("Soil_Moisture", sensorData.soilMoisture),
        backgroundColor: Colors.white,
        description:
            "The ideal soil moisture for flowering is between 40% to 60%.",
      ),
    ],
  );
}
