import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/core/widgets/wifi_tile.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class AddDeviceConnectWifi extends StatefulWidget {
  final PageController pageController;

  const AddDeviceConnectWifi({super.key, required this.pageController});

  @override
  State<AddDeviceConnectWifi> createState() => _AddDeviceConnectWifiState();
}

class _AddDeviceConnectWifiState extends State<AddDeviceConnectWifi> {
  List<WifiNetwork> availableWiFis = [];
  String? connectedSSID;
  String? _selectedSSID;
  String? _selectedPassword;
  // ignore: unused_field
  bool _isConnecting = false;
  bool _canProceed = false;
  bool _reconnectFailed = false;

  @override
  void initState() {
    super.initState();
    _loadWifiList();
    _getCurrentSSID();
  }

  Future<void> _getCurrentSSID() async {
    try {
      String? ssid = await WiFiForIoTPlugin.getSSID();
      setState(() {
        connectedSSID = ssid;
        _canProceed = ssid != null && ssid != "Aurora-Setup";
      });
    } catch (e) {
      print("Error getting current SSID: $e");
    }
  }

  Future<void> _loadWifiList() async {
    try {
      List<WifiNetwork>? networks = await WiFiForIoTPlugin.loadWifiList();
      final seenSsids = <String>{};
      final uniqueNetworks = networks
          .where((net) =>
              net.ssid != null &&
              net.ssid != "Aurora-Setup" &&
              net.ssid != connectedSSID &&
              seenSsids.add(net.ssid!))
          .toList();
      setState(() {
        availableWiFis = uniqueNetworks;
      });
    } catch (e) {
      print("Error loading wifi list: $e");
    }
  }

  Future<void> _sendWiFiCredentials(String? ssID, String? password) async {
    if (ssID == '' || password == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please select a WiFi network and enter a password.')),
      );
      return;
    }

    setState(() {
      _isConnecting = true;
      _reconnectFailed = false;
    });

    final url = 'http://192.168.4.1/save';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'ssid': ssID, 'password': password},
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();

        setState(() {
          _selectedSSID = ssID;
          connectedSSID = null;
        });

        await _waitForDeviceToDisconnect();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to configure WiFi. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to ESP32: $e')),
      );
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  Future<void> _waitForDeviceToDisconnect() async {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(seconds: 3));
      String? currentSSID = await WiFiForIoTPlugin.getSSID();

      if (currentSSID != null && currentSSID != "Aurora-Setup") {
        if (mounted) Navigator.of(context).pop(); // Close loading dialog
        print(
            "Device disconnected from Aurora-Setup and connected to $currentSSID");
        setState(() {
          _canProceed = true;
          connectedSSID = currentSSID;
        });
        await _loadWifiList();
        return;
      }
    }

    if (_selectedSSID != null && _selectedPassword != null) {
      bool success = await WiFiForIoTPlugin.connect(
        _selectedSSID!,
        password: _selectedPassword!,
        joinOnce: true,
        security: NetworkSecurity.WPA,
      );

      String? currentSSID = await WiFiForIoTPlugin.getSSID();
      if (success && currentSSID == _selectedSSID) {
        if (mounted) Navigator.of(context).pop(); // Close loading dialog
        setState(() {
          _canProceed = true;
          connectedSSID = currentSSID;
        });
        await _loadWifiList();
        return;
      }
    }

    setState(() {
      _reconnectFailed = true;
      _canProceed = false;
    });

    if (mounted) Navigator.of(context).pop(); // Close loading dialog

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Failed to reconnect. Try again or check your network.')),
    );
  }

  void _retryConnection() {
    if (_selectedSSID != null && _selectedPassword != null) {
      _sendWiFiCredentials(_selectedSSID, _selectedPassword);
    }
  }

  void _showPasswordDialog(WifiNetwork wifi) {
    final TextEditingController passwordController = TextEditingController();
    String errorMessage = '';
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        // A flag we can use to know if the dialog is still open
        bool dialogActive = true;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> submitCredentials() async {
              setState(() {
                isSubmitting = true;
                errorMessage = '';
              });

              String password = passwordController.text.trim();
              String? ssid = wifi.ssid;

              if (ssid != null && password.isNotEmpty) {
                final url = 'http://192.168.4.1/save';

                // Force bindings to the current Wi-Fi network interface:
                await WiFiForIoTPlugin.forceWifiUsage(true);
                try {
                  final response = await http.post(
                    Uri.parse(url),
                    body: {'ssid': ssid, 'password': password},
                  );

                  if (response.statusCode == 200) {
                    // Update main widget state after dialog is popped
                    if (mounted) {
                      Navigator.of(dialogContext).pop(); // Close dialog
                      dialogActive = false;

                      setState(() {
                        // This is safe now; it refers to the main widget
                        _selectedSSID = ssid;
                        connectedSSID = null;
                      });
                      _showLoadingDialog('Reconnecting to \n $ssid...');

                      await _waitForDeviceToDisconnect();
                    }
                  } else {
                    setState(() {
                      errorMessage = 'Invalid password. Please try again.';
                      isSubmitting = false;
                    });
                  }
                } catch (e) {
                  setState(() {
                    errorMessage = 'Connection failed: ${e.toString()}';
                  });
                } finally {
                  // only call setState if still active
                  if (dialogActive) {
                    setState(() {
                      isSubmitting = false;
                    });
                  }

                  // Always unbind afterwards so other traffic works correctly:
                  await WiFiForIoTPlugin.forceWifiUsage(false);
                }
              } else {
                setState(() {
                  errorMessage = 'Please enter a valid password.';
                  isSubmitting = false;
                });
              }
            }

            return AlertDialog(
              title: Text(
                wifi.ssid ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  if (isSubmitting)
                    const Text(
                      'Connecting...',
                      style: TextStyle(color: Colors.blue),
                    ),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.black, width: 0.7),
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0XFFF8F8FA),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0XFFF8F8FA),
                      ),
                      onPressed: isSubmitting ? null : submitCredentials,
                      child: const Text(
                        'Connect',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(24),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
          onBack: () => widget.pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
          title: 'Add Device'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configure Wifi',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              'You will need to connect the device to a Wifi network.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            if (connectedSSID != null && connectedSSID != "Aurora-Setup")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Connected Wi-Fi',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  WiFiTile(
                    name: connectedSSID!,
                    connected: true,
                    onTap: () => context.push(
                      "/add_device/config_wifi",
                      extra: connectedSSID,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Networks',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                GestureDetector(
                  onTap: _loadWifiList,
                  child: const Icon(
                    Icons.refresh,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: availableWiFis.length,
                itemBuilder: (context, index) {
                  final wifi = availableWiFis[index];
                  return WiFiTile(
                    name: wifi.ssid ?? 'Unknown',
                    connected: wifi.ssid == connectedSSID,
                    onTap: () => _showPasswordDialog(wifi),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: _reconnectFailed ? 'Retry' : 'Next',
                type: AppButtonType.confirm,
                onPressed: _canProceed
                    ? () => widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut)
                    : _reconnectFailed
                        ? _retryConnection
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
