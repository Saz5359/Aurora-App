import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';

class CompleteTaskUseCase {
  final DashboardRepository repository;

  CompleteTaskUseCase(this.repository);

  Future<void> call(String plantId, String taskId) {
    return repository.completeTask(plantId, taskId);
  }
}
