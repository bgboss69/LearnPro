import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String title;
  final int? priority;
  final String? note;
  final int? doneTimer;
  final int? guestTimer;
  final DateTime? deadline;
  final DateTime? reminder;
  final DateTime? createdAt;
  final bool? isCompleted;

  TaskModel({
    this.id,
    required this.title,
    this.priority,
    this.note,
    this.doneTimer,
    this.guestTimer,
    this.deadline,
    this.reminder,
    this.createdAt,
    this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'note': note,
      'guestTimer': guestTimer,
      'doneTimer': doneTimer,
      'deadline': deadline,
      'reminder': reminder,
      'createdAt': createdAt,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();

    if (data == null) {
      // Handle the case where document data is null
      throw Exception('Document data is null');
    }

    // Parse the various fields from data
    final title = data['title'] ?? '';
    final priority = data['priority'] as int? ?? 5;

    DateTime? deadline;
    if (data['deadline'] is Timestamp) {
      deadline = (data['deadline'] as Timestamp).toDate();
    } else {
      deadline = null;
    }

    DateTime? reminder;
    if (data['reminder'] is Timestamp) {
      reminder = (data['reminder'] as Timestamp).toDate();
    } else {
      reminder = null;
    }

    final note = data['note'] ?? '';
    final guestTimer = data['guestTimer'] as int? ?? 0;
    final doneTimer = data['doneTimer'] as int? ?? 0;

    DateTime createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now(); // Use current date and time as fallback
    }

    final isCompleted = data['isCompleted'] as bool? ?? false;

    // Return a new TaskModel instance
    return TaskModel(
      id: document.id,
      title: title,
      priority: priority,
      note: note,
      guestTimer: guestTimer,
      doneTimer: doneTimer,
      deadline: deadline,
      reminder: reminder,
      createdAt: createdAt,
      isCompleted: isCompleted,
    );
  }
}
