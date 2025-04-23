// import 'package:flutter/material.dart';
// import '../models/task_model.dart';
//
// Widget showTasks(BuildContext context, TaskModel task,
// // {
// //   required Function(bool) onToggleTaskCompletion,
// //   required Function() onPlayTask,
// // }
// ) {
//   return Container(
//     margin: EdgeInsets.all(8.0), // Add margin around the container
//     decoration: BoxDecoration(
//       border: Border.all(
//         color: Colors.grey, // Customize the border color
//         width: 1.0, // Customize the border width
//       ),
//       borderRadius: BorderRadius.circular(8.0), // Optional: add rounded corners
//     ),
//     child: ListTile(
//       title: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               task.title,
//               style: TextStyle(
//                 decoration:
//                 task.isCompleted ? TextDecoration.lineThrough : null,
//               ),
//             ),
//             Row(
//                 children: [
//                   Text(
//                     task.deadline ,
//                     style: const TextStyle(
//                       fontSize: 10,
//                     ),
//                   ),
//                 ]
//             ),
//           ],
//         ),
//       ),
//       leading: GestureDetector(
//         onTap: () {
//           // Call the callback to toggle task completion
//           // onToggleTaskCompletion(!task.isCompleted);
//         },
//         child: CircleAvatar(
//           backgroundColor: task.isCompleted ? Colors.green : Colors.grey,
//           child: Icon(
//             task.isCompleted ? Icons.check : Icons.circle,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       trailing: IconButton(
//         icon: Icon(Icons.play_arrow),
//         onPressed: () {
//           // Call the callback to play the task
//           // onPlayTask();
//         },
//       ),
//     ),
//   );
// }
//
