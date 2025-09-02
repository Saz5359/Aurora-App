import 'package:flutter/material.dart';

class DeviceItem extends StatelessWidget {
  final IconData deviceIcon; // Icon for the device
  final String deviceName; // Name of the device
  final IconData signalIcon; // Icon for Wi-Fi signal
  final String percentage; // Battery or signal percentage
  final Color percentageColor; // Color of the percentage text

  const DeviceItem({
    super.key,
    required this.deviceIcon,
    required this.deviceName,
    required this.signalIcon,
    required this.percentage,
    required this.percentageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                deviceIcon,
                size: 24,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Text(
                deviceName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                signalIcon,
                size: 20,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: percentageColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: percentageColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
