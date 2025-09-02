import 'package:flutter/material.dart';

class GrowUnitCard extends StatelessWidget {
  final String unitName;
  final int batteryPercentage;
  final bool isConnected;
  final bool isSelected;
  final VoidCallback onSelect;

  const GrowUnitCard({
    super.key,
    required this.unitName,
    required this.batteryPercentage,
    required this.isConnected,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        constraints:
            const BoxConstraints(minHeight: 120), // Allow dynamic height.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF749A78), width: 2.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/addDevice.png',
              height:
                  120, // Ensure this matches the min height of the container.
              width: 106,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      unitName,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$batteryPercentage%',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isConnected)
                          const Text(
                            "Connected",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF8FB599),
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
