import 'package:flutter/material.dart';

class CompoundSelector extends StatefulWidget {
  const CompoundSelector({super.key});

  @override
  State<CompoundSelector> createState() => _CompoundSelectorState();
}

class _CompoundSelectorState extends State<CompoundSelector> {
  // Track the checked state and percentages for each compound
  final Map<String, bool> compoundSelected = {
    'THC': true,
    'CBD': false,
    'CBG': false,
    'CBN': false,
    'CBC': false,
  };
  final Map<String, double> compoundPercentages = {
    'THC': 21.0,
    'CBD': 0.0,
    'CBG': 0.0,
    'CBN': 0.0,
    'CBC': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: compoundSelected.keys.map((compound) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: compoundSelected[compound],
                onChanged: (bool? value) {
                  setState(() {
                    compoundSelected[compound] = value ?? false;
                  });
                },
              ),
              // Compound Name
              Text(
                compound,
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).colorScheme.primary),
              ),
              const Spacer(),
              // Show percentage controls only if the checkbox is selected
              if (compoundSelected[compound] == true)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (compoundPercentages[compound]! > 0) {
                            compoundPercentages[compound] =
                                compoundPercentages[compound]! - 1;
                          }
                        });
                      },
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text(
                        '${compoundPercentages[compound]!.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          if (compoundPercentages[compound]! < 100) {
                            compoundPercentages[compound] =
                                compoundPercentages[compound]! + 1;
                          }
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
