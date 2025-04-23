import 'package:LearnPro/models/reward_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../controllers/profile_controller.dart';
import '../notification_helper.dart';
import '../repository/reward_repository.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  final player = AudioPlayer();
  String rewards = "0";
  final NotificationHelper _notificationHelper = NotificationHelper();
  final _rewardRepo = Get.put(RewardRepository());
  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin Wheel'),
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
                showRewardHistoryDialog(context);
              },
              icon: const Icon(Icons.history, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.lightBlue,
              Colors.white
            ],// Black color// Adjust colors as needed
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: controller.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel userData = snapshot.data as UserModel;
                    final id = userData.id;
                    final email = userData.email;
                    final password = userData.password;
                    final fullName = userData.fullName;
                    final phoneNo = userData.phoneNo;
                    final chance = userData.chance;
                    final profilePictureUrl = userData.profilePictureUrl;
                    final rewardList = userData.rewardList;

                    List<String> items = rewardList;
                    int x = int.parse(chance);

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Chance: $chance',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 80),
                            SizedBox(
                              height: 300,
                              child: FortuneWheel(
                                styleStrategy: CustomAlternatingStyleStrategy(),
                                selected: selected.stream,
                                indicators: const <FortuneIndicator>[
                                  FortuneIndicator(
                                    alignment: Alignment.topCenter,
                                    // <-- changing the position of the indicator
                                    child: TriangleIndicator(
                                      color: Colors.white,
                                      // <-- changing the color of the indicator
                                      width: 40.0,
                                      // <-- changing the width of the indicator
                                      height: 40.0,
                                      // <-- changing the height of the indicator
                                      elevation:
                                          10, // <-- changing the elevation of the indicator
                                    ),
                                  ),
                                ],
                                animateFirst: false,
                                items: items
                                    .map((item) => FortuneItem(
                                          child: Container(
                                            width: 80,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onAnimationEnd: () {
                                  if (selected.value != null) {
                                    rewards = items[selected.value!];
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("You just won $rewards"),
                                      ),
                                    );
                                    _notificationHelper.pushNotification(
                                      title: 'Reward',
                                      body: 'You just won "$rewards"',
                                    );
                                    final reward = RewardModel(
                                      createdAt: DateTime.now(),
                                      reward: rewards,
                                    );
                                    _rewardRepo.addReward(reward);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 50),
                            GestureDetector(
                              onTap: x > 0
                                  ? () async {
                                      await playNotificationSound();
                                      setState(() {
                                        final randomIndex =
                                            Fortune.randomInt(0, items.length);
                                        selected.add(randomIndex);
                                        x--;
                                        UserModel updatedUser = UserModel(
                                          id: id,
                                          email: email,
                                          password: password,
                                          fullName: fullName,
                                          phoneNo: phoneNo,
                                          chance: x.toString(),
                                          profilePictureUrl: profilePictureUrl,
                                          rewardList: rewardList,
                                        );
                                        controller.updateReward(updatedUser);
                                      });
                                    }
                                  : null,
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: x > 0 ? Colors.redAccent : Colors.grey,
                                  borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                                ),
                                child: Center(
                                  child: Text(
                                    "SPIN",
                                    style: TextStyle(
                                      color: x > 0 ? Colors.white : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text("Error: Could not load user data"));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> playNotificationSound() async {
    await player.play(AssetSource('notification/happy.mp3'));
  }

  void showRewardHistoryDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return RewardHistoryDialog();
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return FadeTransition(
          opacity: animation1,
          child: ScaleTransition(
            scale: animation1,
            child: child,
          ),
        );
      },
    );
  }
}

class CustomAlternatingStyleStrategy extends StyleStrategy {
  final List<int> disabledIndices;

  CustomAlternatingStyleStrategy({this.disabledIndices = const []});

  @override
  FortuneItemStyle getItemStyle(ThemeData theme, int index, int itemCount) {
    final isOddItemCount = itemCount.isOdd;
    final isDisabled = disabledIndices.contains(index);
    final backgroundColor = theme.canvasColor;

    // Define your custom color for odd and even items in blue theme
    final oddColor = Colors.blue[200]!; // Change to your desired odd color
    final evenColor = Colors.blue[600]!; // Change to your desired even color

    // Set opacity based on item index and count
    final opacity = isOddItemCount ? 0.5 : 0.7;

    // Use the custom color based on the index
    final color = index.isOdd
        ? oddColor.withOpacity(opacity)
        : evenColor.withOpacity(opacity);

    // Define border color and width
    final borderColor = Colors.white; // or Colors.blue[900]! for dark blue
    final borderWidth = 4.0; // Adjust the border width as needed

    return FortuneItemStyle(
      color: isDisabled ? backgroundColor : color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      textStyle: theme.textTheme.bodyLarge!,
    );
  }

  @override
  List<BoxDecoration> decorations() {
    return [];
  }
}


class RewardHistoryDialog extends StatelessWidget {
  final RewardRepository _rewardRepo = Get.put(RewardRepository());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reward History'),
      content: Container(
        width: double.maxFinite,
        height: 400, // Set a fixed height for the dialog
        child: FutureBuilder<List<RewardModel>>(
          future: _rewardRepo.getRewardSortedByDate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No rewards found.');
            }

            final rewards = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(reward.reward ?? 'No Reward'),
                          subtitle: Text(
                            reward.createdAt?.toString() ?? 'No Date',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _rewardRepo.deleteAllReward();
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete All Rewards'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}