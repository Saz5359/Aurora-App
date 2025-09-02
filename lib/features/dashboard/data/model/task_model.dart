import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.estimatedCompletion,
    required super.completed,
    required super.assignedBy,
    required super.createdAt,
    required super.taskType,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TaskModel(
      id: doc.id,
      title: (data['title'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      dueDate: (data['dueDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      estimatedCompletion: (data['estimatedCompletion'] as String?) ?? '',
      completed: (data['completed'] as bool?) ?? false,
      assignedBy: (data['assignedBy'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      taskType: (data['taskType'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'estimatedCompletion': estimatedCompletion,
      'completed': completed,
      'assignedBy': assignedBy,
      'createdAt': createdAt,
      'taskType': taskType,
    };
  }
}
