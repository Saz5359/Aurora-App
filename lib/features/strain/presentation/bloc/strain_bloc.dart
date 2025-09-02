import 'dart:io';

import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/strain/domain/usecases/delete_plant_usecase.dart';
import 'package:bloc/bloc.dart';

import 'strain_event.dart';
import 'strain_state.dart';

class StrainBloc extends Bloc<StrainEvent, StrainState> {
  final DeletePlantUseCase _deletePlant;

  StrainBloc({required DeletePlantUseCase deletePlant})
      : _deletePlant = deletePlant,
        super(StrainInitial()) {
    on<DeleteStrainRequested>(_onDeleteStrainRequested);
  }

  Future<void> _onDeleteStrainRequested(
    DeleteStrainRequested event,
    Emitter<StrainState> emit,
  ) async {
    emit(StrainDeleteInProgress());
    try {
      await _deletePlant(event.plantId);
      AppLogger.info("Plant deleted: ${event.plantId}");
      emit(StrainDeleteSuccess(plantId: event.plantId));
    } on SocketException {
      AppLogger.error("Network error deleting plant: ${event.plantId}");
      emit(const StrainFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } catch (e, st) {
      AppLogger.error("Error deleting plant", error: e, stackTrace: st);
      emit(StrainFailure(
        errorType: AppErrorType.unknown,
        message: 'Failed to delete plant: ${e.toString()}',
      ));
    }
  }
}
