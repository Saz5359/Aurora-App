import 'package:aurora_v1/features/strain/domain/repository/strain_repository.dart';

class DeletePlantUseCase {
  final StrainRepository repository;

  DeletePlantUseCase({required this.repository});

  Future<void> call(String plantId) {
    return repository.deletePlant(plantId);
  }
}
