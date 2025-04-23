import '../models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

import '../models/goal_model.dart';

class TimerRepository extends GetxController {
  static TimerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> updateBoth(UserModel user, Goal goal, TaskModel task) async {
    final userUpdateFuture = _db.collection("Users").doc(user.id).update(user.toJson());

    final taskDocRef = _db
        .collection('Users')
        .doc(user.id)
        .collection('Goals')
        .doc(goal.id)
        .collection('Tasks')
        .doc(task.id);

    final taskUpdateFuture = taskDocRef.update(task.toJson());

    try {
      // Wait for both updates to complete
      await Future.wait([userUpdateFuture, taskUpdateFuture]);
      // If no exception is thrown, both updates were successful
      Get.snackbar(
        "Success",
        "Update successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.white,
      );
    } catch (error, stackTrace) {
      // If any of the updates fail, catch the error and display error snackbar
      Get.snackbar(
        "Error",
        "Something went wrong with the update function. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.white,
      );
      print("ERROR - $error");
    }
  }
}