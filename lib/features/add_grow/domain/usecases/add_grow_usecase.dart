import 'package:aurora_v1/features/add_grow/domain/repository/add_grow_repository.dart';

import '../entities/grow.dart';

class AddGrowUseCase {
  final AddGrowRepository repository;

  AddGrowUseCase(this.repository);

  Future<void> call(Grow grow) async {
    return repository.addGrow(grow);
  }
}
