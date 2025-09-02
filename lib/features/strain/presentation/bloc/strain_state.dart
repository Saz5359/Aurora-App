import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:equatable/equatable.dart';

sealed class StrainState extends Equatable {
  const StrainState();

  @override
  List<Object?> get props => [];
}

final class StrainInitial extends StrainState {}

final class StrainDeleteInProgress extends StrainState {}

final class StrainDeleteSuccess extends StrainState {
  final String plantId;

  const StrainDeleteSuccess({required this.plantId});

  @override
  List<Object?> get props => [plantId];
}

final class StrainFailure extends StrainState {
  final AppErrorType errorType;
  final String message;

  const StrainFailure({
    required this.errorType,
    required this.message,
  });

  @override
  List<Object?> get props => [errorType, message];
}
