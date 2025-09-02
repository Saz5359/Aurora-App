import 'package:flutter/material.dart';

class EnvironmentOptions extends StatelessWidget {
  final String label;
  final String description;
  final String imagePath;
  final bool isSelected;
  final bool isRecommended;
  final void Function()? onTap;

  const EnvironmentOptions(
      {super.key,
      required this.label,
      required this.description,
      required this.imagePath,
      required this.isSelected,
      required this.isRecommended,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 100,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(
            color: Color(0xFFF8F8FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 81,
                width: 81,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        if (isRecommended)
                          Flexible(
                            // <-- Wrap this in Flexible to prevent overflow
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10), // Adjusted padding
                              child: Text(
                                '*Recommended',
                                style: const TextStyle(
                                  color: Color(0xFFEF6363),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Prevent text from overflowing
                                softWrap:
                                    false, // Avoids wrapping, trims with ellipsis
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
