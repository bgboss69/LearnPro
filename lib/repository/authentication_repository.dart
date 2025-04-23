import '../pages/dashboard.dart';
import '../pages/welcome_screen.dart';
import '../repository/exceptions/signup_email_password_failure.dart';
import '../repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';


class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final _auth =FirebaseAuth.instance;
  final userRepo = Get.put(UserRepository());
  late final Rx<User?> firebaseUser;

  //control + o
  @override
  void onReady() {
    firebaseUser = Rx<User?> (_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }
  _setInitialScreen(User? user){
    user == null ? Get.offAll(()=> const LearnProWelcomeScreen()) : Get.offAll(()=> const Dashboard());
  }

  Future <void> createUserWithEmailAndPassword(String email, String password) async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ?
      Get.offAll(()=> const Dashboard()):
      Get.offAll(()=> const LearnProWelcomeScreen());
    } on FirebaseAuthException catch(e){
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      Get.snackbar('FIREBASE AUTH EXCEPTION', ex.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1));
      throw ex;
    } catch (_){
      const ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      Get.snackbar('EXCEPTION', ex.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1));
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      UserModel user = await userRepo.getUserDetails(email);
      await userRepo.updateUserPassword(user,password);
      firebaseUser.value != null ? Get.offAll(() => const Dashboard())
          : Get.offAll(() => const LearnProWelcomeScreen());
    } on FirebaseAuthException catch (e) {
      // Handle specific authentication exceptions
      if (e.code == 'user-not-found') {
        // Navigate to appropriate screen or display error message
        Get.snackbar('Error', 'No user found for that email.', snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1));
      } else if (e.code == 'wrong-password') {
        // Navigate to appropriate screen or display error message
        Get.snackbar('Error', 'Wrong password provided for that user.', snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1));
      } else {
        // Handle other FirebaseAuthException cases or generic error
        print('FirebaseAuthException: ${e.code}');
        Get.snackbar('Error', 'An unexpected error occurred.', snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1));
      }
    } catch (e) {
      // Handle other non-FirebaseAuthException errors
      print('Error: $e');
      Get.snackbar('Error', 'An unexpected error occurred.', snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1));
    }
  }

  Future <void> logout() async => await _auth.signOut();

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email has been sent to $email',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.greenAccent.withOpacity(0.1));
    } catch (e) {
      // Handle specific error cases
      if (e is FirebaseAuthException) {
        // FirebaseAuthException can contain specific error codes and messages
        if (e.code == 'auth/invalid-email') {
          Get.snackbar('Error', 'Invalid email address', snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1));
        } else if (e.code == 'auth/user-not-found') {
          Get.snackbar('Error', 'No user found for that email', snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1));
        } else {
          Get.snackbar('Error', 'Failed to send password reset email', snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent.withOpacity(0.1));
        }
      } else {
        // Catch other potential errors
        Get.snackbar('Error', 'An unexpected error occurred', snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1));
      }
    }
  }

}