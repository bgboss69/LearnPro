import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/goal_model.dart';
import '../models/task_model.dart';
import 'package:numberpicker/numberpicker.dart';

class TaskEditPage extends StatefulWidget {
  final TaskModel task;
  final Goal goal;

  const TaskEditPage({Key? key, required this.task, required this.goal})
      : super(key: key);

  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  late final TaskController controller;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _guestTimerController = TextEditingController();
  final TextEditingController _doneTimerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? textCreatedAt;
  int? selectedPriority;
  bool isCompleted = false;
  String? textPriority;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    controller = Get.put(TaskController(widget.goal.id!));

    // Initialize form fields with the task data
    _titleController.text = widget.task.title;
    _noteController.text = widget.task.note ?? '';

    // If the task has a deadline, set it to the deadline controller
    if (widget.task.deadline != null) {
      _deadlineController.text =
          DateFormat('yyyy-MM-dd').format(widget.task.deadline!);
    }

    // If the task has a reminder, set it to the reminder controller
    if (widget.task.reminder != null) {
      _reminderController.text =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(widget.task.reminder!);
    }

    // Initialize timers
    _guestTimerController.text = widget.task.guestTimer?.toString() ?? '';
    _doneTimerController.text = widget.task.doneTimer?.toString() ?? '';
    // Initialize createdAt and make it read-only
    if (widget.task.createdAt != null) {
      textCreatedAt = DateFormat('yyyy-MM-dd').format(widget.task.createdAt!);
    }
    // Initialize selected priority
    selectedPriority = widget.task.priority;
    textPriority = getPriorityText(selectedPriority);
    print('Initial selectedPriority: $selectedPriority');

    // Initialize isCompleted state
    isCompleted = widget.task.isCompleted!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title text field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
            
                const SizedBox(height: 16),
            
                // Note text field
                TextField(
                  controller: _noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                ),
            
                const SizedBox(height: 16),
            
                // Deadline date picker
                TextField(
                  controller: _deadlineController,
                  decoration: const InputDecoration(
                    labelText: 'Deadline',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    await _selectDate(
                      context,
                      DateTime.tryParse(_deadlineController.text) ??
                          DateTime.now(),
                      onDateSelected: (date) {
                        // setState(() {
                        //   _deadlineController.text =
                        //       DateFormat('yyyy-MM-dd').format(date);
                        // });
                        setState(() {
                          DateTime? parsedReminder;
                          // Parse the string from _deadlineController.text to DateTime
                          if (_reminderController.text.isNotEmpty) {
                            try {
                              parsedReminder = DateFormat('MMMM dd, yyyy - hh:mm a').parse(_reminderController.text);
                            } catch (e) {
                              // Handle parse error (e.g., invalid format)
                              print('Failed to parse reminder: $e');
                              parsedReminder = null;
                            }
                          }
                          // Update reminder and deadline based on conditions
            
                          if (date.isBefore(DateTime.now())) {
                            // Show a snackbar when selected reminder is before the current date and time
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selected Deadline is before the current date and time.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            _deadlineController.text = '';
                          } else if (parsedReminder == null) {
                            _deadlineController.text = DateFormat('yyyy-MM-dd').format(date);
                          } else if (parsedReminder.isBefore(date)) {
                            _deadlineController.text = DateFormat('yyyy-MM-dd').format(date);
                          } else {
                            // Show a snackbar when selected reminder is before the deadline date and time
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selected Deadline is Before the Reminder date and time.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            _deadlineController.text = '';
                          }
                        });
                      },
                    );
                  },
                ),
            
                const SizedBox(height: 16),
            
                // Reminder date picker
                TextField(
                  controller: _reminderController,
                  decoration: const InputDecoration(
                    labelText: 'Reminder',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    await _selectDateTime(
                      context,
                      DateTime.tryParse(_reminderController.text) ?? DateTime.now(),
                      onDateTimeSelected: (DateTime dateTime) {
                        setState(() {
                          DateTime? parsedDeadline;
                          // Parse the string from _deadlineController.text to DateTime
                          if (_reminderController.text.isNotEmpty) {
                            try {
                              parsedDeadline = DateFormat('yyyy-MM-dd').parse(_deadlineController.text);
                            } catch (e) {
                              // Handle parse error (e.g., invalid format)
                              print('Failed to parse deadline: $e');
                              parsedDeadline = null;
                            }
                          }
                          // Update reminder and deadline based on conditions
                          if (dateTime.isBefore(DateTime.now())) {
                            // Show a snackbar when selected reminder is before the current date and time
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selected Reminder is before the current date and time.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            _reminderController.text = '';
                          } else if (parsedDeadline == null) {
                            _reminderController.text = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
                          } else if (parsedDeadline.isAfter(dateTime)) {
                            _reminderController.text = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
                          } else {
                            // Show a snackbar when selected reminder is before the deadline date and time
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selected Reminder is after the Deadline date and time.'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            _reminderController.text = '';
                          }
                        });
                      },
                    );
                  },
            
                ),
            
