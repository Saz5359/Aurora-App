/// Represents a single Task associated with a Plant.
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String estimatedCompletion;
  final bool completed;
  final String assignedBy;
  final DateTime createdAt;
  final String taskType;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.estimatedCompletion,
    required this.completed,
    required this.assignedBy,
    required this.createdAt,
    required this.taskType,
  });
}
