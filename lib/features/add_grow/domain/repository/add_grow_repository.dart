import 'package:aurora_v1/features/add_grow/domain/entities/grow.dart';

abstract class AddGrowRepository {
  Future<void> addGrow(Grow grow);
}
