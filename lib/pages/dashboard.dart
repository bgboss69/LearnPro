import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../controllers/dashboard_controller.dart';
import '../pages/reward_page.dart';
import '../pages/spin_wheel.dart';
import '../pages/timer_page.dart';
import '../widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/goal_model.dart';
import 'goal_detail_page.dart';
import 'goal_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = Get.put(DashboardController());
  int focusTimeCount = 0; // Initialize the focus time count
  int completedTaskCount = 0; // Initialize the completed task count

  // Coachmart properties
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey menuKey = GlobalKey();
  GlobalKey goalKey = GlobalKey();
  GlobalKey rewardKey = GlobalKey();
  GlobalKey rouletteKey = GlobalKey();
  GlobalKey focusTimeTodayKey = GlobalKey();
  GlobalKey taskDoneTodayKey = GlobalKey();
  GlobalKey goalDetailKey = GlobalKey();
  GlobalKey taskDetailKey = GlobalKey();
  @override
    void initState() {
      super.initState();
      fetchData(); // Fetch data when the widget initializes
      _requestPermissions();
    }

  Future<void> _requestPermissions() async {
    final notificationStatus = await Permission.notification.request();
    if (notificationStatus.isGranted) {
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      if (alarmStatus.isGranted) {
      } else if (alarmStatus.isDenied) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Please grant permission to use exact alarms for notifications.'),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else if (notificationStatus.isDenied) {
      showDialog(context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Please grant permission to receive notifications.'),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void fetchData() async {
    // Fetch focus time count and completed task count asynchronously
    completedTaskCount = await controller.getCount();
    focusTimeCount = 25 * completedTaskCount;
    setState(() {}); // Update the UI after fetching the data
  }


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
      // Menu
      TargetFocus(
        identify: "menu-key",
        keyTarget: menuKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "This button opens the sidebar to show all navigation options.",
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

      // Goal
      TargetFocus(
        identify: "goal-key",
        keyTarget: goalKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Navigate to the goals page to create, read, update, or delete goals.",
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

      // Reward
      TargetFocus(
        identify: "reward-key",
        keyTarget: rewardKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Navigate to the rewards page to create, read, update, or delete rewards.",
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

      // Roulette
      TargetFocus(
        identify: "roulette-key",
        keyTarget: rouletteKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Navigate to the roulette page and rotate the wheel to win rewards.",
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

      // Focus Time Today
      TargetFocus(
        identify: "focus-time-today-key",
        keyTarget: focusTimeTodayKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "View the focus time today calculated by the number of tasks done multiplied by 25 minutes.",
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

      // Tasks Done Today
      TargetFocus(
        identify: "tasks-done-today-key",
        keyTarget: taskDoneTodayKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "View the number of tasks done today.",
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

      // Goal Details
      TargetFocus(
        identify: "goal-detail-key",
        keyTarget: goalDetailKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "View all goals in the database. Click to navigate to the goal details page for CRUD operations on the tasks.",
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

      // Task Details
      TargetFocus(
        identify: "task-detail-key",
        keyTarget: taskDetailKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "Navigate to the Pomodoro page. Completing a task increases the chance of a reward.",
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
        leading: IconButton(
          icon: Icon(Icons.menu,key: menuKey,),
          onPressed: () {
            showLeftMenu(context);
          },
          tooltip: MaterialLocalizations.of(context).showMenuTooltip,
        ),
        title: Text(
          "Dashboard",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
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
                // Future.delayed(const Duration(seconds: 1), () {
                //   _showTutorialCoachmark();
                // });
                // AuthenticationRepository.instance.logout();
                // _notificationHelper.pushNotification(
                //   title: 'Test Notification',
                //   body: 'This is a test notification body',
                // );
              },
              icon: const Icon(Icons.info_outline, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const GoalPage());
                      },
                      child: Container(
                        key: goalKey,
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.lightBlueAccent],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.architecture_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Goal',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const RewardPage());
                      },
                      child: Container(
                        key: rewardKey,
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.green, Colors.lightGreenAccent],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.redeem,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Rewards',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const SpinWheel());
                      },
                      child: Container(
                        key: rouletteKey,
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.orange, Colors.deepOrangeAccent],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videogame_asset_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Roulette Wheel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      key: focusTimeTodayKey,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Focused Time Today:",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "$focusTimeCount min",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Container(
                      key: taskDoneTodayKey,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tasks Done Today:",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "$completedTaskCount",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              key: goalDetailKey,
              "Goals",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() {
                  if (controller.goals.isEmpty) {
                    return Center(child: Text("No goals. Please create one."));
                  }
                  return ListView.separated(
                    itemCount: controller.goals.length,
                    separatorBuilder: (context, index) => SizedBox(width: 10), // Increased space between cards
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Added vertical padding
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final goal = controller.goals[index];
                      DateTime? createdAt = goal.createdAt;
                      String? note = goal.note;

                      String formattedNote =
                      note != null && note.isNotEmpty
                          ? note
                          : 'No Note';

                      // Format the date
                      String formattedDate = createdAt != null
                          ? DateFormat('dd/MM/yy').format(createdAt)
                          : 'Date unavailable';

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => GoalDetailPage(goal: goal));
                        },
                        child: ConstrainedBox( // Wrap the container with ConstrainedBox
                          constraints: const BoxConstraints( // Set constraints for maximum width
                            maxWidth: 200, // Adjust the maximum width as needed
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8), // Added vertical margin
                            child: IntrinsicWidth( // Ensures the width depends on content
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Goal title
                                  Text(
                                    goal.title,
                                    style: const TextStyle(
                                      fontSize: 18, // Adjusted font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Milestone and creation date with icons
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16, // Icon size
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontSize: 12, // Adjusted font size
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.note, size: 16.0),
                                      const SizedBox(width: 4),
                                      Flexible( // Wrap the Text widget with Flexible
                                        child: Text(
                                          formattedNote,
                                          style: const TextStyle(fontSize: 12.0),
                                          overflow: TextOverflow.ellipsis, // Add overflow property for ellipsis
                                          maxLines: 2, // Set the maximum number of lines
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Additional info or actions if needed
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "Tasks",
              key: taskDetailKey,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() {
                  if (controller.tasks.isEmpty) {
                    return const Center(child: Text("No tasks. Please create one."));
                  }
                  return ListView.separated(
                    itemCount: controller.tasks.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10), // Increased space between cards
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Added vertical padding
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final task = controller.tasks[index];
                      Goal goal = controller.sortGoals[index];
                      DateTime? deadline = task.deadline;

                      int? done = task.doneTimer;
                      int? guest = task.guestTimer;
                      int? priority = task.priority;
                      String textPriority = getPriorityText(priority);
                      String textTimer;
                      if(guest != null && guest != 0){
                        textTimer = '$done/$guest';
                      }else{
                        textTimer = '$done';
                      }
                      // Format the date
                      String formattedDate = deadline != null
                          ? DateFormat('dd/MM/yy').format(deadline)
                          : 'No Deadline';

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => PomodoroTimerScreen(task: task, goal: goal));
                        },
                        child: ConstrainedBox( // Wrap the container with ConstrainedBox
                          constraints: const BoxConstraints( // Set constraints for maximum width
                            maxWidth: 200, // Adjust the maximum width as needed
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12), // Adjusted padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8), // Added vertical margin
                            constraints: BoxConstraints(minWidth: 150), // Set a minimum width
                            child: IntrinsicWidth( // Ensure the width fits the content
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Task title
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontSize: 18, // Adjusted font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // Deadline and timer with icons
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16, // Icon size
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontSize: 12, // Adjusted font size
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        size: 16, // Icon size
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        textTimer,
                                        style: const TextStyle(
                                          fontSize: 12, // Adjusted font size
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Priority with icon
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.flag,
                                        size: 16, // Icon size
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        textPriority,
                                        style: const TextStyle(
                                          fontSize: 12, // Adjusted font size
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String getPriorityText(int? priority) {
    switch (priority) {
      case 0:
        return 'No set priority';
      case 1:
        return 'Important & Urgent';
      case 2:
        return 'Important but Not Urgent';
      case 3:
        return 'Urgent but Not Important';
      case 4:
        return 'Not Important & Not Urgent';
      default:
        return 'Error';
    }
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