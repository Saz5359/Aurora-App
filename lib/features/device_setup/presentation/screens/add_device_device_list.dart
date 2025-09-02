import 'package:aurora_v1/core/widgets/app_button.dart';
import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:aurora_v1/features/device_setup/presentation/widgets/grow_unit_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddDeviceDeviceList extends StatefulWidget {
  final PageController pageController;
  final Function(String) onSelect;

  const AddDeviceDeviceList({
    super.key,
    required this.pageController,
    required this.onSelect,
  });

  @override
  State<AddDeviceDeviceList> createState() => _AddDeviceDeviceListState();
}

class _AddDeviceDeviceListState extends State<AddDeviceDeviceList> {
  String? _selectedDeviceId;

  Stream<List<Map<String, dynamic>>> getPendingDevicesStream() {
    final ref = FirebaseDatabase.instance.ref('devices');

    return ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.entries
          .where((entry) =>
              (entry.value['status'] ?? '') == 'pending' && entry.key is String)
          .map((entry) {
        final value = entry.value as Map;
        return {
          'deviceId': entry.key,
          'battery': value['battery'] ?? 85,
          'name': entry.key,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(
        onBack: () => widget.pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        title: "Add Device",
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Devices found!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Select the device you would like to setup",
                    style: TextStyle(color: Color(0xFF686777), fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: getPendingDevicesStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ));
                      }

                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Error: ${snapshot.error.toString()}"));
                      }

                      final devices = snapshot.data ?? [];

                      if (devices.isEmpty) {
                        return const Center(
                            child: Text("No unregistered devices found."));
                      }

                      return ListView.builder(
                        itemCount: devices.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final device = devices[index];

                          final deviceId = device['deviceId'] as String;
                          final battery = device['battery'] ?? 85;
                          final name = 'GrowUnit ${deviceId.substring(7, 10)}';

                          final isSelected = _selectedDeviceId == deviceId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GrowUnitCard(
                              unitName: name,
                              batteryPercentage: battery,
                              isConnected: false,
                              isSelected: isSelected,
                              onSelect: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedDeviceId = null;
                                    widget.onSelect("");
                                  } else {
                                    _selectedDeviceId = deviceId;
                                    widget.onSelect(deviceId);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: "Next",
                  onPressed: _selectedDeviceId != null
                      ? () => widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  type: AppButtonType.confirm,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



/////////////////////////////////////////////////////// Original Code ///////////////////////////////////////////////////////
/* import 'package:aurora_demo_app/core/widgets/custom_app_bar.dart';
import 'package:aurora_demo_app/core/widgets/custom_button.dart';
import 'package:aurora_demo_app/features/add_device/presentation/widgets/grow_unit_card.dart';
import 'package:flutter/material.dart';

class AddDeviceDeviceList extends StatefulWidget {
  final PageController pageController;

  const AddDeviceDeviceList({super.key, required this.pageController});

  @override
  State<AddDeviceDeviceList> createState() => _AddDeviceDeviceListState();
}

class _AddDeviceDeviceListState extends State<AddDeviceDeviceList> {
  int? _selectedUnitId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          navigateBack: () => widget.pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
          title: "Add Device"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Multiple devices found!",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            text: "Select the device you would like to setup",
                            style: TextStyle(
                                color: Color(0xFF686777), fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GrowUnitCard(
                        unitName: "GrowUnit746",
                        batteryPercentage: 59,
                        isConnected: true,
                        isSelected: _selectedUnitId == 746,
                        onSelect: () {
                          setState(() {
                            _selectedUnitId =
                                (_selectedUnitId == 746) ? null : 746;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      GrowUnitCard(
                        unitName: "GrowUnit524",
                        batteryPercentage: 59,
                        isConnected: true,
                        isSelected: _selectedUnitId == 524,
                        onSelect: () {
                          setState(() {
                            _selectedUnitId =
                                (_selectedUnitId == 524) ? null : 524;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      CustomButton(
                          label: "Next",
                          onPressed: () => widget.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut),
                          type: ButtonType.confirm)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
 */