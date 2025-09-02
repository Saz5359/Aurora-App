part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class PlantCountLoaded extends DashboardState {
  final int count;

  const PlantCountLoaded(this.count);

  @override
  List<Object?> get props => [count];
}

final class PlantListLoading extends DashboardState {}

final class PlantListLoaded extends DashboardState {
  final List<Plant> plants;

  const PlantListLoaded(this.plants);

  @override
  List<Object?> get props => [plants];
}

final class PlantDetailsLoading extends DashboardState {}

final class PlantDetailsLoaded extends DashboardState {
  final Plant plant;

  const PlantDetailsLoaded(this.plant);

  @override
  List<Object?> get props => [plant];
}

final class TaskListLoading extends DashboardState {}

final class TaskListLoaded extends DashboardState {
  final List<Task> tasks;

  const TaskListLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

final class TaskAddLoading extends DashboardState {}

final class TaskAddSuccess extends DashboardState {}

final class TaskCompletedSuccess extends DashboardState {}

final class TaskAddFailure extends DashboardState {
  final String message;

  const TaskAddFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class CategorizedTasksLoaded extends DashboardState {
  final List<Task> tutorialTasks;
  final List<Task> dailyTasks;
  final List<Task> seasonalTasks;
  final List<Task> upcomingTasks;

  const CategorizedTasksLoaded({
    required this.tutorialTasks,
    required this.dailyTasks,
    required this.seasonalTasks,
    required this.upcomingTasks,
  });

  @override
  List<Object?> get props =>
      [tutorialTasks, dailyTasks, seasonalTasks, upcomingTasks];
}

final class DashboardError extends DashboardState {
  final AppErrorType errorType;
  final String message;

  const DashboardError(this.message, this.errorType);

  @override
  List<Object?> get props => [message];
}
