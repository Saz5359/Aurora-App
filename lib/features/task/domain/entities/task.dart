import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String plantId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String estimatedTime;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.plantId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.estimatedTime,
    required this.isCompleted,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      plantId: map['plantId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] ?? '',
      estimatedTime: map['estimatedTime'] ?? '',
      isCompleted: map['isCompleted'] ?? '',
    );
  }

  /// Convert Grow object to Map (e.g. to save to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'estimatedTime': estimatedTime,
      'isCompleted': isCompleted,
    };
  }

  @override
  List<Object> get props =>
      [id, plantId, title, description, dueDate, estimatedTime, isCompleted];
}
