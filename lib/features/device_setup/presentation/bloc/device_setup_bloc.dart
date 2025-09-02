import 'dart:io';
import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/device_connection.dart';
import '../../domain/usecases/update_connection_usecase.dart';

part 'device_setup_event.dart';
part 'device_setup_state.dart';

class DeviceSetupBloc extends Bloc<DeviceSetupEvent, DeviceSetupState> {
  final UpdateConnectionUseCase _updateConnection;

  DeviceSetupBloc({required UpdateConnectionUseCase updateConnection})
      : _updateConnection = updateConnection,
        super(DeviceSetupInitial()) {
    on<ConnectionStatusUpdated>(_onConnectionStatusUpdated);
  }

  Future<void> _onConnectionStatusUpdated(
    ConnectionStatusUpdated event,
    Emitter<DeviceSetupState> emit,
  ) async {
    if (event.connection.plantId.isEmpty ||
        event.connection.deviceName.isEmpty) {
      emit(const DeviceSetupFailure(
        errorType: AppErrorType.invalidInput,
        message: 'Plant ID and device name are required.',
      ));
      return;
    }

    emit(DeviceSetupInProgress());
    try {
      await _updateConnection(event.connection);
      emit(DeviceSetupSuccess(isConnected: event.connection.isConnected));
      AppLogger.info(
          'Device ${event.connection.deviceName} connectivity updated');
    } on SocketException {
      AppLogger.error('Network error updating device connection');
      emit(const DeviceSetupFailure(
        errorType: AppErrorType.network,
        message: 'No internet connection. Please try again.',
      ));
    } catch (e, st) {
      AppLogger.error('Unexpected error in device setup',
          error: e, stackTrace: st);
      emit(DeviceSetupFailure(
        errorType: AppErrorType.unknown,
        message: 'Failed to update connection: ${e.toString()}',
      ));
    }
  }
}
