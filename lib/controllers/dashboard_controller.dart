import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';
import '../models/goal_model.dart';
import '../models/task_model.dart';
import '../notification_helper.dart';
import '../repository/dashboard_repository.dart';
import '../repository/report_repository.dart';


class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final _dashRepo = Get.put(DashboardRepository());
  final _reportRepo = Get.put(ReportRepository());
  // Reactive list to store tasks
  var tasks = <TaskModel>[].obs;
  var goals = <Goal>[].obs;
  var sortGoals = <Goal>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Call fetchGoals when the controller is initialized
    fetchGoals();
    fetchTasks();
    // fetchReminders();
    fetchReminder();
    fetchDeadline();
  }
  // Fetch goals for the user
  Future<void> fetchGoals() async {
    List<Goal> fetchedGoals = await _dashRepo.fetchGoals();
    goals.assignAll(fetchedGoals);
  }

  // Fetch tasks for the given goal
  Future<void> fetchTasks() async {
    List<TaskModel> fetchedTasks = await _dashRepo.fetchSortTasks();
    List<Goal> fetchedSortGoals = await _dashRepo.getGaols(fetchedTasks);
    tasks.assignAll(fetchedTasks);
    sortGoals.assignAll(fetchedSortGoals);
  }

  Future<int> getCount() async {
    int count = await _reportRepo.getCountByToday();
    return count;
  }

  Future<void> fetchReminder() async {
    try {
      final local = tz.local;
      if (local != null) {
        final now = tz.TZDateTime.now(local);
        List<TaskModel> tasks = await _dashRepo.fetchSortTasks();
        List<TaskModel> reminderTasks = tasks.where((task) => task.reminder != null && task.reminder!.isAfter(now)).toList();

        print("Total tasks with reminders: ${reminderTasks.length}");

        for (var task in reminderTasks) {
          DateTime scheduledDateReminder = task.reminder!;
          String taskTitle = task.title; // Example text value
          int asciiSum = 0;
          for (int i = 0; i < taskTitle.length; i++) {
            int asciiValue = taskTitle.codeUnitAt(i);
            asciiSum += asciiValue;
          }
          asciiSum += asciiSum;

          // Convert DateTime to tz.TZDateTime using local timezone
          final scheduledDateReminderTZ = tz.TZDateTime.from(scheduledDateReminder, local);

          print("Scheduling notification for task: ${task.title} at ${scheduledDateReminderTZ.toString()}");

          await _notificationHelper.scheduleNotification(
            id: asciiSum,
            title: 'Task: ${task.title}',
            body: 'Your task "${task.title}" reminder at "${DateFormat('MMMM dd, yyyy - hh:mm a').format(task.reminder!)}" is reach ',
            scheduledDate: tz.TZDateTime(tz.local, scheduledDateReminderTZ.year,
                scheduledDateReminderTZ.month, scheduledDateReminderTZ.day,
                scheduledDateReminderTZ.hour, scheduledDateReminderTZ.minute),
          );

          print("Notification scheduled for task: ${task.title}");
        }
      } else {
        Get.snackbar(
          "Error",
          "Local timezone is not initialized",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      print("Error fetching tasks reminder: $e");
    }
  }




  Future<void> fetchDeadline() async {
    try {
      // Initialize timezone data
      final local = tz.local;
      if (local != null) {
        final now = tz.TZDateTime.now(local);
        List<TaskModel> tasks = await _dashRepo.fetchSortTasks();
        List<TaskModel> deadlineTasks  = tasks.where((task) => task.deadline != null && task.deadline!.isAfter(now)).toList();
        for (var task in deadlineTasks) {
          DateTime scheduledDateDeadline = task.deadline!;
          String taskTitle = task.title; // Example text value
          int asciiSum = 0;
          for (int i = 0; i < taskTitle.length; i++) {
            int asciiValue = taskTitle.codeUnitAt(i);
            asciiSum += asciiValue;
          }
          final scheduledDateDeadlineTZ = tz.TZDateTime.from(scheduledDateDeadline, local);
          await _notificationHelper.scheduleNotification(
            id: asciiSum,
            title: 'Task: ${task.title}',
            body: 'Your task "${task.title}" deadline at "${DateFormat('MMMM dd, yyyy').format(task.deadline!)}" is reach ',
            scheduledDate: tz.TZDateTime(tz.local, scheduledDateDeadlineTZ.year , scheduledDateDeadlineTZ.month, scheduledDateDeadlineTZ.day, scheduledDateDeadlineTZ.hour, scheduledDateDeadlineTZ.minute),
          );
        }
      } else {
        // Show Snackbar with error message
        Get.snackbar(
          "Error",
          "Local timezone is not initialized",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      print("Error fetching tasks deadline: $e");
    }
  }
  // Future<void> fetchReminders() async {
  //   try {
  //     DateTime now = DateTime.now();
  //     List<TaskModel> tasks = await _dashRepo.fetchSortTasks();
  //     tasks = tasks.where((task) => task.reminder != null && task.reminder!.isAfter(now)).toList();
  //
  //     for (var task in tasks) {
  //       DateTime scheduledDate = task.reminder ?? DateTime.now();
  //       await scheduleNotification(
  //         day: scheduledDate.day,
  //         month: scheduledDate.month,
  //         year: scheduledDate.year,
  //         hour: scheduledDate.hour,
  //         minute: scheduledDate.minute,
  //         title: task.title,
  //         body: 'Your task ${task.title} reminder is due.',
  //       );
  //     }
  //   } catch (e) {
  //     print("Error fetching tasks reminder: $e");
  //   }
  // }

  // Future<bool> scheduleNotification({
  //   required int day,
  //   required int month,
  //   required int year,
  //   required int hour,
  //   required int minute,
  //   required String title,
  //   required String body,
  // }) async {
  //   final awesomeNotifications = AwesomeNotifications();
  //   return await awesomeNotifications.createNotification(
  //     schedule: NotificationCalendar(
  //       day: day,
  //       month: month,
  //       year: year,
  //       hour: hour,
  //       minute: minute,
  //       second: 0,
  //       millisecond: 0,
  //       repeats: false,
  //     ),
  //     content: NotificationContent(
  //       id: Random().nextInt(100),
  //       channelKey: 'scheduled_notification',
  //       title: title,
  //       body: body,
  //     ),
  //   );
  // }
}