                const SizedBox(height: 16),
            
                // Priority button
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Priority:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(textPriority != null
                              ? '$textPriority'
                              : 'No priority selected'),
                          // Display selected priority
                          const Icon(Icons.flag),
                          const SizedBox(width: 8),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          final priority =
                              await _showPriorityInputDialog(context);
                          if (priority != null) {
                            setState(() {
                              selectedPriority = priority;
                              textPriority = getPriorityText(selectedPriority);
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                ),
            
                const SizedBox(height: 16),
            
                // Guest Timer button
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Estimated Sessions:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(_guestTimerController.text),
                          const Icon(Icons.timer),
                          const SizedBox(width: 8),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          final timer = await _showTimerInputDialog(context);
                          if (timer != null) {
                            setState(() {
                              _guestTimerController.text = timer.toString();
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Completed Sessions:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(_doneTimerController.text),
                      const SizedBox(width: 8),
                      const Icon(Icons.timer),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Is Completed:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    isCompleted = value!;
                                  });
                                },
                              ),
                              const Text('Yes'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<bool>(
                                value: false,
                                groupValue: isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    isCompleted = value!;
                                  });
                                },
                              ),
                              const Text('No'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // createdAt field (read-only)
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Aligns the children to the end
                  children: [
                    const Text("Created On: "),
                    Text(textCreatedAt != null ? '$textCreatedAt' : 'Error'),
                  ],
                ),
            
                const SizedBox(height: 16),
            
                // Save button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final updatedTask = TaskModel(
                            id: widget.task.id,
                            title: _titleController.text,
                            note: _noteController.text,
                            deadline: DateTime.tryParse(_deadlineController.text),
                            reminder: DateTime.tryParse(_reminderController.text),
                            priority: selectedPriority,
                            guestTimer: int.tryParse(_guestTimerController.text),
                            doneTimer: widget.task.doneTimer,
                            // Assume doneTimer remains unchanged
                            isCompleted: isCompleted,
                            createdAt: widget.task.createdAt,
                          );

                          // Call the updateTask function in the controller
                          await controller.updateTask(updatedTask);
                          Navigator.of(context).pop(); // Close the edit page
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to show the date picker and update the selected date
  Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate,
      {required Function(DateTime) onDateSelected}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      onDateSelected(date); // Call the provided function with the selected date
    }

    return date;
  }

  Future<DateTime?> _selectDateTime(BuildContext context, DateTime initialDateTime,
      {required Function(DateTime) onDateTimeSelected}) async {
    // Step 1: Show the date picker
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    // If the user selected a date
    if (date != null) {
      // Step 2: Show the time picker
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );

      // If the user selected a time
      if (time != null) {
        // Combine the selected date and time into a single DateTime object
        final DateTime selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        // Call the onDateTimeSelected function with the combined DateTime
        onDateTimeSelected(selectedDateTime);

        // Return the combined DateTime object
        return selectedDateTime;
      }
    }
    // Return null if the user did not select a date or time
    return null;
  }

  // Helper function to show timer input dialog and return the selected timer duration
  Future<int?> _showTimerInputDialog(BuildContext context) async {
    int selectedTimer = 0; // Initialize the selected timer value

    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Timer Duration (in minutes)'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NumberPicker(
                    value: selectedTimer,
                    minValue: 0,
                    maxValue: 120,
                    onChanged: (value) {
                      setState(() {
                        selectedTimer = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(selectedTimer); // Return the selected timer value
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    return result;
  }

  String getPriorityText(int? priority) {
    switch (priority) {
      case 0:
        return 'No';
      case 1:
        return 'Important & Urgent';
      case 2:
        return 'Important but Not Urgent';
      case 3:
        return 'Urgent but Not Important';
      case 4:
        return 'Not Important & Not Urgent';
      default:
        return 'Error';
    }
  }

  // Function to show priority selection dialog
  Future<int?> _showPriorityInputDialog(BuildContext context) async {
    final selectedPriority = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Select Priority',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPriorityOption(
                  context, 1, 'Important & Urgent', Colors.red),
              _buildPriorityOption(
                  context, 2, 'Important but Not Urgent', Colors.orange),
              _buildPriorityOption(
                  context, 3, 'Urgent but Not Important', Colors.blue),
              _buildPriorityOption(
                  context, 4, 'Not Important & Not Urgent', Colors.grey),
            ],
          ),
        );
      },
    );

    return selectedPriority;
  }

  // Build a priority selection option
  Widget _buildPriorityOption(
      BuildContext context, int priority, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(priority);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(Icons.flag, size: 30, color: color),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the text controllers when done with the page
    _titleController.dispose();
    _noteController.dispose();
    _deadlineController.dispose();
    _reminderController.dispose();
    _guestTimerController.dispose();
    _doneTimerController.dispose();
    super.dispose();
  }
}
