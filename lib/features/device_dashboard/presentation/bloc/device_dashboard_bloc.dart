import 'dart:io';

import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/device_dashboard/data/model/sensor_data_model.dart';
import 'package:aurora_v1/features/device_dashboard/domain/usecases/get_device_name.dart';
import 'package:aurora_v1/features/device_dashboard/domain/usecases/stream_device_sensor_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_dashboard_event.dart';
part 'device_dashboard_state.dart';

class DeviceDashboardBloc
    extends Bloc<DeviceDashboardEvent, DeviceDashboardState> {
  final GetDeviceNameUseCase getDeviceName;
  final StreamDeviceSensorData streamSensorData;

  DeviceDashboardBloc({
    required this.getDeviceName,
    required this.streamSensorData,
  }) : super(DeviceDashboardInitial()) {
    on<StartSensorDataStream>(_onStartSensorDataStream);
  }

  Future<void> _onStartSensorDataStream(
    StartSensorDataStream event,
    Emitter<DeviceDashboardState> emit,
  ) async {
    emit(DeviceDashboardLoading());
    try {
      final deviceName = await getDeviceName(event.plantId);
      if (deviceName.isEmpty) {
        emit(const DeviceDashboardError(
            "Device name not found for this plant.", AppErrorType.unknown));
        return;
      }

      AppLogger.info("Starting sensor data stream for device: $deviceName");
      await emit.forEach<SensorDataModel?>(
        streamSensorData(deviceName),
        onData: (sensorData) {
          if (sensorData == null) {
            return const DeviceDashboardError(
                "No sensor data available.", AppErrorType.unknown);
          }
          AppLogger.info("Received sensor data");
          return DeviceDashboardLoaded(sensorData);
        },
        onError: (error, _) =>
            DeviceDashboardError(error.toString(), AppErrorType.unknown),
      );
    } on SocketException {
      // Network connectivity issue
      emit(const DeviceDashboardError(
        'No internet connection. Please try again later.',
        AppErrorType.network,
      ));
    } catch (e, stack) {
      AppLogger.error("Failed to load sensor data",
          error: e, stackTrace: stack);
      emit(DeviceDashboardError(e.toString(), AppErrorType.unknown));
    }
  }
}
