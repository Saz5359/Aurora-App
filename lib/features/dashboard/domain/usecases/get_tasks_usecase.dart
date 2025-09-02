import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';

import '../entities/task.dart';

class GetTasksUseCase {
  final DashboardRepository repository;

  GetTasksUseCase(this.repository);

  Stream<List<Task>> call(String plantId) {
    return repository.getTasks(plantId);
  }
}
