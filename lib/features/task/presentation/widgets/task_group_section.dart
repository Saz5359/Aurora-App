import 'package:aurora_v1/core/widgets/task_card.dart';
import 'package:aurora_v1/features/task/presentation/widgets/task_selector.dart';
import 'package:flutter/material.dart';

class TaskGroupSection extends StatelessWidget {
  final String title;
  final int totalTasks;
  final int completedTasks;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<TaskCard> tasks;

  const TaskGroupSection({
    super.key,
    required this.title,
    required this.totalTasks,
    required this.completedTasks,
    required this.isExpanded,
    required this.onToggle,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return TaskSelector(
      title: title,
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      isExpanded: isExpanded,
      onTap: onToggle,
      children: isExpanded ? tasks : [],
    );
  }
}
