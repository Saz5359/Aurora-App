import 'package:flutter/material.dart';

class NoDevicePopup extends StatelessWidget {
  final VoidCallback? onMoreDetails;
  final VoidCallback? onOpenShop;

  const NoDevicePopup({super.key, this.onMoreDetails, this.onOpenShop});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16), // Padding from screen edges
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 9 / 19.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/images/Pop-Up.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
