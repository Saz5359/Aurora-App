import 'package:aurora_v1/core/common/model/sensor_data_model.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class DeviceSensorRemoteDataSource {
  Stream<SensorDataModel?> streamSensorData(String deviceName);
}

class SensorRemoteDataSourceImpl implements DeviceSensorRemoteDataSource {
  final FirebaseDatabase database;

  SensorRemoteDataSourceImpl(this.database);

  @override
  Stream<SensorDataModel?> streamSensorData(String deviceName) {
    final baseRef = database.ref('$deviceName/monitoring');

    return baseRef.onValue.asyncMap((event) async {
      if (!event.snapshot.exists) return null;

      final dateSnapshots = event.snapshot.children.toList();
      if (dateSnapshots.isEmpty) return null;

      dateSnapshots.sort((a, b) => b.key!.compareTo(a.key!));
      final latestDateSnapshot = dateSnapshots.first;

      final timeSnapshots = latestDateSnapshot.children.toList();
      if (timeSnapshots.isEmpty) return null;

      timeSnapshots.sort((a, b) => b.key!.compareTo(a.key!));
      final latestTimeSnapshot = timeSnapshots.first;

      final date = latestDateSnapshot.key!;
      final time = latestTimeSnapshot.key!;

      final timestamp = DateTime.tryParse('$date $time'.replaceAll('-', ':')) ??
          DateTime.now();
      final dataMap =
          Map<String, dynamic>.from(latestTimeSnapshot.value as Map);

      return SensorDataModel.fromMap(dataMap, timestamp);
    });
  }
}
