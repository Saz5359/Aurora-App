import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';
import '../entities/plant.dart';

// Get all plants for the current user.
class GetPlantsUseCase {
  final DashboardRepository repository;

  GetPlantsUseCase(this.repository);

  Stream<List<Plant>> call() {
    return repository.getPlants();
  }
}
