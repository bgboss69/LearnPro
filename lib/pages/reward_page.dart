import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  GlobalKey rewardKey = GlobalKey();
  GlobalKey editKey = GlobalKey();
  GlobalKey addKey = GlobalKey();
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
      // Reward
      TargetFocus(
        identify: "reward-key",
        keyTarget: rewardKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "This is the reward page where you can set rewards based on your behavior, allowing you to reward yourself. Ensure that the rewards are manageable and align with your abilities. You must have at least two items on your reward list. When you have earned a chance from completing tasks, with a 20% win rate, you can spin the wheel to receive your reward.",
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
      TargetFocus(
        identify: "edit-key",
        keyTarget: editKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "You can edit the reward list, after completing your edits, press the update button.",
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
      TargetFocus(
        identify: "add-key",
        keyTarget: addKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                text: "You can add the new reward here!",
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
    late List<TextEditingController> _rewardControllers;
    final controller = Get.put(ProfileController());
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward', key: rewardKey,),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                  final profilePictureUrl= userData.profilePictureUrl;
                  final rewardList = userData.rewardList;

                  _rewardControllers = rewardList.map((rewardList) {
                    return TextEditingController(text: rewardList);
                  }).toList();

                  return Form(
                    key: formKey,
                    child: Column(
                      key: editKey,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int index = 0; index < rewardList.length; index++)
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reward ${index + 1}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _rewardControllers[index],
                                          decoration: InputDecoration(
                                            hintText: 'Enter reward',
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey.shade100,
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a reward';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          if(rewardList.length>2){
                                            setState(() {
                                              rewardList.removeAt(index);
                                              _rewardControllers.removeAt(index);
                                            });
                                            if (formKey.currentState!.validate()) {
                                              final user = UserModel(
                                                id: id,
                                                email: email,
                                                password: password,
                                                fullName: fullName,
                                                phoneNo: phoneNo,
                                                chance: chance,
                                                profilePictureUrl: profilePictureUrl,
                                                rewardList: _rewardControllers.map((controller) => controller.text).toList(),
                                              );
                                              await controller.updateReward(user);
                                            }
                                          }else {
                                            Get.snackbar(
                                              "Fail delete the reward list",
                                              "The reward list must contain at least 2 items.",
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red.withOpacity(0.1),
                                              colorText: Colors.black,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        // Button at the bottom
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              rewardList.add("newReward");
                              // Create a new TextEditingController with the new reward and add it to the list of controllers
                              _rewardControllers.add(
                                  TextEditingController(text: "newReward"));
                            });
                            if (formKey.currentState!.validate()) {
                              // Handle form submission
                              final user = UserModel(
                                id: id,
                                email: email,
                                password: password,
                                fullName: fullName,
                                phoneNo: phoneNo,
                                chance: chance,
                                profilePictureUrl: profilePictureUrl,
                                rewardList: _rewardControllers
                                    .map((controller) => controller.text)
                                    .toList(),
                              );

                              await controller.updateReward(user);
                            }
                          },
                          child: Text('Add', key: addKey,),
                        ),

                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // Handle form submission

                              final user = UserModel(
                                id: id,
                                email: email,
                                password: password,
                                fullName: fullName,
                                phoneNo: phoneNo,
                                chance: chance,
                                profilePictureUrl: profilePictureUrl,
                                rewardList: _rewardControllers
                                    .map((controller) => controller.text)
                                    .toList(),
                              );

                              await controller.updateReward(user);
                            }
                          },
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Something went wrong!"));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
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