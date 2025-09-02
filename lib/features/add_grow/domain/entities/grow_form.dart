// Holds grow data collected from the 5 add grow screens.
class GrowForm {
  final String? plantName;
  final String? strain;
  final String? strainName1;
  final String? strainName2;
  final bool? isHybrid;
  final String? plantStage;
  final String? environment;

  const GrowForm({
    this.plantName,
    this.strain,
    this.strainName1,
    this.strainName2,
    this.isHybrid,
    this.plantStage,
    this.environment,
  });

  GrowForm copyWith({
    String? plantName,
    String? strain,
    String? strainName1,
    String? strainName2,
    bool? isHybrid,
    String? plantStage,
    String? environment,
  }) {
    return GrowForm(
      plantName: plantName ?? this.plantName,
      strain: strain ?? this.strain,
      strainName1: strainName1 ?? this.strainName1 ?? "",
      strainName2: strainName2 ?? this.strainName2 ?? "",
      isHybrid: isHybrid ?? this.isHybrid ?? false,
      plantStage: plantStage ?? this.plantStage,
      environment: environment ?? this.environment,
    );
  }

  bool get isStep1Valid => (plantName?.isNotEmpty ?? false);
  bool get isStep2Valid => (strain?.isNotEmpty ?? false);
  bool get isStep3Valid => (plantStage?.isNotEmpty ?? false);
  bool get isStep4Valid => (environment?.isNotEmpty ?? false);
  bool get isComplete =>
      isStep1Valid && isStep2Valid && isStep3Valid && isStep4Valid;
}
