import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../controllers/report_controller.dart';
import '../models/goal_model.dart';
import '../models/task_model.dart';
import '../notification_helper.dart';
import '../repository/timmer_repository.dart';
import 'package:get/get.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../repository/authentication_repository.dart';
import '../repository/user_repository.dart';

class PomodoroTimer {
  final int workDuration = 25 * 60; // 25 minutes in seconds
  final int shortBreakDuration = 5 * 60; // 5 minutes in seconds
  final int longBreakDuration = 15 * 60; // 15 minutes in seconds (after 4 cycles)
  final _userRepo = Get.put(UserRepository());
  final _authRepo = Get.put(AuthenticationRepository());
  final _timerRepo = Get.put(TimerRepository());
  final _reportController = Get.put(ReportController());
  final NotificationHelper _notificationHelper = NotificationHelper();

  int cyclesCompleted = 0; // Track completed cycles
  int currentDuration = 0; // Current timer duration
  Timer? timer; // Timer instance
  final player = AudioPlayer();
  late final TaskModel newTask;
  late final Goal newGoal;
  int? doneTimer;
  int? guestTimer;

  PomodoroTimer(Goal goal, TaskModel task) {
    newTask = task;
    newGoal = goal;
    doneTimer = newTask.doneTimer;
    guestTimer = newTask.guestTimer;
  }

  // PomodoroTimer(String goalId) :;

  Future<void> update() async {
    bool? isCompleted = newTask.isCompleted;
    if (doneTimer != null) {
      doneTimer = (doneTimer ?? 0) + 1;
      if (guestTimer != null && guestTimer != 0) {
        if (doneTimer! >= guestTimer!) {
          guestTimer = doneTimer;
          if (isCompleted != null) {
            isCompleted = true;
          }
        }
      }
    }

    UserModel user = await getUserData();
    // Handle the end of a work cycle with the user data
    int chance = int.parse(user.chance);
    // Create a random number generator
    Random random = Random();
    // Generate a random number between 0 and 4
    int randomNumber = random.nextInt(5);
    // 20% chance to increment chance (1 in 5)
    // randomNumber= 0 ;
    if (randomNumber == 0) {
      chance++;
      _notificationHelper.pushNotification(
        title: 'Congratulations!',
        body: 'You gained a chance with a 20% win rate! You can use the chance on the roulette page.',
      );
    }
    final newUser = UserModel(
      id: user.id,
      email: user.email,
      password: user.password,
      fullName: user.fullName,
      phoneNo: user.phoneNo,
      profilePictureUrl: user.profilePictureUrl,
      chance: chance.toString(),
      rewardList: user.rewardList,);
    final updatedTask = TaskModel(
      id: newTask.id,
      title: newTask.title,
      note: newTask.note,
      deadline: newTask.deadline,
      reminder: newTask.reminder,
      priority: newTask.priority,
      guestTimer: guestTimer,
      doneTimer: doneTimer,
      isCompleted: isCompleted,
      createdAt: newTask.createdAt,);
    await _timerRepo.updateBoth(newUser, newGoal, updatedTask);
    final report = ReportModel(
      id: newTask.id,
      createdAt: DateTime.now(),
      goalId: newGoal.id,
      taskId: newTask.id,
    );
    _reportController.addReport(report);
  }

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email == null) {
      throw Exception('Login to continue');
    } else {
      return _userRepo.getUserDetails(email);
    }
  }

  void startWork(Function(int) updateTime, Function() onWorkEnd) {
    currentDuration = workDuration;
    startTimer(updateTime, onWorkEnd);
  }

  void startShortBreak(Function(int) updateTime) {
    currentDuration = shortBreakDuration;
    startBreakTimer(updateTime);
  }

  void startLongBreak(Function(int) updateTime) {
    currentDuration = longBreakDuration;
    startBreakTimer(updateTime);
  }

  void startTimer(Function(int) updateTime, Function() onWorkEnd) {
    // Cancel any existing timer
    timer?.cancel();

    // Start the timer with periodic updates
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (currentDuration > 0) {
        // Decrement the remaining time and update the timer on the UI
        currentDuration--;
        updateTime(currentDuration);
      } else {
        // Timer has ended, cancel the timer
        timer.cancel();
        cyclesCompleted++;
        await playNotificationSound();
        // Call the update function to handle the end of the work cycle
        await update();

        onWorkEnd();
      }
    });
  }

  void startBreakTimer(Function(int) updateTime) {
    // Cancel any existing timer
    timer?.cancel();

    // Start the timer with periodic updates
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (currentDuration > 0) {
        // Decrement the remaining time and update the timer on the UI
        currentDuration--;
        updateTime(currentDuration);
      } else {
        // Break period has ended, cancel the timer
        await playNotificationSound();
        timer.cancel();
      }
    });
  }

  void pauseTimer() {
    // Cancel the current timer
    timer?.cancel();
  }

  void resumeTimer(Function(int) updateTime) {
    // Start the timer again with the remaining duration
    if (currentDuration > 0) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (currentDuration > 0) {
          currentDuration--;
          updateTime(currentDuration);
        } else {
          timer.cancel();
          cyclesCompleted++;
          await playNotificationSound();
        }
      });
    }
  }

  void reset() {
    timer?.cancel();
    currentDuration = 0;
    cyclesCompleted = 0;
  }

  Future<void> playNotificationSound() async {
    await player.play(AssetSource('notification/confirmation.mp3'));
  }
}
