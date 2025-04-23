import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // Properties of the User model
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;
  final String chance;
  final String profilePictureUrl;
  final List<String> rewardList; // Property for reward IDs

  // Constructor for the User model
  const UserModel({
    this.id,
    required this.email,
    required this.phoneNo,
    required this.fullName,
    required this.password,
    this.chance = "0",
    this.profilePictureUrl = "",
    this.rewardList= const ['defaultRewardID1', 'defaultRewardID2'], // Default non-empty list
  });

  // Convert the model to JSON for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "Phone": phoneNo,
      "FullName": fullName,
      "Password": password,
      "Chance": chance,
      "profilePictureUrl": profilePictureUrl,
      "RewardList": rewardList, // Include the reward list in JSON
    };
  }

  // Create a UserModel from a Firestore document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"] ?? '',
      phoneNo: data["Phone"] ?? '',
      fullName: data["FullName"] ?? '',
      password: data["Password"] ?? '',
      chance: data["Chance"] ?? '0',
      profilePictureUrl: data["profilePictureUrl"] ?? '',
      rewardList: List<String>.from(data["RewardList"] ?? ['defaultRewardID1', 'defaultRewardID2']),
    );
  }
}
