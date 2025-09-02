import 'package:aurora_v1/core/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class StrainRemoteDataSource {
  Future<void> deletePlant(String plantId);
}

class StrainRemoteDataSourceImpl implements StrainRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  StrainRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  String get userId {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      AppLogger.warning("User ID is empty or null");
      throw Exception("User not authenticated");
    }
    return uid;
  }

  @override
  Future<void> deletePlant(String plantId) async {
    if (userId.isEmpty || plantId.isEmpty) {
      AppLogger.warning(
          "Validation failed: User ID and Plant ID are required.");
      throw Exception("User ID and Plant ID are required.");
    }

    try {
      await firestore
          .collection('plants')
          .doc(userId)
          .collection('userPlants')
          .doc(plantId)
          .delete();

      AppLogger.info("Plant deleted successfully: $plantId (User ID: $userId)");
    } catch (e, stackTrace) {
      AppLogger.error("Error deleting plant", error: e, stackTrace: stackTrace);
      throw Exception("Failed to delete plant: ${e.toString()}");
    }
  }
}
