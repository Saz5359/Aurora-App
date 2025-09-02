import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/plant.dart';

class PlantModel extends Plant {
  const PlantModel({
    required super.id,
    required super.plantName,
    required super.strain,
    required super.strainName1,
    required super.strainName2,
    required super.plantStage,
    required super.environment,
    required super.isDeviceConnected,
    required super.addedAt,
  });

  factory PlantModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PlantModel(
      id: doc.id,
      plantName: (data['plantName'] as String?) ?? '',
      strain: (data['strain'] as String?) ?? '',
      strainName1: (data['strainName1'] as String?) ?? '',
      strainName2: (data['strainName2'] as String?) ?? '',
      plantStage: (data['plantStage'] as String?) ?? '',
      environment: (data['environment'] as String?) ?? '',
      isDeviceConnected: (data['isDeviceConnected'] as bool?) ?? false,
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'plantName': plantName,
      'strain': strain,
      'strainName1': strainName1,
      'strainName2': strainName2,
      'plantStage': plantStage,
      'environment': environment,
      'isDeviceConnected': isDeviceConnected,
      'addedAt': addedAt,
    };
  }
}
