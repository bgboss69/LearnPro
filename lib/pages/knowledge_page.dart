import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'dashboard.dart';

class KnowledgeTutorialPage extends StatefulWidget {
  @override
  _KnowledgeTutorialPageState createState() => _KnowledgeTutorialPageState();
}

class _KnowledgeTutorialPageState extends State<KnowledgeTutorialPage> {
  // LiquidController for LiquidSwipe
  final LiquidController _liquidController = LiquidController();

  // List of tutorial pages
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    // Initialize pages in initState
    pages = [
      _buildPage(
        title: '2-Minute Rule',
        description: 'If a task takes less than 2 minutes to complete, do it right away.',
        imagePath: 'assets/images/2_minute_rule.png', // Update with the correct path
        backgroundColor: Colors.blueGrey[900]!,
      ),
      _buildPage(
        title: '5-Second Rule',
        description: 'Count backwards 5-4-3-2-1 and just force yourself to take action.',
        imagePath: 'assets/images/5_second_rule.png', // Update with the correct path
        backgroundColor: Colors.green[900]!,
      ),
      _buildPage(
        title: '1-3-5 Rule',
        description: 'Identify 1 big thing, 3 medium things, and 5 small tasks to do each day.',
        imagePath: 'assets/images/1_3_5_rule.png', // Update with the correct path
        backgroundColor: Colors.orange[900]!,
      ),
      _buildPage(
        title: 'Pomodoro Technique',
        description: 'Work for 25 minutes, then take a 5-minute break. Repeat four times, then take a longer break.',
        imagePath: 'assets/images/pomodoro_technique.png', // Update with the correct path
        backgroundColor: Colors.purple[900]!,
      ),
      _buildPage(
        title: '80/20 Rule',
        description: '20% of your efforts give you 80% of the results. Focus on the important tasks first.',
        imagePath: 'assets/images/80_20_rule.png', // Update with the correct path
        backgroundColor: Colors.red[900]!,
      ),
      _buildPage(
        title: 'Break Tasks Into Pieces',
        description: 'Tackle parts of a task to feel less overwhelmed and more motivated.',
        imagePath: 'assets/images/break_tasks.png', // Update with the correct path
        backgroundColor: Colors.pink[900]!,
      ),
      _buildPage(
        title: 'Eat the Frog',
        description: 'Do your most challenging task first thing in the morning.',
        imagePath: 'assets/images/eat_the_frog.png', // Update with the correct path
        backgroundColor: Colors.cyan[900]!,
      ),
      _buildPage(
        title: 'Not-To-Do List',
        description: 'Identify and stop doing tasks that are not essential or can be delegated.',
        imagePath: 'assets/images/not_to_do_list.png', // Update with the correct path
        backgroundColor: Colors.lime[900]!,
      ),
      _buildPage(
        title: 'Eliminate Multitasking',
        description: 'Focus on one task at a time to improve concentration.',
        imagePath: 'assets/images/eliminate_multitasking.png', // Update with the correct path
        backgroundColor: Colors.teal[900]!,
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
                // Navigate to the dashboard page or home page
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
            // Display image
            Image.asset(imagePath, width: 200, height: 200),
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
