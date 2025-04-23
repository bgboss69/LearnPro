import '../pages/goal_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/goal_controller.dart';
import '../models/goal_model.dart';
import '../pages/create_goal_page.dart';
import '../pages/edit_goal_page.dart';
import '../widgets/menu_widget.dart';
import 'dashboard.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}
class _GoalPageState extends State<GoalPage> {
  final controller = Get.put(GoalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Get.offAll(() => const Dashboard());
          },
          tooltip: MaterialLocalizations.of(context).showMenuTooltip,
        ),
        title: const Text('Goals'),
      ),
      body: Obx(() {
        if (controller.goals.isEmpty) {
          return const Center(child: Text("No goals. Please create one."));
        }

        return ListView.builder(
          itemCount: controller.goals.length,
          itemBuilder: (context, index) {
            final goal = controller.goals[index];
            DateTime? createdAt = goal.createdAt;
            // Format the date
            String formattedDate = createdAt != null
                ? DateFormat.yMMMMEEEEd().format(createdAt)
                : 'Date unavailable';
            String? note = goal.note != null && goal.note!=""
                ? goal.note
                : 'No Note';

            return GestureDetector(
              onTap: () {
                Get.to(() => GoalDetailPage(goal: goal));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Goal title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.title,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 20.0,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.note, size: 20.0),
                                    const SizedBox(width: 4),
                                    Flexible( // Wrap the Text widget with Flexible
                                      child: Text(
                                        note.toString(),
                                        style: const TextStyle(fontSize: 12.0),
                                        overflow: TextOverflow.ellipsis, // Add overflow property for ellipsis
                                        maxLines: 2, // Set the maximum number of lines
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Edit and delete buttons
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Get.to(() => GoalEditPage(goal: goal));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              onDeleteButtonTap(controller, goal);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => CreateGoalPage()),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void onDeleteButtonTap(GoalController controller, Goal goal) {
    // Confirm the deletion with the user
    Get.defaultDialog(
      title: 'Delete Goal',
      content: Text('Are you sure you want to delete this goal?'),
      confirm: ElevatedButton(
        onPressed: () {
          // Delete the goal
          setState(() {
            controller.deleteGoal(goal.id!);
          });

          // Dismiss the dialog
          Get.back();
        },
        child: Text('Delete'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          // Dismiss the dialog
          Get.back();
        },
        child: Text('Cancel'),
      ),
    );
  }
}
