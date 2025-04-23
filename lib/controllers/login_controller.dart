import '../repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

// TextField Controller to get the data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

// call this Function from Design & it will do the rest
  void loginUser(String email, String password) {
    AuthenticationRepository.instance.loginWithEmailAndPassword(email, password);
  }
}
