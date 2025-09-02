import 'package:aurora_v1/core/widgets/step_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StepAppBar(onBack: () => context.pop(), title: "Notifications"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Notifications",
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF04021D),
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "You have no notifications",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF686777),
                    fontWeight: FontWeight.w400),
              ),
            )
            /*Text(
              "New",
              style: TextStyle(fontSize: 14, color: Color(0xFF686777)),
            ),
            NotificationTile(
              heading: "Water Plants",
              description: "Water plants now",
              icon: Icons.water_drop_outlined,
            ),
            NotificationTile(
              heading: "Maximum temperature",
              description:
                  "Maximum temperature has been reached: Move plants to cooler area ",
              icon: Icons.thermostat_outlined,
            ),
            NotificationTile(
                heading: "Check for Pests",
                description:
                    "Remember to check for pests today: You can always run the diagnosis to help",
                icon: Icons.bug_report_outlined),
            SizedBox(
              height: 10,
            ),
            Text(
              "This Week",
              style: TextStyle(fontSize: 14, color: Color(0xFF686777)),
            ),
            NotificationTile(
              heading: "Sunny Day expected!",
              description:
                  "Today will be a good day to let your plants catch some sun!",
              icon: Icons.wb_sunny_outlined,
            ), */
          ],
        ),
      ),
    );
  }
}
