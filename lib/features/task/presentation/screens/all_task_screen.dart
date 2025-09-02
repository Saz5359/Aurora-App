import 'package:aurora_v1/core/di/service_locator.dart';
import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:aurora_v1/core/widgets/task_card.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/task.dart';
import 'package:aurora_v1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:aurora_v1/features/task/presentation/widgets/task_selector.dart';
import 'package:aurora_v1/features/task/presentation/widgets/weekly_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AllTasksScreen extends StatefulWidget {
  final Plant grow;
  const AllTasksScreen({super.key, required this.grow});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  bool _isTutorialExpanded = false;
  bool _isDailyExpanded = false;
  bool _isSeasonalExpanded = false;
  DateTime selectedDate = DateTime.now()
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  String getTaskStatus(DateTime dueDate,
      {bool completed = false, int upcomingDays = 7}) {
    final now = DateTime.now();

    if (completed) {
      return 'Completed';
    } else if (dueDate.isBefore(now)) {
      return 'Overdue';
    } else if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day) {
      return 'Due Today';
    } else if (dueDate.isBefore(now.add(Duration(days: upcomingDays)))) {
      return 'Due Date Upcoming';
    } else {
      return 'Running';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()
        ..add(FetchCategorizedTasks(plantId: widget.grow.id)),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            showAppErrorSnackBar(context,
                message: state.message, errorType: state.errorType);
          }
        },
        child: Scaffold(
          appBar: DashboardAppBar(
            title: Text(
                widget.grow.isDeviceConnected == true
                    ? "Aurora Device"
                    : "No Device Connected",
                style: TextStyle(
                    color: Color(0xFF749A78),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(0xFFAFCEB2),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Tasks",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  WeeklyCalendar(
                    selectedDate: selectedDate,
                    onDateSelected: (DateTime newDate) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Display tasks based on selectedDate
                  _buildTasksForSelectedDate(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to display tasks based on the selected date
  Widget _buildTasksForSelectedDate() {
    DateTime today = DateTime.now().copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    if (selectedDate.isAtSameMomentAs(today)) {
      return BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is CategorizedTasksLoaded) {
            return _buildDailyTasks(
              tutorialTasks: state.tutorialTasks,
              dailyTasks: state.dailyTasks,
              seasonalTasks: state.seasonalTasks,
            );
          } else if (state is TaskListLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardError) {
            return Center(
                child: Text('Failed to load tasks: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      );
    } else if (selectedDate.isBefore(today)) {
      return _buildPastTasks();
    } else {
      return _buildFutureTasks();
    }
  }

  Widget _buildDailyTasks({
    required List<Task> tutorialTasks,
    required List<Task> dailyTasks,
    required List<Task> seasonalTasks,
  }) {
    return Column(
      children: [
        TaskSelector(
          title: "Tutorial tasks",
          totalTasks: tutorialTasks.length,
          completedTasks:
              tutorialTasks.where((t) => t.completed == true).length,
          isExpanded: _isTutorialExpanded,
          onTap: () {
            setState(() {
              _isTutorialExpanded = !_isTutorialExpanded;
            });
          },
          children: _isTutorialExpanded
              ? tutorialTasks
                  .map((task) => TaskCard(
                        urgent: false,
                        status: getTaskStatus(
                          task.dueDate,
                        ),
                        taskType: task.taskType,
                        title: task.title,
                        description: task.description,
                        duration: '${task.estimatedCompletion} mins',
                        onTap: () {},
                        openTask: () => context.push("/task"),
                      ))
                  .toList()
              : [],
        ),
        TaskSelector(
          title: "Daily tasks",
          totalTasks: dailyTasks.length,
          completedTasks: dailyTasks.where((t) => t.completed == true).length,
          isExpanded: _isDailyExpanded,
          onTap: () {
            setState(() {
              _isDailyExpanded = !_isDailyExpanded;
            });
          },
          children: _isDailyExpanded
              ? dailyTasks
                  .map((task) => TaskCard(
                        urgent: false,
                        status: getTaskStatus(task.dueDate),
                        taskType: task.taskType,
                        title: task.title,
                        description: task.description,
                        duration: '${task.estimatedCompletion} mins',
                        onTap: () {},
                        openTask: () => context.push("/task"),
                      ))
                  .toList()
              : [],
        ),
        TaskSelector(
          title: "Seasonal tasks",
          totalTasks: seasonalTasks.length,
          completedTasks:
              seasonalTasks.where((t) => t.completed == true).length,
          isExpanded: _isSeasonalExpanded,
          onTap: () {
            setState(() {
              _isSeasonalExpanded = !_isSeasonalExpanded;
            });
          },
          children: _isSeasonalExpanded
              ? seasonalTasks
                  .map((task) => TaskCard(
                        urgent: false,
                        status: getTaskStatus(task.dueDate),
                        taskType: task.taskType,
                        title: task.title,
                        description: task.description,
                        duration: '${task.estimatedCompletion} mins',
                        onTap: () {},
                        openTask: () => context.push("/task"),
                      ))
                  .toList()
              : [],
        ),
      ],
    );
  }

  Widget _buildPastTasks() {
    return Column(
      children: [
        TaskSelector(
          title: "Seasonal tasks",
          totalTasks: 5,
          completedTasks: 1,
          isExpanded: _isTutorialExpanded,
          onTap: () {
            setState(() {
              _isTutorialExpanded = !_isTutorialExpanded;
            });
          },
          children: _isTutorialExpanded
              ? [
                  TaskCard(
                    urgent: false,
                    status: 'Overdue',
                    taskType: "Seasonal",
                    title: "Germination Methods",
                    description:
                        "Picking a germination method that’s right for you",
                    duration: '10 mins',
                    onTap: () {},
                    openTask: () => context.push("/task"),
                  )
                ]
              : [],
        ),
        TaskSelector(
          title: "Completed tasks",
          totalTasks: 1,
          completedTasks: 1,
          isExpanded: _isDailyExpanded,
          onTap: () {
            setState(() {
              _isDailyExpanded = !_isDailyExpanded;
            });
          },
          children: _isDailyExpanded
              ? [
                  TaskCard(
                    urgent: false,
                    status: 'Completed',
                    taskType: "Tutorial",
                    title: "Begin Germination",
                    description: "A brief overview of the germination process",
                    duration: '10 mins',
                    onTap: () {},
                    openTask: () => context.push("/task"),
                  )
                ]
              : [],
        ),
        TaskSelector(
          title: "Daily tasks",
          totalTasks: 1,
          completedTasks: 0,
          isExpanded: _isSeasonalExpanded,
          onTap: () {
            setState(() {
              _isSeasonalExpanded = !_isSeasonalExpanded;
            });
          },
          children: _isSeasonalExpanded
              ? [
                  TaskCard(
                    urgent: false,
                    status: 'Running',
                    taskType: "Daily",
                    title: "Water Plants",
                    description: "Your plants are feeling a little thirsty",
                    duration: '2 mins',
                    onTap: () {},
                    openTask: () => context.push("/task"),
                  )
                ]
              : [],
        )
      ],
    );
  }

  Widget _buildFutureTasks() {
    return Column(
      children: [
        TaskSelector(
          title: "Upcoming Tasks",
          totalTasks: 1,
          completedTasks: 0,
          isExpanded: true,
          onTap: () {},
          children: [
            TaskCard(
              urgent: false,
              status: 'Upcoming',
              taskType: "Upcoming",
              title: "Fertilize Soil",
              description: "Prepare the soil for next stage",
              duration: '5 mins',
              onTap: () {},
              openTask: () => context.push("/task"),
            ),
          ],
        ),
      ],
    );
  }
}
