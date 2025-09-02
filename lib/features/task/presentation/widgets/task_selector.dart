import 'package:flutter/material.dart';

class TaskSelector extends StatefulWidget {
  final String title;
  final int totalTasks;
  final int completedTasks;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<Widget> children;

  const TaskSelector(
      {super.key,
      required this.title,
      required this.isExpanded,
      required this.onTap,
      required this.children,
      required this.totalTasks,
      required this.completedTasks});

  @override
  State<TaskSelector> createState() => _TaskSelectorState();
}

class _TaskSelectorState extends State<TaskSelector> {
  @override
  Widget build(BuildContext context) {
    final progressValue =
        widget.totalTasks > 0 ? widget.completedTasks / widget.totalTasks : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Row(
              children: [
                Icon(
                  widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 30,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF686777)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "${widget.completedTasks}/${widget.totalTasks} Tasks Completed",
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF686777)),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: progressValue,
            minHeight: 2,
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF686777),
            backgroundColor: const Color(0xFFD3D3D3),
          ),
          if (widget.isExpanded) ...widget.children,
        ],
      ),
    );
  }
}
