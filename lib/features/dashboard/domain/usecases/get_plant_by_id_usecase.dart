import 'package:aurora_v1/features/dashboard/domain/repository/dashboard_repository.dart';

import '../entities/plant.dart';

// Get a single Plant by its plantId.
class GetPlantByIdUseCase {
  final DashboardRepository repository;

  GetPlantByIdUseCase(this.repository);

  Stream<Plant> call(String plantId) {
    return repository.getPlantById(plantId);
  }
}
