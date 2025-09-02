part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

final class FetchPlantCount extends DashboardEvent {}

final class FetchPlantList extends DashboardEvent {}

final class FetchPlantDetails extends DashboardEvent {
  final String plantId;

  const FetchPlantDetails(this.plantId);

  @override
  List<Object> get props => [plantId];
}

final class FetchTaskList extends DashboardEvent {
  final String plantId;

  const FetchTaskList({required this.plantId});

  @override
  List<Object> get props => [plantId];
}

final class AddTaskEvent extends DashboardEvent {
  final String plantId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String estimatedCompletion;
  final String taskType;

  const AddTaskEvent({
    required this.plantId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.estimatedCompletion,
    required this.taskType,
  });

  @override
  List<Object> get props => [
        plantId,
        title,
        description,
        dueDate,
        estimatedCompletion,
        taskType,
      ];
}

final class CompleteTaskEvent extends DashboardEvent {
  final String plantId;
  final String taskId;

  const CompleteTaskEvent(this.taskId, this.plantId);

  @override
  List<Object> get props => [taskId];
}

final class FetchCategorizedTasks extends DashboardEvent {
  final String plantId;

  const FetchCategorizedTasks({required this.plantId});

  @override
  List<Object> get props => [plantId];
}
