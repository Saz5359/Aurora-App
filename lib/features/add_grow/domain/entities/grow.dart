import 'package:cloud_firestore/cloud_firestore.dart';

class Grow {
  final String plantName;
  final String strain;
  final String strainName1;
  final String strainName2;
  final String plantStage;
  final String environment;
  final bool isHybrid;

  Grow({
    required this.plantName,
    required this.strain,
    required this.strainName1,
    required this.strainName2,
    required this.plantStage,
    required this.environment,
    required this.isHybrid,
  });

  /// Convert Firestore or any Map to a Grow object
  factory Grow.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Grow(
      plantName: (data['plantName'] as String?) ?? '',
      strain: (data['strain'] as String?) ?? '',
      strainName1: (data['strainName1'] as String?) ?? '',
      strainName2: (data['strainName2'] as String?) ?? '',
      plantStage: (data['plantStage'] as String?) ?? '',
      environment: (data['environment'] as String?) ?? '',
      isHybrid: (data['isHybrid'] as bool?) ?? false,
    );
  }

  /// Convert Grow object to Map (e.g. to save to Firestore)
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
