import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/device.dart';

/// Same fields as the domain `Device`, but used in data layer.
class DeviceModel extends Device {
  const DeviceModel({
    required super.id,
    required super.deviceName,
    required super.registeredAt,
    required super.userId,
    required super.growName,
  });

  factory DeviceModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DeviceModel(
      id: doc.id,
      deviceName: (data['deviceName'] as String?) ?? '',
      registeredAt:
          (data['registeredAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: (data['userId'] as String?) ?? '',
      growName: (data['growName'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'deviceName': deviceName,
      'registeredAt': registeredAt,
      'userId': userId,
      'growName': growName,
    };
  }
}
