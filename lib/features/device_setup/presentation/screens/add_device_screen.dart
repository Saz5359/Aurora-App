import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_code.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_connect_wifi.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_connected.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_device_list.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_pairing_mode.dart';
import 'package:aurora_v1/features/device_setup/presentation/screens/add_device_successfully_connected.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddDeviceScreen extends StatefulWidget {
  final Plant grow;

  const AddDeviceScreen({super.key, required this.grow});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final PageController pageController = PageController();
  String? deviceId = '';

  void onCancel() => context.pop();

  void _onBack() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleDeviceSelect(String id) {
    setState(() {
      deviceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If not on first page, go back one step
        if ((pageController.page ?? 0) > 0) {
          _onBack();
          return false;
        }
        return true;
      },
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AddDevicePairingMode(
            pageController: pageController,
            onCancel: onCancel,
          ),
          AddDeviceCode(pageController: pageController),
          AddDeviceConnectWifi(pageController: pageController),
          AddDeviceDeviceList(
            pageController: pageController,
            onSelect: _handleDeviceSelect,
          ),
          AddDeviceConnected(
            pageController: pageController,
            deviceId: deviceId,
            growName: widget.grow.plantName,
          ),
          AddDeviceSuccessScreen(
            pageController: pageController,
            plantId: widget.grow.id,
            deviceId: deviceId ?? '',
          ),
        ],
      ),
    );
  }
}

/* 
AddDevicePairingMode(
          pageController: pageController,
          onCancel: onCancel,
        ),
        AddDeviceDeviceList(pageController: pageController),
        AddDeviceScanQr(pageController: pageController),
        AddDeviceCode(pageController: pageController),
        AddDeviceConnected(pageController: pageController),
        AddDeviceConnectWifi(pageController: pageController),
        AddDeviceSuccessfullyConnected(
            pageController: pageController, plantId: plantId),
 */
