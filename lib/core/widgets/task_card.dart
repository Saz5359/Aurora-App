import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final bool urgent;
  final String status;
  final String taskType;
  final String title;
  final String description;
  final String duration;
  final VoidCallback onTap;
  final void Function()? seeMore;
  final void Function()? openTask;

  const TaskCard(
      {super.key,
      required this.urgent,
      required this.status,
      required this.title,
      required this.description,
      required this.duration,
      required this.onTap,
      this.seeMore,
      this.openTask,
      required this.taskType});

  Color _getStatusColor() {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Overdue':
        return Colors.red;
      case 'Due Today':
        return Colors.orange;
      case 'Due Date Upcoming':
        return Colors.blue;
      default:
        return const Color.fromARGB(255, 219, 219, 219);
    }
  }

  Color _getTaskTypeColor() {
    switch (taskType) {
      case 'Seasonal':
        return Colors.orange;
      case 'Tutorial':
        return Colors.green;
      case 'Daily':
        return Colors.blue;
      case 'Upcoming':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: _getStatusColor()),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 200, 199, 199),
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 1.5),
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status,
              style: TextStyle(
                  color: status == 'Running'
                      ? const Color(0xFF749A78)
                      : _getStatusColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 50,
                  color: _getTaskTypeColor(),
                  margin: const EdgeInsets.only(right: 8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      Text(
                        description,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: seeMore, child: const Icon(Icons.more_vert)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.grey,
                ),
                Text(
                  duration,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: openTask,
                  child: const Text(
                    "Open Task",
                    style: TextStyle(
                        color: Color(0xFF749A78),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
