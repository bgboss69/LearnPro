import '../repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/goal_model.dart';
import 'authentication_repository.dart';
// Import the Goal model class

class GoalRepository extends GetxService {
  final _db = FirebaseFirestore.instance;
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());


  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if (email == null) {
      throw Exception('Login to continue');
    }else {
      return _userRepo.getUserId(email);
    }
  }

  // Fetch goals for a specific user
  Future<List<Goal>> fetchGoals() async {
    String userId = await getUserData();
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('Users').doc(userId).collection('Goals').get();

    // Convert documents to Goal objects
    return snapshot.docs.map((doc) => Goal.fromSnapshot(doc)).toList();
  }

  addGoal(Goal goal) async {
    String userId = await getUserData();
    await _db
        .collection("Users")
        .doc(userId)
        .collection('Goals')
        .add(goal.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "You Goal has been created.",
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

  // Update a goal in the specified user's Goals collection
  Future<void> updateGoal(Goal goal) async {
    String userId = await getUserData();
    await _db
        .collection('Users')
        .doc(userId)
        .collection('Goals')
        .doc(goal.id!)
        .update(goal.toJson())
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

  // //Delete a goal from the specified user's Goals collection
  // Future<void> deleteGoal(String goalId) async {
  //   String userId = await getUserData();
  //   await _db
  //       .collection('Users')
  //       .doc(userId)
  //       .collection('Goals')
  //       .doc(goalId)
  //       .delete()
  //       .whenComplete(
  //         () => Get.snackbar("Success", "Deleted",
  //             snackPosition: SnackPosition.BOTTOM,
  //             backgroundColor: Colors.green.withOpacity(0.1),
  //             colorText: Colors.green),
  //       )
  //       .catchError((error, stackTrace) {
  //     Get.snackbar("Error", "Something went wrong. Try again",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent.withOpacity(0.1),
  //         colorText: Colors.red);
  //     print("ERROR - $error");
  //   });
  // }

  Future<void> deleteGoal(String goalId) async {
    String userId = await getUserData();
    WriteBatch batch = _db.batch();

    // Reference to the goal document
    DocumentReference goalDoc = _db.collection('Users').doc(userId).collection('Goals').doc(goalId);
    // Reference to the tasks collection
    CollectionReference tasksCollection = goalDoc.collection('Tasks');
    try {
      // Get all tasks
      QuerySnapshot tasksSnapshot = await tasksCollection.get();
      // Delete each task in a batch
      for (QueryDocumentSnapshot taskDoc in tasksSnapshot.docs) {
        batch.delete(taskDoc.reference);
      }
      // Delete the goal document in the same batch
      batch.delete(goalDoc);
      // Commit the batch
      await batch.commit();
      // Show success message
      Get.snackbar(
        "Success",
        "Deleted",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (error, stackTrace) {
      // Show error message
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("ERROR - $error");
    }
  }

}
