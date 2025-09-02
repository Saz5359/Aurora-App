import 'package:flutter/material.dart';

class DeviceContainer extends StatelessWidget {
  final void Function()? onPressed;

  const DeviceContainer({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 173,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Image.asset(
              'assets/images/Device.png',
              height: 173,
              width: 172,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Let’s add your device',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF686777), fontSize: 14),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5EFD8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(0,
                        48), // Ensures height is fixed but width adjusts dynamically.
                  ),
                  onPressed: onPressed,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 14,
                          color: Color(0xFF686777),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Add Device",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF686777)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
