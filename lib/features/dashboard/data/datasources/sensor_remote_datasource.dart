import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/dashboard/data/model/sensor_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sensor_data.dart';

/// Thrown when Remote Sensor DataSource encounters an error.
class SensorRemoteDataSourceException implements Exception {
  final String message;
  SensorRemoteDataSourceException(this.message);
}

class SensorRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseDatabase _database;
  final FirebaseAuth _auth;

  SensorRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseDatabase? database,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _database = database ?? FirebaseDatabase.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get userId {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      AppLogger.warning("SensorRemoteDataSource: userId is null");
      throw SensorRemoteDataSourceException("User not authenticated");
    }
    return uid;
  }

  // Fetches the device ID for a given grow name.
  Future<String?> getDeviceIdForGrow({required String growName}) async {
    try {
      final devicesRef =
          _firestore.collection('devices').doc(userId).collection(userId);
      final querySnapshot = await devicesRef
          .where('growName', isEqualTo: growName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
      return null;
    } catch (e, st) {
      AppLogger.error("Error in getDeviceIdForGrow: $e",
          error: e, stackTrace: st);
      throw SensorRemoteDataSourceException("Failed to getDeviceIdForGrow: $e");
    }
  }

  Stream<SensorData?> streamLatestSensorData(String deviceId) {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final path = '$deviceId/monitoring/$today';
      final ref = _database.ref().child(path);

      return ref.onValue.map((event) {
        final raw = event.snapshot.value as Map<dynamic, dynamic>?;
        if (raw == null || raw.isEmpty) return null;

        final sortedKeys = raw.keys.toList()
          ..sort((a, b) => a.toString().compareTo(b.toString()));
        final latestKey = sortedKeys.last;
        final latestData = Map<String, dynamic>.from(raw[latestKey]);
        final timestamp = DateTime.parse(latestKey.replaceAll('-', ':'));
        return SensorDataModel.fromMap(latestData, timestamp);
      });
    } catch (e, st) {
      AppLogger.error("Error in streamLatestSensorData: $e",
          error: e, stackTrace: st);
      throw SensorRemoteDataSourceException("Failed to stream sensor data: $e");
    }
  }
}
