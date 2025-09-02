import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';

// Get the total count of Plants for current user.
class GetPlantCountUseCase {
  final DashboardRepository repository;

  GetPlantCountUseCase(this.repository);

  Future<int> call() {
    return repository.getPlantCount();
  }
}
