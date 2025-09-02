import 'package:aurora_v1/core/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DeviceRemoteDataSource {
  Future<String> getDeviceName(String plantId);
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final FirebaseFirestore firestore;
  final _firebaseAuth = FirebaseAuth.instance;

  DeviceRemoteDataSourceImpl(this.firestore);

  /// **Get Current User ID**
  String get userId {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      AppLogger.warning("User ID is empty or null");
      throw Exception("User not authenticated");
    }
    return uid;
  }

  @override
  Future<String> getDeviceName(String plantId) async {
    final doc = await firestore
        .collection('plants')
        .doc(userId)
        .collection('userPlants')
        .doc(plantId)
        .get();
    if (!doc.exists || !doc.data()!.containsKey('deviceName')) {
      throw Exception('Device name not found');
    }
    return doc['deviceName'];
  }
}
