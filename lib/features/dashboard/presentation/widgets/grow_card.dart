import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/grow_actions_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GrowCard extends StatelessWidget {
  final String growName;
  final String percent;
  final double percentValue;
  final int devices;
  final bool isShared;
  final bool isDeviceConnected;
  final void Function(BuildContext context)? more;
  final void Function()? onTap;
  final Plant grow;

  const GrowCard({
    super.key,
    required this.growName,
    required this.percent,
    required this.percentValue,
    required this.devices,
    required this.isShared,
    this.more,
    required this.isDeviceConnected,
    this.onTap,
    required this.grow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          width: double.infinity, // Let the container take the full width
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Image.asset(
                "assets/images/strain.png",
                height: 157,
                width: double.infinity,
                fit: BoxFit.cover, // Ensures the image scales properly
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column for grow details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            growName,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary),
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
                          ),
                          const SizedBox(height: 5),
                          isDeviceConnected
                              ? Row(
                                  children: [
                                    grow.strain == "Custom"
                                        ? Container(
                                            height: 22,
                                            width: 62,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: const Color(0xFF686777),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Hybrid',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'THC 24% CBD 1%',
                                        style: TextStyle(
                                            color: Color(0xFF686777),
                                            fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          const SizedBox(height: 10),
                          isDeviceConnected
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.local_convenience_store_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Devices: $devices',
                                      style: const TextStyle(
                                          color: Color(0xFF686777),
                                          fontSize: 14),
                                    ),
                                  ],
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                    // Column for percent and actions
                    Column(
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            isDeviceConnected
                                ? CircularPercentIndicator(
                                    radius: 30,
                                    percent: percentValue,
                                    center: Text(
                                      percent,
                                      style: const TextStyle(
                                          color: Colors.lightGreen,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(width: 10),
                            Builder(
                              builder: (iconContext) {
                                return GestureDetector(
                                  onTap: () {
                                    final RenderBox renderBox = iconContext
                                        .findRenderObject() as RenderBox;
                                    final Offset offset =
                                        renderBox.localToGlobal(
                                      Offset(renderBox.size.width, 0),
                                    );

                                    if (more != null) {
                                      more!(iconContext);
                                    }

                                    GrowActionsPopupMenu.show(
                                      context: iconContext,
                                      position: offset,
                                      grow: grow,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (isShared)
                          Row(
                            children: [
                              Icon(
                                Icons.diversity_3,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "Shared",
                                style: TextStyle(
                                    color: Color(0xFF686777), fontSize: 14),
                              ),
                            ],
                          ),
                      ],
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
