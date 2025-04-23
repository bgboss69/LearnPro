import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/goal_controller.dart';
import '../models/goal_model.dart';
import 'goal_page.dart';

class CreateGoalPage extends StatelessWidget {
  CreateGoalPage({super.key});
  final controller = Get.put(GoalController());

  // Text controllers for goal form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // GlobalKey to identify the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Goal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title text field
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Goal Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Goal title cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),
              // Submit button
              ElevatedButton(
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    // Create a new goal with form data
                    final newGoal = Goal(
                      title: titleController.text,
                      note: noteController.text,
                      createdAt: DateTime.now(),
                      isCompleted: false,
                    );

                    // Use GoalController to add the new goal for the user
                    await controller.addGoal(newGoal);
                    Navigator.of(context).pop(); // Close the edit page
                  }
                },
                child: Text('Create Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
