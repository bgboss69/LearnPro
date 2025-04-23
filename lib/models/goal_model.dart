import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String? id;
  late final String title;
  late final String? note;
  final DateTime? createdAt;
  final bool? isCompleted;

  Goal({
    this.id,
    required this.title,
    this.note,
    this.createdAt,
    this.isCompleted,
  });


  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "note": note,
      "createdAt": createdAt,
      "isCompleted": isCompleted,
    };
  }


  factory Goal.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();

    if (data == null) {
      // If data is null, handle the case as per your app's requirements
      throw Exception('Document data is null');
    }

    String title = data['title'] ?? '';
    String note = data['note'] ?? '';
    DateTime createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }

    //make
    bool isCompleted = data['isCompleted'] ?? false;

    // Create and return a TaskModel instance
    return Goal(
      id: document.id,
      title: title,
      note: note,
      createdAt: createdAt,
      isCompleted: isCompleted,
    );
  }
}
