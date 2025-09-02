import '../entities/plant.dart';
import '../entities/task.dart';

/// Thrown when a failure occurs in the Dashboard feature.
class DashboardException implements Exception {
  final String message;
  DashboardException(this.message);
}

abstract class DashboardRepository {
  Stream<List<Plant>> getPlants();
  Stream<Plant> getPlantById(String plantId);

  Future<void> addTask({
    required String plantId,
    required String title,
    required String description,
    required DateTime dueDate,
    required String estimatedCompletion,
    required String taskType,
  });

  Stream<List<Task>> getTasks(String plantId);
  Future<int> getPlantCount();
  Future<List<Task>> getTasksOnce(String plantId);
  Future<void> completeTask(String plantId, String taskId);
}
