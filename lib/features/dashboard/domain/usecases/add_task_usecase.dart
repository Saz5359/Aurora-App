import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';

class AddTaskUseCase {
  final DashboardRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call({
    required String plantId,
    required String title,
    required String description,
    required DateTime dueDate,
    required String estimatedCompletion,
    required String taskType,
  }) {
    return repository.addTask(
      plantId: plantId,
      title: title,
      description: description,
      dueDate: dueDate,
      estimatedCompletion: estimatedCompletion,
      taskType: taskType,
    );
  }
}
