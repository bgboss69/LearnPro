import 'package:cloud_firestore/cloud_firestore.dart';

class RewardModel {
  final String? id;
  final DateTime? createdAt;
  final String? reward;

  RewardModel({
    this.id,
    required this.createdAt,
    this.reward,
  });

  Map<String, dynamic> toJson() {
    return {
      'reward': reward,
      'createdAt': createdAt,
    };
  }

  factory RewardModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();

    if (data == null) {
      // Handle the case where document data is null
      throw Exception('Document data is null');
    }

    DateTime? createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      createdAt = null;
    }
    final reward = data['reward'] ?? '';

    // Return a new TaskModel instance
    return RewardModel(
      id: document.id,
      createdAt: createdAt,
      reward: reward,

    );
  }
}
