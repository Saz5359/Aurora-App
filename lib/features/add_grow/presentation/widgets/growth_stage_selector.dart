import 'package:flutter/material.dart';

class GrowthStageSelector extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onStageSelected;

  GrowthStageSelector({
    super.key,
    required this.selectedIndex,
    required this.onStageSelected,
  });

  final List<Map<String, String>> stages = [
    {
      'name': 'Seed',
      'duration': '3-10 Days',
      'image': 'assets/images/stage1.png'
    },
    {
      'name': 'Seedling',
      'duration': '2-3 Weeks',
      'image': 'assets/images/stage2.png'
    },
    {
      'name': 'Vegetative',
      'duration': '3-16 Weeks',
      'image': 'assets/images/stage3.png'
    },
    {
      'name': 'Flowering',
      'duration': '8-11 Weeks',
      'image': 'assets/images/stage4.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 170 / 242,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stages.length,
      itemBuilder: (context, index) {
        final stage = stages[index];
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onStageSelected(index),
          child: SizedBox(
            height: 208,
            width: 165,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.transparent,
                  width: 2.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      stage['image']!,
                      height: 110,
                      width: 165,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    // Ensures text can adjust dynamically
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          stage['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Duration',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF686777),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stage['duration']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF686777),
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
      },
    );
  }
}
