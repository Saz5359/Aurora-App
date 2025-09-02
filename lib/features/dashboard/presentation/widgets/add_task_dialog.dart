import 'package:aurora_v1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {
  final String plantId;

  const AddTaskDialog({super.key, required this.plantId});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _estTimeController = TextEditingController();
  DateTime? _dueDate;

  // Dropdown task type
  String? _taskType;

  final List<String> _taskTypes = ['Seasonal', 'Tutorial', 'Daily', 'Upcoming'];

  Future<void> _pickDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final estTime = _estTimeController.text;
      final DateTime safeDueDate = _dueDate ?? DateTime.now();
      final taskType = _taskType ?? 'Daily';

      context.read<DashboardBloc>().add(AddTaskEvent(
            title: title,
            estimatedCompletion: estTime,
            plantId: widget.plantId,
            description: description,
            dueDate: safeDueDate,
            taskType: taskType,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Add Task",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: "Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter a title'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _taskType,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            items: _taskTypes
                                .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ))
                                .toList(),
                            decoration: InputDecoration(
                              labelText: "Task Type",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _taskType = value;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a task type'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            maxLines: 3,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter a description'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _estTimeController,
                            decoration: InputDecoration(
                              labelText: "Estimated Time (in minutes)",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter the estimated time'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _pickDueDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Due Date",
                                  hintText: _dueDate != null
                                      ? DateFormat('yMMMd').format(_dueDate!)
                                      : "Select Due Date",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) => _dueDate == null
                                    ? 'Please select a due date'
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<DashboardBloc, DashboardState>(
                      listener: (context, state) {
                        if (state is TaskAddLoading) {
                          Navigator.pop(context);
                        }
                        if (state is TaskAddFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      state.message,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.red.shade600,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is TaskAddLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          );
                        }
                        return ElevatedButton(
                          onPressed: _submitTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            "Add Task",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
