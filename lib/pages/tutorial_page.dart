import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'dashboard.dart';
class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  // LiquidController for LiquidSwipe
  final LiquidController _liquidController = LiquidController();

  // Number of pages in the tutorial
  final int _numPages = 6;

  // List of tutorial pages
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    // Initialize pages in initState
    pages = [
      _buildPage(
        page: 'path: Goals/',
        title: 'Set Your Goal',
        description: 'Step 1: Set your goal. Begin by defining a clear and achievable objective. Your goal should be specific, measurable, attainable, relevant, and time-bound (SMART). Break down your larger goals into smaller, actionable tasks to make them more manageable and trackable.',
        imagePath: 'assets/tutorial/goal.png',
        backgroundColor: Colors.blueGrey[900]!,
      ),
      _buildPage(
        page: 'path: Goals/:goalId/',
        title: 'Set Your Task',
        description: 'Step 2: Set your task. Once you have your goal defined, create a list of tasks that you need to accomplish to achieve it. Prioritize your tasks based on their importance and urgency. Break down complex tasks into smaller subtasks to make them more manageable and easier to tackle.',
        imagePath: 'assets/tutorial/task.png',
        backgroundColor: Colors.green[900]!,
      ),
      _buildPage(
        page: 'path: Goals/:goalId/Tasks/',
        title: 'Start Your Pomodoro Timer',
        description: 'Step 3: Start your Pomodoro timer. The Pomodoro Technique is a time management method that involves breaking your work into intervals, typically 25 minutes in length, separated by short breaks. Set a timer for 25 minutes and focus on your task without any distractions. After each Pomodoro, take a short break to relax and recharge.',
        imagePath: 'assets/tutorial/timer.png',
        backgroundColor: Colors.orange[900]!,
      ),
      _buildPage(
        page: 'path: Goals/:goalId/Tasks/:taskId/Pomodoro',
        title: 'Get a Chance After Completing One Cycle',
        description: 'Step 4: Get a chance after completing one cycle. After completing a full Pomodoro cycle (four Pomodoros), reward yourself with a short break. Use this time to stretch, hydrate, or take a quick walk. It\'s important to give yourself regular breaks to maintain focus and prevent burnout.',
        imagePath: 'assets/tutorial/cycle.png',
        backgroundColor: Colors.purple[900]!,
      ),
      _buildPage(
        page: 'path: Rewards/',
        title: 'Set Your Reward',
        description: 'Step 5: Set your reward. Motivate yourself to stay on track by setting up rewards for achieving your goals or completing tasks. Choose rewards that are meaningful to you and aligned with your objectives. Whether it\'s a small treat, a fun activity, or some time for relaxation, having something to look forward to can boost your motivation and productivity.',
        imagePath: 'assets/tutorial/reward.png',
        backgroundColor: Colors.red[900]!,
      ),
      _buildPage(
        page: 'path: Wheel/',
        title: 'Spin the Wheel',
        description: 'Step 6: Spin the roulette. Use the roulette feature to add an element of surprise and excitement to your goal-setting process. Assign different rewards or bonuses to each option on the roulette wheel. When you reach a milestone or achieve a goal, spin the roulette wheel to receive your reward. It\'s a fun and interactive way to celebrate your accomplishments and keep yourself motivated.',
        imagePath: 'assets/tutorial/roulette.png',
        backgroundColor: Colors.pink[900]!,
      ),
    ];


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // LiquidSwipe for tutorial pages
          Expanded(
            child: LiquidSwipe(
              pages: pages,
              liquidController: _liquidController,
              slideIconWidget: const Icon(Icons.arrow_back_ios),
            ),
          ),
          // Add a Skip button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the dashboard page
                Get.offAll(() => const Dashboard());
              },
              child: const Text('Skip'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create a tutorial page
  Widget _buildPage({
    required String page,
    required String title,
    required String description,
    required String imagePath,
    required Color backgroundColor,
  }) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              page,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
            // Display image
            Image.asset(imagePath, width: 300, height: 300),
            const SizedBox(height: 20),
            // Display title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Display description
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
