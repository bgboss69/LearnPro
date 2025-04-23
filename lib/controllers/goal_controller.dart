import '../pages/goal_page.dart';
import 'package:get/get.dart';
import '../models/goal_model.dart';
import '../repository/authentication_repository.dart';
import '../repository/goal_repository.dart';
import '../repository/user_repository.dart';

class GoalController extends GetxController {
  static GoalController get instance => Get.find();
  final _goalRepo = Get.put(GoalRepository());

  // Reactive list to store goals
  var goals = <Goal>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Call fetchGoals when the controller is initialized
    fetchGoals();
  }
  // Fetch goals for the user
  Future<void> fetchGoals() async {
    List<Goal> fetchedGoals = await _goalRepo.fetchGoals();
    goals.assignAll(fetchedGoals);
  }

  // Add a new goal for the user
  Future<void> addGoal(Goal goal) async {
    await _goalRepo.addGoal(goal);
    // Refresh the list of goals
    await fetchGoals();
  }

  // Update an existing goal for the user
  Future<void> updateGoal(Goal goal) async {
    await _goalRepo.updateGoal(goal);
    // Refresh the list of goals
    await fetchGoals();
    Get.to(const GoalPage());
  }

  // Delete a goal for the user
  Future<void> deleteGoal(String goalId) async {
    await _goalRepo.deleteGoal(goalId);
    // Refresh the list of goals
    await fetchGoals();
  }


}
