import 'package:aurora_v1/features/dashboard/domain/entities/task.dart';
import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';

class GetTasksOnceUseCase {
  final DashboardRepository _repository;

  GetTasksOnceUseCase(this._repository);

  Future<List<Task>> call(String plantId) {
    return _repository.getTasksOnce(plantId);
  }
}
