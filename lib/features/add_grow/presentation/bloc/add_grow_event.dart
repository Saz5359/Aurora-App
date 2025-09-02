part of 'add_grow_bloc.dart';

sealed class AddGrowEvent extends Equatable {
  const AddGrowEvent();
  @override
  List<Object?> get props => [];
}

final class SubmitPlantName extends AddGrowEvent {
  final String plantName;
  const SubmitPlantName(this.plantName);
  @override
  List<Object?> get props => [plantName];
}

final class SubmitStrainDetails extends AddGrowEvent {
  final String strain;
  final String strainName1;
  final String strainName2;
  final bool isHybrid;
  const SubmitStrainDetails({
    required this.strain,
    required this.strainName1,
    required this.strainName2,
    required this.isHybrid,
  });
  @override
  List<Object?> get props => [strain, strainName1, strainName2, isHybrid];
}

final class SubmitPlantStage extends AddGrowEvent {
  final String plantStage;
  const SubmitPlantStage(this.plantStage);
  @override
  List<Object?> get props => [plantStage];
}

final class SubmitEnvironment extends AddGrowEvent {
  final String environment;
  const SubmitEnvironment(this.environment);
  @override
  List<Object?> get props => [environment];
}

final class AddGrow extends AddGrowEvent {}
