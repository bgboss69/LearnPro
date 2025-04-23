import '../repository/authentication_repository.dart';
import '../repository/user_repository.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

import '../pages/update_profile_page.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();


// TextField Controller to get the data from TextFields
  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());


  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if (email == null) {
      throw Exception('Login to continue');
    }else {
      return _userRepo.getUserDetails(email);
    }
  }

  Future<List<UserModel>> getAllUsers() async => await _userRepo.allUser();

  updateRecord(UserModel user , String pastPassword) async{
    await _userRepo.changePassword(user, pastPassword);
    await _userRepo.updateUserRecord(user);
    Get.to(const UpdateProfilePage());
  }

  updateReward(UserModel user) async{
    await _userRepo.updateUserRecord(user);
  }
}
