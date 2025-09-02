import 'dart:io';
import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/add_grow/domain/entities/grow.dart';
import 'package:aurora_v1/features/add_grow/domain/entities/grow_form.dart';
import 'package:aurora_v1/features/add_grow/domain/usecases/add_grow_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_grow_event.dart';
part 'add_grow_state.dart';

class AddGrowBloc extends Bloc<AddGrowEvent, AddGrowState> {
  final AddGrowUseCase _addGrowUseCase;
  GrowForm _form = const GrowForm();

  AddGrowBloc(this._addGrowUseCase) : super(AddGrowInitial()) {
    on<SubmitPlantName>(_onSubmitPlantName);
    on<SubmitStrainDetails>(_onSubmitStrainDetails);
    on<SubmitPlantStage>(_onSubmitPlantStage);
    on<SubmitEnvironment>(_onSubmitEnvironment);
    on<AddGrow>(_onAddGrow);
  }

  void _onSubmitPlantName(SubmitPlantName e, Emitter<AddGrowState> emit) {
    if (e.plantName.trim().isEmpty) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Plant name cannot be empty.',
      ));
      return;
    }
    _form = _form.copyWith(plantName: e.plantName.trim());
    emit(AddGrowStepSuccess(_form));
  }

  void _onSubmitStrainDetails(
      SubmitStrainDetails e, Emitter<AddGrowState> emit) {
    if (![_form.plantName].every((_) =>
            true) /* always true since this step only checks its own fields */ &&
        !_form.isStep1Valid) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Complete the previous step first.',
      ));
      return;
    }
    if (e.strain.isEmpty) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Strain field is required!',
      ));
      return;
    }
    _form = _form.copyWith(
      strain: e.strain,
      strainName1: e.strainName1,
      strainName2: e.strainName2,
      isHybrid: e.isHybrid,
    );
    emit(AddGrowStepSuccess(_form));
  }

  void _onSubmitPlantStage(SubmitPlantStage e, Emitter<AddGrowState> emit) {
    if (!_form.isStep2Valid) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Complete strain details first.',
      ));
      return;
    }
    if (e.plantStage.isEmpty) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Plant stage must not be empty.',
      ));
      return;
    }
    _form = _form.copyWith(plantStage: e.plantStage);
    emit(AddGrowStepSuccess(_form));
  }

  void _onSubmitEnvironment(SubmitEnvironment e, Emitter<AddGrowState> emit) {
    if (!_form.isStep3Valid) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Complete plant stage first.',
      ));
      return;
    }
    if (e.environment.isEmpty) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Environment cannot be empty.',
      ));
      return;
    }
    _form = _form.copyWith(environment: e.environment);
    emit(AddGrowStepSuccess(_form));
  }

  Future<void> _onAddGrow(AddGrow e, Emitter<AddGrowState> emit) async {
    if (!_form.isComplete) {
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Please complete all steps before submitting.',
      ));
      return;
    }
    emit(AddGrowSubmissionInProgress());
    try {
      final growEntity = Grow(
        plantName: _form.plantName!,
        strain: _form.strain!,
        strainName1: _form.strainName1!,
        strainName2: _form.strainName2!,
        plantStage: _form.plantStage!,
        environment: _form.environment!,
        isHybrid: _form.isHybrid!,
      );
      await _addGrowUseCase(growEntity);
      AppLogger.info('Successfully added grow: ${growEntity.plantName}');
      emit(AddGrowSubmissionSuccess());
    } on SocketException {
      AppLogger.error('Network error during grow submission');
      emit(const AddGrowSubmissionFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again later.',
      ));
    } catch (e, st) {
      AppLogger.error('Unexpected error during grow submission',
          error: e, stackTrace: st);
      emit(AddGrowSubmissionFailure(
        errorType: AppErrorType.unknown,
        message: 'Failed to add grow: ${e.toString()}',
      ));
    }
  }
}
