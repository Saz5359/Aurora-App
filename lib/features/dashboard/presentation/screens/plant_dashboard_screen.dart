import 'package:aurora_v1/core/di/service_locator.dart';
import 'package:aurora_v1/core/helpers/snackbar_helper.dart';
import 'package:aurora_v1/core/widgets/dashboard_app_bar.dart';
import 'package:aurora_v1/core/widgets/task_card.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/plant.dart';
import 'package:aurora_v1/features/dashboard/domain/entities/task.dart';
import 'package:aurora_v1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/add_task_dialog.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/device_container.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/no_device_popup.dart';
import 'package:aurora_v1/features/dashboard/presentation/widgets/plant_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PlantDashboardScreen extends StatefulWidget {
  const PlantDashboardScreen({super.key});

  @override
  State<PlantDashboardScreen> createState() => _PlantDashboardScreenState();
}

class _PlantDashboardScreenState extends State<PlantDashboardScreen> {
  Plant? _plant;
  List<Task> _allTasks = [];
  int _completedTasks = 0;
  bool _popupShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String _getTaskStatus(DateTime dueDate,
      {bool completed = false, int upcomingDays = 7}) {
    final now = DateTime.now();
    if (completed) return 'Completed';
    if (dueDate.isBefore(now)) return 'Overdue';
    if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day) {
      return 'Due Today';
    }
    if (dueDate.isBefore(now.add(Duration(days: upcomingDays)))) {
      return 'Due Date Upcoming';
    }
    return 'Running';
  }

  @override
  Widget build(BuildContext context) {
    final plantId = GoRouterState.of(context).pathParameters['growId']!;
    final percentValueStr =
        GoRouterState.of(context).pathParameters['percentValue']!;
    final percentValue = double.tryParse(percentValueStr) ?? 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocProvider(
          create: (context) =>
              sl<DashboardBloc>()..add(FetchPlantDetails(plantId)),
          child: BlocConsumer<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is PlantDetailsLoaded) {
                _plant = state.plant;
                context
                    .read<DashboardBloc>()
                    .add(FetchTaskList(plantId: plantId));

                if (!_popupShown && _plant!.isDeviceConnected == false) {
                  _popupShown = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const NoDevicePopup(),
                    );
                  });
                }
              }

              if (state is TaskListLoaded) {
                _allTasks = state.tasks;
                _completedTasks =
                    _allTasks.where((task) => task.completed).length;
              }

              if (state is DashboardError) {
                showAppErrorSnackBar(context,
                    message: state.message, errorType: state.errorType);
              }
            },
            builder: (context, state) {
              if (state is PlantDetailsLoading || state is TaskListLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return Scaffold(
                appBar: DashboardAppBar(
                  title: Image.asset(
                    'assets/images/dash.png',
                    height: 32,
                    width: 104,
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Back + Title
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
                            const SizedBox(width: 10),
                            Text(
                              'Grow',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        if (_plant != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  _plant!.plantName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () =>
                                    context.push('/strain', extra: _plant),
                                child: Text(
                                  'Manage Strain',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF749A78),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _plant!.isDeviceConnected
                              ? PlantContainer(
                                  value: percentValue,
                                  details: () => context.push('/device_dash',
                                      extra: _plant),
                                )
                              : DeviceContainer(
                                  onPressed: () => context.push('/device_setup',
                                      extra: _plant),
                                ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tasks',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    context.push('/all_task', extra: _plant),
                                child: Text(
                                  'See all tasks',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF749A78),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Tasks Completion Process',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: _allTasks.isNotEmpty
                                ? (_completedTasks / _allTasks.length)
                                : 0.0,
                            minHeight: 15,
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF749A78),
                            backgroundColor: const Color(0xFFD3D3D3),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${_completedTasks}/${_allTasks.length} Tasks Completed',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // Task List Area
                        if (state is TaskListLoaded) ...[
                          if (_allTasks.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'No Tasks Available',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _allTasks.length,
                              itemBuilder: (context, index) {
                                final task = _allTasks[index];
                                return TaskCard(
                                  urgent: false,
                                  status: _getTaskStatus(task.dueDate,
                                      completed: task.completed),
                                  taskType: task.taskType,
                                  title: task.title,
                                  description: task.description,
                                  duration: '${task.estimatedCompletion} mins',
                                  onTap: () {},
                                  openTask: () => context.push('/task'),
                                );
                              },
                            ),
                        ] else if (state is TaskListLoading)
                          const Center(child: CircularProgressIndicator()),

                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                AddTaskDialog(plantId: plantId),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                'Add Task',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
