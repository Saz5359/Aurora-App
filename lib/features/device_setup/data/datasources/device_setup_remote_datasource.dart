import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/logger.dart';
import '../../../device_setup/domain/entities/device_connection.dart';

abstract class DeviceSetupRemoteDataSource {
  Future registerDevice(DeviceConnection connection);
}

class DeviceSetupRemoteDataSourceImpl implements DeviceSetupRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth = FirebaseAuth.instance;

  DeviceSetupRemoteDataSourceImpl({required this.firestore});

  String get userId {
    final uid = auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not authenticated');
    }
    return uid;
  }

  @override
  Future<void> registerDevice(DeviceConnection connection) async {
    AppLogger.info(
        'Registering device: ${connection.deviceName} for plant: ${connection.plantId}');
    try {
      final firestoreDocRef = firestore
          .collection('plants')
          .doc(userId)
          .collection('userPlants')
          .doc(connection.plantId);

      // 1. Update Firestore plant info
      await firestoreDocRef.update({
        'isDeviceConnected': connection.isConnected,
        'deviceName': connection.deviceName,
      });
    } catch (e, st) {
      AppLogger.error('❌ Failed to register device', error: e, stackTrace: st);
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
}
