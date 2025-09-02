import 'package:flutter/material.dart';

class TerpenesSelectors extends StatefulWidget {
  const TerpenesSelectors({super.key});

  @override
  State<TerpenesSelectors> createState() => _TerpenesSelectorsState();
}

class _TerpenesSelectorsState extends State<TerpenesSelectors> {
  // List of all options
  final List<String> options = [
    "Caryophyllene",
    "Humulene",
    "Limonene",
    "Linalool",
    "Myrcene",
    "Ocimene",
    "Pinene",
    "Terpinolene"
  ];

  // Set of selected options (for multi-selection)
  final Set<String> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Row(
            children: [
              // Custom Checkbox
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedOptions.remove(option);
                    } else {
                      selectedOptions.add(option);
                    }
                  });
                },
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      width: 2,
                    ),
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Option Label
              Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
