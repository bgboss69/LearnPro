import '../repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../models/task_model.dart';
import 'package:get/get.dart';

import 'authentication_repository.dart';

class DashboardRepository {
  final _db = FirebaseFirestore.instance;
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

  Future<List<Goal>> fetchGoals() async {
    String userId = await getUserData();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('Users').doc(userId).collection('Goals').get();

    // Convert documents to Goal objects
    return snapshot.docs.map((doc) => Goal.fromSnapshot(doc)).toList();
  }

  // Fetch tasks for the goal
  Future<List<TaskModel>> fetchTasks(String userId, Goal goal) async {
    final querySnapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection('Goals')
        .doc(goal.id)
        .collection('Tasks')
        .where('isCompleted', isEqualTo: false)
        .get();

    return querySnapshot.docs
        .map((doc) => TaskModel.fromSnapshot(doc))
        .toList();
  }

  Future<List<TaskModel>> fetchSortTasks() async {
    try {
      String userId = await getUserData();
      List<Goal> goals = await fetchGoals();
      List<TaskModel> allTasks = [];

      for (Goal goal in goals) {
        List<TaskModel> tasks = await fetchTasks(userId, goal);
        allTasks.addAll(tasks);
      }
      // Sort all tasks by deadline
      allTasks.sort((a, b) => (a.deadline ?? DateTime(9999))
          .compareTo(b.deadline ?? DateTime(9999)));

      return allTasks;
    } catch (e) {
      print("Error fetching tasks: $e");
      return []; // or handle the error as appropriate
    }
  }

  // Future<List<TaskModel>> filterTasks() async {
  //   try {
  //     DateTime now = DateTime.now();
  //     List<TaskModel> tasks = await fetchSortTasks();
  //     List<TaskModel> allTasks = [];
  //     allTasks = tasks
  //         .where((task) => task.reminder != null && task.reminder!.isAfter(now))
  //         .toList();
  //     return allTasks;
  //   } catch (e) {
  //     print("Error fetching tasks reminder: $e");
  //     return []; // or handle the error as appropriate
  //   }
  // }

  Future<List<Goal>> getGaols(List<TaskModel> tasks) async {
    try {
      String userId = await getUserData();
      List<Goal> goals = await fetchGoals();
      List<Goal> allGoals = [];
      for (Goal goal in goals) {
        for (TaskModel task in tasks) {
          final taskRef = _db
              .collection('Users')
              .doc(userId)
              .collection('Goals')
              .doc(goal.id)
              .collection('Tasks')
              .doc(task.id);

          final querySnapshot = await taskRef.get();

          if (querySnapshot.exists) {
            allGoals.add(goal);
          }
        }
      }
      return allGoals;
    } catch (e) {
      print("Error get Gaols: $e");
      return []; // or handle the error as appropriate
    }
  }
}
