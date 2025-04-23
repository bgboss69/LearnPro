import '../pages/spin_wheel.dart';
import '../pages/task_detial_page.dart';
import '../pages/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/goal_model.dart';
import '../models/task_model.dart';
import 'package:numberpicker/numberpicker.dart';

class GoalDetailPage extends StatefulWidget {
  final Goal goal;

  const GoalDetailPage({super.key, required this.goal});

  @override
  _GoalDetailPageState createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  late TaskController taskController;
  String _selectedSortOption = 'deadline';
  @override
  void initState() {
    super.initState();
    // Initialize TaskController with the goal's ID
    taskController = Get.put(TaskController(widget.goal.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal: ${widget.goal.title}'),
        actions: <Widget>[
          _buildSortMenu(),
        ],
      ),
      body: Obx(() {
        if (taskController.tasks.isEmpty) {
          return const Center(child: Text("No tasks. Please add one."));
        }

        return ListView.builder(
          itemCount: taskController.tasks.length,
          itemBuilder: (context, index) {
            final task = taskController.tasks[index];
            return _buildTaskListItem(task);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper method to build a task list item
  Widget _buildTaskListItem(TaskModel task) {
    DateTime? deadline = task.deadline;
    DateTime? reminder = task.reminder;
    bool? isCompleted = task.isCompleted;
    int? done = task.doneTimer;
    int? guest = task.guestTimer;
    int? priority = task.priority;
    String? note = task.note;
    String textPriority = getPriorityText(priority);
    String textTimer;
    if(guest != null && guest != 0){
      textTimer = '$done/$guest';
    }else{
      textTimer = '$done';
    }

    String formattedNote = note != null && note.isNotEmpty ? note : 'No Note';
    // Format dates
    String formattedDeadline = deadline != null
        ? DateFormat.yMMMMEEEEd().format(deadline)
        : 'No deadline';
    String formattedReminder = reminder != null
        ? DateFormat('MMMM dd, yyyy - hh:mm a').format(reminder)
        : 'Date unavailable';

    return GestureDetector(
      onTap: () {
        if (isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Since you've already completed the task, you cannot start the Pomodoro timer again."),
              duration:
                  Duration(seconds: 5), // Duration of the snackbar (optional)
            ),
          );
        } else {
          Get.to(() => PomodoroTimerScreen(task: task, goal: widget.goal));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        color: isCompleted! ? Colors.lightGreenAccent[100] : Colors.grey[50],
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Task title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Display deadline and reminder dates
                    Column(
                      children: [
                        if (formattedDeadline != 'No deadline')
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20.0),
                              const SizedBox(width: 4),
                              Text(
                                formattedDeadline,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        if (formattedReminder != 'Date unavailable')
                          Row(
                            children: [
                              const Icon(Icons.alarm, size: 20.0),
                              const SizedBox(width: 4),
                              Text(
                                formattedReminder,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        if (textPriority != "No set priority")
                          Row(
                            children: [
                              const Icon(
                                Icons.flag,
                                size: 16, // Icon size
                              ),
                              const SizedBox(width: 4),
                              const SizedBox(width: 4),
                              Text(
                                textPriority,
                                style: const TextStyle(
                                  fontSize: 12, // Adjusted font size
                                ),
                              ),
                            ],
                          ),
                        if (formattedNote != "No Note")
                          Row(
                            children: [
                              const Icon(Icons.note, size: 20.0),
                              const SizedBox(width: 4),
                              Flexible( // Wrap the Text widget with Flexible
                                child: Text(
                                  formattedNote,
                                  style: const TextStyle(fontSize: 12.0),
                                  overflow: TextOverflow.ellipsis, // Add overflow property for ellipsis
                                  maxLines: 2, // Set the maximum number of lines
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 20, // Icon size
                            ),
                            const SizedBox(width: 4),
                            Text(
                              textTimer,
                              style: const TextStyle(
                                fontSize: 12, // Adjusted font size
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.to(() => TaskEditPage(task: task, goal: widget.goal));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Define the action for deleting a task
                      taskController.deleteTask(task);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show the Add Task dialog
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    final deadlineController = TextEditingController();
    final alertController = TextEditingController();
    final timerController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    int? selectedPriority;
    DateTime? selectedDeadline;
    DateTime? selectedAlert;

    Get.defaultDialog(
      title: 'Add Task',
      content: StatefulBuilder(
        builder: (context, setState) {

          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Task title input field
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                // Task note input field
                TextFormField(
                  controller: noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Task Note',
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                ),
                const SizedBox(height: 8),
                // Icon buttons for date and timer selections
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        _buildIconButton(
                          icon: Icons.calendar_today,
                          color: selectedDeadline != null ? Colors.blue : Colors.grey,
                          onPressed: () => _selectDate(
                              context, setState, deadlineController,
                              selectedDate: selectedDeadline, onDateSelected: (date) {
                            setState(() {
                              if (date.isBefore(DateTime.now())) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Selected Deadline is before the current date and time.'),
                                    duration: Duration(
                                        seconds:
                                        5), // Duration of the snackbar (optional)
                                  ),
                                );
                                selectedDeadline = null;
                                deadlineController.text = '';
                              } else if (selectedAlert == null) {
                                selectedDeadline = date;
                                deadlineController.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              } else if (selectedAlert != null &&
                                  selectedAlert!.isBefore(date)) {
                                selectedDeadline = date;
                                deadlineController.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Selected Deadline is after the reminder date and time.'),
                                    duration: Duration(
                                        seconds:
                                        5), // Duration of the snackbar (optional)
                                  ),
                                );
                                selectedDeadline = null;
                                deadlineController.text = '';
                              }
                            });
                          }),
                        ),
                        const Text(
                          'Deadline',
                          style: TextStyle(
                            fontSize: 12.0, // Adjust the size to your preference
                            fontWeight: FontWeight.bold, // Add font weight
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        _buildIconButton(
                          icon: Icons.flag,
                          color: selectedPriority != null ? Colors.blue : Colors.grey,
                          onPressed: () async {
                            final priority = await _showPriorityInputDialog(context);
                            if (priority != null) {
                              setState(() {
                                selectedPriority = priority;
                              });
                            }
                          },
                        ),
                        const Text(
                          'Priority',
                          style: TextStyle(
                            fontSize: 12.0, // Adjust the size to your preference
                            fontWeight: FontWeight.bold, // Add font weight
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        _buildIconButton(
                          icon: Icons.timer,
                          color: timerController.text.isNotEmpty
                              ? Colors.blue
                              : Colors.grey,
                          onPressed: () async {
                            final guestTimer = await _showTimerInputDialog(context);
                            setState(() {
                              if (guestTimer != null) {
                                timerController.text = guestTimer.toString();
                              }
                            });
                          },
                        ),
                        const Text(
                          'Exp. Timer',
                          style: TextStyle(
                            fontSize: 12.0, // Adjust the size to your preference
                            fontWeight: FontWeight.bold, // Add font weight
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        _buildIconButton(
                          icon: Icons.add_alert,
                          color: selectedAlert != null ? Colors.blue : Colors.grey,
                          onPressed: () => _selectDateTime(
                            context,
                                (newState) => setState(newState),
                            alertController,
                            initialDateTime: DateTime.tryParse(alertController.text),
                            onDateTimeSelected: (datetime) {
                              setState(() {
                                if (datetime.isBefore(DateTime.now())) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Selected Reminder is before the current date and time.'),
                                      duration: Duration(
                                          seconds:
                                          5), // Duration of the snackbar (optional)
                                    ),
                                  );
                                  selectedDeadline = null;
                                  deadlineController.text = '';
                                } else if (selectedDeadline == null) {
                                  selectedAlert = datetime;
                                  alertController.text =
                                      DateFormat('dd/MM/yy HH:mm').format(datetime);
                                } else if (selectedDeadline != null &&
                                    selectedDeadline!.isAfter(datetime)) {
                                  selectedAlert = datetime;
                                  alertController.text =
                                      DateFormat('dd/MM/yy HH:mm').format(datetime);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Selected Reminder is before the Deadline date and time.'),
                                      duration: Duration(
                                          seconds:
                                          5), // Duration of the snackbar (optional)
                                    ),
                                  );
                                  selectedAlert = null;
                                  alertController.text = '';
                                }
                              });
                            },
                          ),
                        ),
                        const Text(
                          'Reminder',
                          style: TextStyle(
                            fontSize: 12.0, // Adjust the size to your preference
                            fontWeight: FontWeight.bold, // Add font weight
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      confirm: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Add the new task
            final newTask = TaskModel(
              title: titleController.text,
              priority: selectedPriority,
              note: noteController.text,
              deadline: selectedDeadline,
              reminder: selectedAlert,
              guestTimer: int.tryParse(timerController.text),
              doneTimer: 0,
              isCompleted: false,
              createdAt: DateTime.now(),
            );

            taskController.addTask(newTask);
            Get.back(); // Close the dialog
          }
        },
        child: const Text('Add Task'),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );

  }

  // Build an icon button for selecting options
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
    );
  }

  // Helper function to show the date picker and update the selected date
  void _selectDate(BuildContext context, StateSetter setState,
      TextEditingController controller,
      {DateTime? selectedDate,
      required void Function(DateTime) onDateSelected}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      onDateSelected(date);
    }
  }

  void _selectDateTime(BuildContext context, StateSetter setState,
      TextEditingController controller,
      {DateTime? initialDateTime,
      required void Function(DateTime) onDateTimeSelected}) async {
    // Step 1: Show the date picker
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    // If the user selected a date
    if (date != null) {
      // Step 2: Show the time picker
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
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
      }
    }
  }

  // Helper function to show timer input dialog and return the selected timer duration
  Future<int?> _showTimerInputDialog(BuildContext context) async {
    int selectedTimer = 0; // Initialize the selected timer value

    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select the sessions of pomodoro'),
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

  String getPriorityText(int? priority) {
    switch (priority) {
      case 0:
        return 'No set priority';
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

  Widget _buildSortMenu() {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        setState(() {
          _selectedSortOption = result;
        });
        _sortTasks(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'priority',
          child: Text('Sort by Priority'),
        ),
        const PopupMenuItem<String>(
          value: 'deadline',
          child: Text('Sort by Deadline'),
        ),
        const PopupMenuItem<String>(
          value: 'reminder',
          child: Text('Sort by Reminder'),
        ),
      ],
      icon: Icon(Icons.sort),
    );
  }

  void _sortTasks(String sortOption) {
    // Implement the sorting logic based on the selected option
    switch (sortOption) {
      case 'priority':
        taskController.fetchSortPriorityTasks();
        print('Sorting by Priority');
        break;
      case 'deadline':
        taskController.fetchSortDeadlineTasks();
        print('Sorting by Deadline');
        break;
      case 'reminder':
        taskController.fetchSortReminderTasks();
        print('Sorting by Reminder');
        break;
      default:
        taskController.fetchSortDeadlineTasks();
        print('Default sorting');
    }
  }
}
