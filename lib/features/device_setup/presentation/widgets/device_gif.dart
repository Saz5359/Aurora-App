import 'package:flutter/material.dart';

class DeviceGif extends StatelessWidget {
  const DeviceGif({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 292,
        maxWidth: 319,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(136, 136, 136, 1),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
    );
  }
}
