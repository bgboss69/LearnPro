import 'package:LearnPro/models/reward_model.dart';
import '../repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'authentication_repository.dart';

class RewardRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'rewards';
  final _userRepo = Get.put(UserRepository());
  final _authRepo = Get.put(AuthenticationRepository());

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if (email == null) {
      throw Exception('Login to continue');
    }else {
      return _userRepo.getUserId(email);
    }
  }

  Future<void> addReward(RewardModel reward) async {
    try {
      String userId = await getUserData();
      await _db.collection('Users').doc(userId).collection(_collectionName).add(reward.toJson());
    } catch (e) {
      debugPrint('Error adding report: $e');
    }
  }


  Future<void> deleteAllReward() async {
    try {
      String userId = await getUserData();
      final collectionRef = _db.collection('Users').doc(userId).collection(_collectionName);
      final batch = _db.batch();

      final querySnapshot = await collectionRef.get();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error deleting all rewards: $e');
    }
  }

  Future<List<RewardModel>> getRewardSortedByDate() async {
    try {
      String userId = await getUserData();
      final querySnapshot = await _db.collection('Users').doc(userId).collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => RewardModel.fromSnapshot(doc)).toList();
    } catch (e) {
      debugPrint('Error getting rewards: $e');
      return [];
    }
  }


}
