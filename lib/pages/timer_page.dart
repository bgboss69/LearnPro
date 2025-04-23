import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../pages/dashboard.dart';
import 'package:flutter/material.dart';
import '../controllers/timer_controller.dart';
import '../controllers/task_controller.dart';
import '../models/goal_model.dart';
import '../models/task_model.dart';
import 'goal_page.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PomodoroTimerScreen extends StatefulWidget {
  final TaskModel task;
  final Goal goal;

  const PomodoroTimerScreen(
      {super.key, required this.task, required this.goal});

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  late final newGoal = widget.goal;
  late final newTask = widget.task;

  late final PomodoroTimer pomodoroTimer = PomodoroTimer(newGoal, newTask);
  late final TaskController controller;
  int remainingTime = 0; // Remaining time in seconds
  String status = 'Ready'; // Timer status (Work, Break, etc.)
  bool isPaused = false;
  int completedCycles = 0; // Number of completed cycles

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    pomodoroTimer.timer?.cancel();
    super.dispose();
  }

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  GlobalKey pomodoroKey = GlobalKey();
  GlobalKey completeKey = GlobalKey();
  GlobalKey startKey = GlobalKey();
  GlobalKey pauseKey = GlobalKey();
  GlobalKey resetKey = GlobalKey();

  void _showTutorialCoachmark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      pulseEnable: false,
      colorShadow: Colors.black54,
      onClickTarget: (target) {
        print("${target.identify}");
      },
      // hideSkip: true,
      alignSkip: Alignment.topRight,
      onFinish: () {
        print("Finish");
      },
    )..show(context: context);
  }

  void _initTarget() {
    targets = [
      // pomodoro
      TargetFocus(
        identify: "pomodoro-key",
        keyTarget: pomodoroKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "A Pomodoro consists of a 25-minute work session followed by a 5-minute break. After completing 4 Pomodoros, take a longer break of 15 minutes to recharge.",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      // Complete Pomodoro Cycle
      TargetFocus(
        identify: "complete-key",
        keyTarget: completeKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "When you complete one Pomodoro cycle, the completed cycles will increase. You'll have a 20% chance to win a reward spin.",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      // Start Pomodoro
      TargetFocus(
        identify: "start-key",
        keyTarget: startKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Click here to start the Pomodoro timer.",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      // Pause Pomodoro
      TargetFocus(
        identify: "pause-key",
        keyTarget: pauseKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Click here to pause the Pomodoro timer.",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),
      // Reset Pomodoro
      TargetFocus(
        identify: "reset-key",
        keyTarget: resetKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Click here to reset the completed cycles.",
                onNext: () {
                  controller.next();
                },
                onSkip: () {
                  controller.skip();
                },
              );
            },
          )
        ],
      ),

    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pomodoro Timer',
          key: pomodoroKey,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Get.offAll(() => const Dashboard());
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: IconButton(
              onPressed: () {
                _showTutorialCoachmark();
              },
              icon: const Icon(Icons.info_outline, color: Colors.black),
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        padding: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: status == 'Work'
                ? [Colors.red, Colors.orange]
                : [Colors.black, Colors.indigo],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              status == 'Work'
                  ? 'assets/json/work_animation.json'
                  : 'assets/json/break_animation.json',
              height: 200,
            ),
            Text(
              'Completed Cycles: $completedCycles',
              key: completeKey,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(remainingTime),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              status,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: startKey,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      status = "Work";
                      pomodoroTimer.startWork(updateTime, handleTimerEnd);
                    });
                  },
                  child:const Text(
                    'Start Work',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  key: pauseKey,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPaused) {
                        pomodoroTimer.resumeTimer(updateTime);
                      } else {
                        pomodoroTimer.pauseTimer();
                      }
                      isPaused = !isPaused;
                    });
                  },
                  child: Text(
                    isPaused ? 'Resume' : 'Pause',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  key: resetKey,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    pomodoroTimer.reset();
                    setState(() {
                      remainingTime = 0;
                      status = 'Reset';
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateTime(int newTime) {
    setState(() {
      remainingTime = newTime;
    });
  }

  void handleTimerEnd() async {
    if (mounted) {
      if (status == 'Work') {
        if (pomodoroTimer.cyclesCompleted % 4 == 0) {
          status = 'Break';
          completedCycles++;
          pomodoroTimer.startLongBreak(updateTime);
        } else {
          status = 'Break';
          completedCycles++;
          pomodoroTimer.startShortBreak(updateTime);
        }
      } else {
        status = 'Work';
        pomodoroTimer.startWork(updateTime, handleTimerEnd);
        completedCycles++; // Increment completed cycles
      }
      if (mounted) {
        setState(() {}); // Update the UI if the widget is still mounted
      }
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class CoachmarkDesc extends StatefulWidget {
  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = "Skip",
    this.next = "Next",
    this.onSkip,
    this.onNext,
  });

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 20,
      duration: const Duration(milliseconds: 800),
    )..repeat(min: 0, max: 20, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animationController.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(widget.skip),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: widget.onNext,
                  child: Text(widget.next),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}