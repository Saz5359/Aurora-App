import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:location/location.dart';

class AddDeviceCode extends StatefulWidget {
  final PageController pageController;

  const AddDeviceCode({super.key, required this.pageController});

  @override
  State<AddDeviceCode> createState() => _AddDeviceCodeState();
}

class _AddDeviceCodeState extends State<AddDeviceCode> {
  bool isConnecting = true;
  String connectionStatus = "Searching for Aurora-Setup...";
  final Location location = Location();

  @override
  void initState() {
    super.initState();
    _checkLocationAndConnect();
  }

  Future<void> _checkLocationAndConnect() async {
    setState(() {
      isConnecting = true;
      connectionStatus = "Checking location permissions...";
    });

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          isConnecting = false;
          connectionStatus = "Location permission denied.";
        });
        return;
      }
    }

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      setState(() {
        connectionStatus = "Location is off. Please enable it.";
      });

      bool opened = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enable Location"),
          content: const Text(
              "Location is required to scan and connect to WiFi. Please enable location in your phone settings."),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () async {
                  await WiFiForIoTPlugin.forceWifiUsage(false);
                  await location.requestService();
                  Navigator.of(context).pop(true);
                },
                child: const Text("Open Settings")),
          ],
        ),
      );

      if (opened == true) {
        serviceEnabled = await location.serviceEnabled();
      }

      if (!serviceEnabled) {
        setState(() {
          isConnecting = false;
          connectionStatus = "Location service not enabled.";
        });
        return;
      }
    }

    _connectToAuroraSetup();
  }

  /// Scans for WiFi networks and returns a list of SSIDs that contain 'Aurora-Setup'.

  Future<void> _connectToAuroraSetup() async {
    setState(() {
      isConnecting = true;
      connectionStatus = "Connecting to Aurora-Setup...";
    });

    bool success = await WiFiForIoTPlugin.connect(
      "Aurora-Setup",
      password: "12345678",
      joinOnce: true,
      security: NetworkSecurity.WPA,
    );

    if (success) {
      setState(() {
        connectionStatus = "Connected to Aurora-Setup!";
        isConnecting = false;
      });

      widget.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        isConnecting = false;
        connectionStatus = "Failed to connect";
      });
    }
  }

  Future<void> _showRetryDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Connection Failed"),
        content: const Text(
            "Please ensure:\n\n• Your device is powered on\n• You are close to the device\n• Location is turned on"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkLocationAndConnect();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFailed = !isConnecting && connectionStatus == "Failed to connect";

    return Scaffold(
      appBar: StepAppBar(
        onBack: () => widget.pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        title: 'Add Device',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Connecting to WiFi",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.wifi, size: 100, color: Color(0xFF749A78)),
              const SizedBox(height: 20),
              Text(
                connectionStatus,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              isConnecting
                  ? const CircularProgressIndicator()
                  : connectionStatus == "Connected to Aurora-Setup!"
                      ? const Icon(Icons.check_circle,
                          color: Colors.green, size: 50)
                      : const Icon(Icons.error, color: Colors.red, size: 50),
              const SizedBox(height: 20),

              // Show Retry button on failure
              if (isFailed)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  onPressed: _showRetryDialog,
                ),

              const Spacer(),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
