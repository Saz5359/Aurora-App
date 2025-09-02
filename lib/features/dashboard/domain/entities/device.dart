class Device {
  final String id;
  final String deviceName;
  final DateTime registeredAt;
  final String userId;
  final String growName;

  const Device({
    required this.id,
    required this.deviceName,
    required this.registeredAt,
    required this.userId,
    required this.growName,
  });
}
