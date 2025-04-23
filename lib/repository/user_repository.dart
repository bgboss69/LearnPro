import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "You account has been created.",
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

  Future<void> deleteUser(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).delete().whenComplete(
            () {
          // Display success message
          Get.snackbar("Success", "User deleted successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green);
        },
      );
    } catch (error) {
      // Handle error
      Get.snackbar("Error", "Failed to delete user. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print("ERROR - $error");
    }
  }
  // profile
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      throw Exception('User not found');
    }
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<String> getUserId(String email) async {
    final snapshot =
    await _db.collection("Users").where("Email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      throw Exception('User not found');
    }
    final userDocRef = snapshot.docs.first.reference;

    // Return the user ID
    return userDocRef.id;
  }

  Future<List<UserModel>> allUser() async {
    final snapshot = await _db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    // list record
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Update successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
          Get.snackbar("Error", "Something went wrong with the update function. Try again",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1),
              colorText: Colors.red);
          print("ERROR - $error");
        });
  }

  Future<void> updateUserPassword(UserModel user, String password) async {
    try {
      await FirebaseFirestore.instance.collection("Users").doc(user.id).update({
        'Password': password,
      });
    } catch (error) {
      Get.snackbar(
        "Error",
        "Something went wrong with the update function. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("ERROR - $error");
    }
  }


  Future<void> changePassword(UserModel userData, String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create the AuthCredential using email and current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: userData.email,
        password: currentPassword,
      );

      try {
        // Re-authenticate the user
        await user.reauthenticateWithCredential(credential);
        // Once re-authenticated, proceed to change the password
        await user.updatePassword(userData.password);
        print('Password changed successfully.');
      } catch (e) {
        print('Error changing password: $e');
      }
    } else {
      print('No user is signed in.');
    }
  }

}
