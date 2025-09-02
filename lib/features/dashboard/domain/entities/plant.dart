class Plant {
  final String id;
  final String plantName;
  final String strain;
  final String strainName1;
  final String strainName2;
  final String plantStage;
  final String environment;
  final bool isDeviceConnected;
  final DateTime addedAt;

  const Plant({
    required this.isDeviceConnected,
    required this.id,
    required this.plantName,
    required this.strain,
    required this.strainName1,
    required this.strainName2,
    required this.plantStage,
    required this.environment,
    required this.addedAt,
  });
}
