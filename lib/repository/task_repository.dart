import '../repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'package:get/get.dart';

import 'authentication_repository.dart';

class TaskRepository {
  final _db = FirebaseFirestore.instance;
  final String goalId; // Goal ID to fetch tasks from the nested collection

  TaskRepository(this.goalId);

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email == null) {
      throw Exception('Login to continue');
    } else {
      return _userRepo.getUserId(email);
    }
  }

  // Fetch tasks for the goal
  Future<List<TaskModel>> fetchTasks() async {
    String userId = await getUserData();
    final querySnapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection('Goals')
        .doc(goalId)
        .collection('Tasks')
        .get();

    return querySnapshot.docs
        .map((doc) => TaskModel.fromSnapshot(doc))
        .toList();
  }


  Future<List<TaskModel>> fetchSortDeadlineTasks() async {
    try {
      List<TaskModel> tasks = await fetchTasks();
      // Sort tasks first by completion status, then by deadline for incomplete tasks
      tasks.sort((a, b) {
        bool aCompleted = a.isCompleted ?? false;
        bool bCompleted = b.isCompleted ?? false;

        if (aCompleted && !bCompleted) return 1; // a is complete, b is not complete, so a goes after b
        if (!aCompleted && bCompleted) return -1; // a is not complete, b is complete, so a goes before b
        // Both tasks are either complete or incomplete, sort by deadline
        return (a.deadline ?? DateTime(9999)).compareTo(b.deadline ?? DateTime(9999));
      });
      return tasks;
    } catch (e) {
      print("Error fetching tasks: $e");
      return []; // or handle the error as appropriate
    }
  }

  Future<List<TaskModel>> fetchSortReminderTasks() async {
    try {
      List<TaskModel> tasks = await fetchTasks();
      // Sort tasks first by completion status, then by reminder for incomplete tasks
      tasks.sort((a, b) {
        bool aCompleted = a.isCompleted ?? false;
        bool bCompleted = b.isCompleted ?? false;

        if (aCompleted && !bCompleted) return 1; // a is complete, b is not complete, so a goes after b
        if (!aCompleted && bCompleted) return -1; // a is not complete, b is complete, so a goes before b
        // Both tasks are either complete or incomplete, sort by reminder
        return (a.reminder ?? DateTime(9999)).compareTo(b.reminder ?? DateTime(9999));
      });
      return tasks;
    } catch (e) {
      print("Error fetching tasks: $e");
      return []; // or handle the error as appropriate
    }
  }
  Future<List<TaskModel>> fetchSortPriorityTasks() async {
    try {
      List<TaskModel> tasks = await fetchTasks();
      // Sort tasks first by completion status, then by priority for incomplete tasks
      tasks.sort((a, b) {
        bool aCompleted = a.isCompleted ?? false;
        bool bCompleted = b.isCompleted ?? false;

        if (aCompleted && !bCompleted) return 1; // a is complete, b is not complete, so a goes after b
        if (!aCompleted && bCompleted) return -1; // a is not complete, b is complete, so a goes before b
        // Both tasks are either complete or incomplete, sort by priority (1 is the highest priority)
        return (a.priority ?? 5).compareTo(b.priority ?? 5);
      });
      return tasks;
    } catch (e) {
      print("Error fetching tasks: $e");
      return []; // or handle the error as appropriate
    }
  }

  // Add a new task to the nested collection
  Future<void> addTask(TaskModel task) async {
    String userId = await getUserData();
    await _db
        .collection('Users')
        .doc(userId)
        .collection('Goals')
        .doc(goalId)
        .collection('Tasks')
        .add(task.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Added.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green),
    )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }

  // Update an existing task in the nested collection
  Future<void> updateTask(TaskModel task) async {
    String userId = await getUserData();
    final docRef = _db.collection('Users')
        .doc(userId)
        .collection('Goals')
        .doc(goalId)
        .collection('Tasks')
        .doc(task.id)
        .update(task.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Updated.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green),
    )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }

  // Delete a task from the nested collection
  Future<void> deleteTask(String? taskId) async {
    String userId = await getUserData();
    await _db
        .collection('Users')
        .doc(userId)
        .collection('Goals')
        .doc(goalId)
        .collection('Tasks')
        .doc(taskId)
        .delete()
        .whenComplete(
          () => Get.snackbar("Success", "Deleted.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green),
    )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    });
  }
}
