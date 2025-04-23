import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/goal_controller.dart';
import '../models/goal_model.dart';

class GoalEditPage extends StatefulWidget {
  final Goal goal;

  const GoalEditPage({super.key, required this.goal});

  @override
  _GoalEditPageState createState() => _GoalEditPageState();
}

class _GoalEditPageState extends State<GoalEditPage> {
  // Text controllers for form fields
  final controller = Get.put(GoalController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // GlobalKey to identify the form
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize form fields with the goal data
    _titleController.text = widget.goal.title;
    _noteController.text = widget.goal.note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title text field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              // Save button
              ElevatedButton(
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    final newGoal = Goal(
                      id: widget.goal.id,
                      title: _titleController.text,
                      createdAt: widget.goal.createdAt,
                      note: _noteController.text,
                      isCompleted: false,
                    );
                    await controller.updateGoal(newGoal);
                    Navigator.of(context).pop(); // Close the edit page
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the text controllers when done with the page
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
