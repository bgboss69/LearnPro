import '../repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/report_model.dart';
import 'package:get/get.dart';

import 'authentication_repository.dart';

class ReportRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'reports';
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

  Future<void> addReport(ReportModel report) async {
    try {
      String userId = await getUserData();
      await _db.collection('Users').doc(userId).collection(_collectionName).add(report.toJson());
    } catch (e) {
      debugPrint('Error adding report: $e');
    }
  }



  Future<void> updateReport(ReportModel report) async {
    try {
      String userId = await getUserData();
      await _db.collection('Users').doc(userId).collection(_collectionName).doc(report.id).update(report.toJson());
    } catch (e) {
      debugPrint('Error updating report: $e');
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      String userId = await getUserData();
      await _db.collection('Users').doc(userId).collection(_collectionName).doc(reportId).delete();
    } catch (e) {
      debugPrint('Error deleting report: $e');
    }
  }

  Future<int> getCountByToday() async {
    String userId = await getUserData();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    int count = 0;
    // Firestore query to get documents created today
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection(_collectionName)
        .where('createdAt', isGreaterThanOrEqualTo: today)
        .get();

    // Iterate through the documents and count the number created today
    for (var doc in querySnapshot.docs) {
      DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();
      DateTime date = DateTime(createdAt.year, createdAt.month, createdAt.day);


      // Check if the document was created today and increment the count
      if (date == today) {
        count++;
      }
    }

    return count;
  }

  Future<Map<DateTime, int>> getCountByWeek() async {
    String userId = await getUserData();
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    DateTime oneWeekAgo = currentDate.subtract(Duration(days: 6));
    // Initialize a map to store the count for each date
    Map<DateTime, int> countByDate = {};
    // Iterate over the dates from one week ago until today
    for (int i = 0; i <= 6; i++) {
      DateTime date = oneWeekAgo.add(Duration(days: i));
      countByDate[date] = 0; // Initialize count to 0 for each date
    }
    // Firestore query to get documents created within the last week
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection(_collectionName)
        .where('createdAt', isGreaterThan: oneWeekAgo)
        .get();
    // Iterate through the documents and count the number created on each date
    querySnapshot.docs.forEach((doc) {
      DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();
      DateTime date = DateTime(createdAt.year, createdAt.month, createdAt.day);

      // Increment the count for the current date
      countByDate.update(date, (value) => value + 1, ifAbsent: () => 1);
    });
    return countByDate;
  }

  Future<Map<DateTime, int>> getCountByMonth() async {
    String userId = await getUserData();
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    DateTime currentMonth = DateTime(currentDate.year, currentDate.month, 1);

    // Initialize a map to store the count for each week
    Map<DateTime, int> countByWeek = {};

    // Iterate over the weeks from the start of the month until today
    for (int i = 0; i < 35; i += 7) {
      DateTime date = currentMonth.add(Duration(days: i));
      countByWeek[date] = 0; // Initialize count to 0 for each week start date
    }

    // Firestore query to get documents created within the last 28 days
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection(_collectionName)
        .where('createdAt', isGreaterThan: currentMonth)
        .get();

    // Iterate through the documents and count the number created in each week
    querySnapshot.docs.forEach((doc) {
      DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();
      DateTime date = DateTime(createdAt.year, createdAt.month, createdAt.day);
      for (int i = 0; i < 28; i += 7) {
        DateTime weekStart = currentMonth.add(Duration(days: i));
        DateTime weekEnd = weekStart.add(Duration(days: 7));
        if (createdAt.isAfter(weekStart) && createdAt.isBefore(weekEnd)) {
          countByWeek.update(weekStart, (value) => value + 1, ifAbsent: () => 1);
          break; // Once the correct week is found, break the loop
        }
      }
    });

    return countByWeek;
  }

  Future<Map<DateTime, int>> getPreviousByMonth() async {
    String userId = await getUserData();
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month - 1, 1);
    DateTime endDate = DateTime(now.year, now.month, 1);
    // Initialize a map to store the count for each week
    Map<DateTime, int> countByWeek = {};

    // Iterate over the weeks from 28 days ago until today
    for (int i = 0; i < 35; i += 7) {
      DateTime date = startDate.add(Duration(days: i));
      countByWeek[date] = 0; // Initialize count to 0 for each week start date
    }

    // Firestore query to get documents created within the last 28 days
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection(_collectionName)
        .where('createdAt', isGreaterThan: startDate)
        .get();

    // Iterate through the documents and count the number created in each week
    querySnapshot.docs.forEach((doc) {
      DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();
      for (int i = 0; i < 35; i += 7) {
        DateTime weekStart = startDate.add(Duration(days: i));
        DateTime weekEnd = weekStart.add(Duration(days: 7));
        if (createdAt.isAfter(weekStart) && createdAt.isBefore(weekEnd)) {
          countByWeek.update(weekStart, (value) => value + 1, ifAbsent: () => 1);
          break; // Once the correct week is found, break the loop
        }
      }
    });

    return countByWeek;
  }

  Future<Map<DateTime, int>> getMonth(int year, int month) async {
    String userId = await getUserData();
    // Calculate start and end dates based on the provided year and month
    DateTime startDate = DateTime(year, month, 1);
    DateTime endDate = DateTime(year, month + 1, 1);

    // Initialize a map to store the count for each week
    Map<DateTime, int> countByWeek = {};

    // Iterate over the weeks within the month
    for (int i = 0; i < endDate.difference(startDate).inDays; i += 7) {
      DateTime date = startDate.add(Duration(days: i));
      countByWeek[date] = 0; // Initialize count to 0 for each week start date
    }

    // Firestore query to get documents created within the specified month
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection(_collectionName)
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .get();

    // Iterate through the documents and count the number created in each week
    querySnapshot.docs.forEach((doc) {
      DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();
      for (int i = 0; i < endDate.difference(startDate).inDays; i += 7) {
        DateTime weekStart = startDate.add(Duration(days: i));
        DateTime weekEnd = weekStart.add(Duration(days: 7));
        if (createdAt.isAfter(weekStart) && createdAt.isBefore(weekEnd)) {
          countByWeek.update(weekStart, (value) => value + 1, ifAbsent: () => 1);
          break; // Once the correct week is found, break the loop
        }
      }
    });

    return countByWeek;
  }


}
