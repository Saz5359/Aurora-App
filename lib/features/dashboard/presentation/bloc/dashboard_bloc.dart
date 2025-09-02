import 'dart:async';
import 'dart:io';

import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/utils/logger.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/complete_task_usecase.dart';
import 'package:aurora_v1/features/dashboard/domain/usecases/get_tasks_once_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/plant.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_plant_count_usecase.dart';
import '../../domain/usecases/get_plant_by_id_usecase.dart';
import '../../domain/usecases/get_plants_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/add_task_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetPlantCountUseCase _getPlantCount;
  final GetPlantsUseCase _getPlants;
  final GetPlantByIdUseCase _getPlantById;
  final GetTasksUseCase _getTasks;
  final AddTaskUseCase _addTask;
  final CompleteTaskUseCase _completeTask;
  final GetTasksOnceUseCase _getTasksOnce;

  DashboardBloc({
    required GetPlantCountUseCase getPlantCount,
    required GetPlantsUseCase getPlants,
    required GetPlantByIdUseCase getPlantById,
    required GetTasksUseCase getTasks,
    required AddTaskUseCase addTask,
    required CompleteTaskUseCase completeTask,
    required GetTasksOnceUseCase getTasksOnce,
  })  : _getPlantCount = getPlantCount,
        _getPlants = getPlants,
        _getPlantById = getPlantById,
        _getTasks = getTasks,
        _addTask = addTask,
        _completeTask = completeTask,
        _getTasksOnce = getTasksOnce,
        super(DashboardInitial()) {
    on<FetchPlantCount>(_onFetchPlantCount);
    on<FetchPlantList>(_onFetchPlantList);
    on<FetchPlantDetails>(_onFetchPlantDetails);
    on<FetchTaskList>(_onFetchTaskList);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<FetchCategorizedTasks>(_onFetchCategorizedTasks);
    on<CompleteTaskEvent>(_onCompleteTaskEvent);
  }

  Future<void> _onFetchPlantCount(
      FetchPlantCount event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final int count = await _getPlantCount();
      AppLogger.info("Fetched plant count: $count");
      emit(PlantCountLoaded(count));
    } on SocketException {
      AppLogger.error("No network while fetching plant count.");
      emit(const DashboardError(
          "No internet connection.", AppErrorType.network));
    } catch (e, st) {
      AppLogger.error("Error fetching plant count: $e", stackTrace: st);
      emit(DashboardError("Failed to fetch plant count: ${e.toString()}",
          AppErrorType.unknown));
    }
  }

  Future<void> _onFetchPlantList(
      FetchPlantList event, Emitter<DashboardState> emit) async {
    emit(PlantListLoading());
    try {
      final Stream<List<Plant>> plantStream = _getPlants();
      AppLogger.info("Here are the plants: ${plantStream.toString()}");
      await emit.forEach<List<Plant>>(
        plantStream,
        onData: (plantList) {
          AppLogger.info("Plant list updated (count=${plantList.length})");
          return PlantListLoaded(plantList);
        },
        onError: (error, stackTrace) {
          AppLogger.error("Error streaming plant list: $error",
              stackTrace: stackTrace);
          return DashboardError("Failed to load plants", AppErrorType.unknown);
        },
      );
    } on SocketException {
      AppLogger.error("No network while fetching plant count.");
      emit(const DashboardError(
          "No internet connection.", AppErrorType.network));
    } catch (e, st) {
      AppLogger.error("Error initializing plant list stream: $e",
          stackTrace: st);
      emit(DashboardError(
          "Failed to load plants: ${e.toString()}", AppErrorType.unknown));
    }
  }

  Future<void> _onFetchPlantDetails(
      FetchPlantDetails event, Emitter<DashboardState> emit) async {
    emit(PlantDetailsLoading());
    try {
      // Get the current snapshot of the plant (non-stream) to check device status
      final plantSnapshot =
          await _getPlantById(event.plantId).first; // Get one value only

      AppLogger.info(
          "Checking device connection for plant: ${plantSnapshot.plantName}");
      if (!plantSnapshot.isDeviceConnected) {
        final tasks = await _getTasksOnce(event.plantId);
        final hasDeviceTask = tasks.any((t) => t.taskType == 'device_setup');

        if (!hasDeviceTask) {
          AppLogger.info(
              "Adding device setup task for plant: ${plantSnapshot.plantName}");
          await _addTask(
            plantId: event.plantId,
            title: "Connect Device",
            description: "Add a device to start monitoring this grow.",
            dueDate: DateTime.now().add(Duration(days: 365)),
            estimatedCompletion: "5",
            taskType: "device_setup",
          );
        }
      } else {
        final tasks = await _getTasksOnce(event.plantId);
        final hasDeviceTask = tasks.any((t) => t.taskType == 'device_setup');

        if (hasDeviceTask) {
          AppLogger.info(
              "Removing device setup task for plant: ${plantSnapshot.plantName}");
          await _completeTask(event.plantId,
              tasks.firstWhere((t) => t.taskType == 'device_setup').id);
        }
      }

      final Stream<Plant> plantStream = _getPlantById(event.plantId);
      await emit.forEach<Plant>(
        plantStream,
        onData: (plant) {
          AppLogger.info("Plant details loaded: ${plant.plantName}");
          return PlantDetailsLoaded(plant);
        },
        onError: (error, stackTrace) {
          AppLogger.error("Error streaming plant details: $error",
              stackTrace: stackTrace);
          return DashboardError(
              "Failed to load plant details", AppErrorType.unknown);
        },
      );
    } on SocketException {
      AppLogger.error("No network while fetching plant count.");
      emit(const DashboardError(
          "No internet connection.", AppErrorType.network));
    } catch (e, st) {
      AppLogger.error("Error initializing plant details stream: $e",
          stackTrace: st);
      emit(DashboardError("Failed to load plant details: ${e.toString()}",
          AppErrorType.unknown));
    }
  }

  Future<void> _onFetchTaskList(
      FetchTaskList event, Emitter<DashboardState> emit) async {
    emit(TaskListLoading());
    try {
      final Stream<List<Task>> taskStream = _getTasks(event.plantId);
      await emit.forEach<List<Task>>(
        taskStream,
        onData: (taskList) {
          AppLogger.info(
              "Task list updated for plantId=${event.plantId} (count=${taskList.length})");
          return TaskListLoaded(taskList.where((t) => !t.completed).toList());
        },
        onError: (error, stackTrace) {
          AppLogger.error("Error streaming task list: $error",
              stackTrace: stackTrace);
          return DashboardError("Failed to load tasks", AppErrorType.unknown);
        },
      );
    } on SocketException {
      AppLogger.error("No network while fetching plant count.");
      emit(const DashboardError(
          "No internet connection.", AppErrorType.network));
    } catch (e, st) {
      AppLogger.error("Error initializing task list stream: $e",
          stackTrace: st);
      emit(DashboardError(
          "Failed to load tasks: ${e.toString()}", AppErrorType.unknown));
    }
  }

  Future<void> _onAddTaskEvent(
      AddTaskEvent event, Emitter<DashboardState> emit) async {
    emit(TaskAddLoading());
    try {
      await _addTask(
        plantId: event.plantId,
        title: event.title,
        description: event.description,
        dueDate: event.dueDate,
        estimatedCompletion: event.estimatedCompletion,
        taskType: event.taskType,
      );
      AppLogger.info("Task added under plantId=${event.plantId}");
      emit(TaskAddSuccess());
    } on SocketException {
      AppLogger.error(
          "No network when adding task to plantId=${event.plantId}");
      emit(const TaskAddFailure("No internet connection."));
    } catch (e, st) {
      AppLogger.error("Error adding task: $e", stackTrace: st);
      emit(TaskAddFailure("Failed to add task: ${e.toString()}"));
    }
  }

  Future<void> _onCompleteTaskEvent(
      CompleteTaskEvent event, Emitter<DashboardState> emit) async {
    emit(TaskListLoading());
    try {
      await _completeTask(event.plantId, event.taskId);
      AppLogger.info("Task completed with id=${event.taskId}");
      emit(TaskAddSuccess());
    } on SocketException {
      AppLogger.error(
          "No network when completing task with id=${event.taskId}");
      emit(const TaskAddFailure("No internet connection."));
    } catch (e, st) {
      AppLogger.error("Error completing task: $e", stackTrace: st);
      emit(TaskAddFailure("Failed to complete task: ${e.toString()}"));
    }
  }

  Future<void> _onFetchCategorizedTasks(
      FetchCategorizedTasks event, Emitter<DashboardState> emit) async {
    emit(TaskListLoading());
    try {
      final Stream<List<Task>> taskStream = _getTasks(event.plantId);
      await emit.forEach<List<Task>>(
        taskStream,
        onData: (allTasks) {
          final tutorialTasks =
              allTasks.where((t) => t.taskType == 'Tutorial').toList();
          final dailyTasks =
              allTasks.where((t) => t.taskType == 'Daily').toList();
          final seasonalTasks =
              allTasks.where((t) => t.taskType == 'Seasonal').toList();
          final upcomingTasks =
              allTasks.where((t) => t.taskType == 'Upcoming').toList();

          AppLogger.info("Categorized tasks for plantId=${event.plantId}");
          return CategorizedTasksLoaded(
            tutorialTasks: tutorialTasks,
            dailyTasks: dailyTasks,
            seasonalTasks: seasonalTasks,
            upcomingTasks: upcomingTasks,
          );
        },
        onError: (error, stackTrace) {
          AppLogger.error("Error streaming categorized tasks: $error",
              stackTrace: stackTrace);
          return DashboardError(
              "Failed to load categorized tasks", AppErrorType.unknown);
        },
      );
    } on SocketException {
      AppLogger.error("No network while fetching plant count.");
      emit(const DashboardError(
          "No internet connection.", AppErrorType.network));
    } catch (e, st) {
      AppLogger.error("Error initializing categorized tasks stream: $e",
          stackTrace: st);
      emit(DashboardError("Failed to load categorized tasks: ${e.toString()}",
          AppErrorType.unknown));
    }
  }
}
