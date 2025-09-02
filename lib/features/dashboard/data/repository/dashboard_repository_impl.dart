import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';

import '../../domain/entities/plant.dart';
import '../../domain/entities/task.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Plant>> getPlants() {
    return remoteDataSource.getPlants();
  }

  @override
  Stream<Plant> getPlantById(String plantId) {
    return remoteDataSource.getPlantById(plantId);
  }

  @override
  Future<void> addTask({
    required String plantId,
    required String title,
    required String description,
    required DateTime dueDate,
    required String estimatedCompletion,
    required String taskType,
  }) {
    return remoteDataSource.addTask(
      plantId: plantId,
      title: title,
      description: description,
      dueDate: dueDate,
      estimatedCompletion: estimatedCompletion,
      taskType: taskType,
    );
  }

  @override
  Stream<List<Task>> getTasks(String plantId) {
    return remoteDataSource.getTasks(plantId);
  }

  @override
  Future<int> getPlantCount() {
    return remoteDataSource.getPlantCount();
  }

  @override
  Future<List<Task>> getTasksOnce(String plantId) {
    return remoteDataSource.getTasksOnce(plantId);
  }

  @override
  Future<void> completeTask(String plantId, String taskId) {
    return remoteDataSource.markTaskAsCompleted(
        plantId: plantId, taskId: taskId);
  }
}
