import 'package:aurora_v1/features/add_grow/domain/entities/grow.dart';

class GrowModel extends Grow {
  GrowModel({
    required super.plantName,
    required super.strain,
    required super.strainName1,
    required super.strainName2,
    required super.plantStage,
    required super.environment,
    required super.isHybrid,
  });

  /// Convert to Firestore map.
  Map<String, dynamic> toMap() {
    return {
      'plantName': plantName,
      'strain': strain,
      'strainName1': strainName1,
      'strainName2': strainName2,
      'plantStage': plantStage,
      'environment': environment,
      'isHybrid': isHybrid,
      'addedAt': DateTime.now(),
    };
  }
}
