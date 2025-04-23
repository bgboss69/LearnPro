import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String? id;
  final DateTime? createdAt;
  final String? taskId;
  final String? goalId;

  ReportModel({
    this.id,
    required this.createdAt,
    this.taskId,
    this.goalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'goalId': goalId,
      'createdAt': createdAt,
    };
  }

  factory ReportModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
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
    final taskId = data['taskId'] ?? '';
    final goalId = data['goalId'] ?? '';

    // Return a new TaskModel instance
    return ReportModel(
      id: document.id,
      createdAt: createdAt,
      taskId: taskId,
      goalId: goalId,
    );
  }
}
