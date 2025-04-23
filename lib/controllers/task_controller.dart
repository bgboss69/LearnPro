import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';
import '../repository/task_repository.dart';

class TaskController extends GetxController {
  // TaskRepository instance
  final TaskRepository _taskRepo;
  // Reactive list to store tasks
  var tasks = <TaskModel>[].obs;

  TaskController(String goalId) : _taskRepo = Get.put(TaskRepository(goalId)) {
    fetchTasks();
  }
  @override
  void onInit() {
    super.onInit();
    fetchSortDeadlineTasks();
    // Call fetchGoals when the controller is initialized
    // fetchTasks();
  }
  // Fetch tasks for the given goal
  Future<void> fetchTasks() async {
    List<TaskModel> fetchedTasks = await _taskRepo.fetchTasks();
    tasks.assignAll(fetchedTasks);
  }
  Future<void> fetchSortDeadlineTasks() async {
    List<TaskModel> fetchedTasks = await _taskRepo.fetchSortDeadlineTasks();
    tasks.assignAll(fetchedTasks);
  }
  Future<void> fetchSortPriorityTasks() async {
    List<TaskModel> fetchedTasks = await _taskRepo.fetchSortPriorityTasks();
    tasks.assignAll(fetchedTasks);
  }
  Future<void> fetchSortReminderTasks() async {
    List<TaskModel> fetchedTasks = await _taskRepo.fetchSortReminderTasks();
    tasks.assignAll(fetchedTasks);
  }
  // Add a new task for the goal
  Future<void> addTask(TaskModel task) async {
    await _taskRepo.addTask(task);
    // Refresh the list of tasks
    await fetchTasks();
  }

  // Update an existing task
  Future<void> updateTask(TaskModel task) async {
    await _taskRepo.updateTask(task);
    // Refresh the list of tasks
    await fetchTasks();
  }

  // Delete a task
  Future<void> deleteTask(TaskModel task) async {
    await _taskRepo.deleteTask(task.id);
    // Refresh the list of tasks
    // Refresh the list of goals
    await fetchTasks();
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(TaskModel task) async {
    await updateTask(task);
    await fetchTasks();
  }
}













// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/task_model.dart';
// import 'package:get/get.dart';
//
// class TaskController extends GetxController {
//   static TaskController get instance => Get.find();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Collection name in Firestore where tasks are stored.
//   final CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');
//
//   // Create a new task in Firestore
//   Future<void> createTask(TaskModel task) async {
//     try {
//       await tasksCollection.add({
//         'title': task.title,
//         'priority': task.priority,
//         'deadline': task.deadline,
//         'reminder': task.reminder,
//         'note': task.note,
//         'status': task.status,
//         'taskListID': task.taskListID,
//         'pomodoroID': task.pomodoroID,
//         'userID': task.userID,
//         'createdAt': task.createdAt,
//         'isCompleted': task.isCompleted,
//       });
//     } catch (e) {
//       // Handle any errors during task creation
//       print('Error creating task: $e');
//     }
//   }
//
//   // Read tasks from Firestore
//   Stream<QuerySnapshot> getTasksStream() {
//     return tasksCollection.snapshots();
//   }
//
//   // Update an existing task in Firestore
//   Future<void> updateTask(Task task) async {
//     try {
//       await tasksCollection.doc(task.id).update({
//         'title': task.title,
//         'priority': task.priority,
//         'deadline': task.deadline,
//         'reminder': task.reminder,
//         'note': task.note,
//         'status': task.status,
//         'taskListID': task.taskListID,
//         'pomodoroID': task.pomodoroID,
//         'userID': task.userID,
//         'createdAt': task.createdAt,
//         'isCompleted': task.isCompleted,
//       });
//     } catch (e) {
//       // Handle any errors during task update
//       print('Error updating task: $e');
//     }
//   }
//
//   // Delete a task from Firestore
//   Future<void> deleteTask(String taskId) async {
//     try {
//       await tasksCollection.doc(taskId).delete();
//     } catch (e) {
//       // Handle any errors during task deletion
//       print('Error deleting task: $e');
//     }
//   }
// }