import '../repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();

// TextField Controller to get the data from TextFields
  final email = TextEditingController();

// call this Function from Design & it will do the rest
  void resetPassword(String email) {
    AuthenticationRepository.instance.resetPassword(email: email);
  }
}
