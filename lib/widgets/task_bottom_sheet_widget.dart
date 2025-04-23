import 'package:flutter/material.dart';

void showTaskBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      // Number input controller and initial value
      int numberValue = 0;
      final TextEditingController _controller = TextEditingController();

      // Content for the modal bottom sheet
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Horizontal number input
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (numberValue > 0) {
                          setState(() {
                            numberValue--;
                            _controller.text = numberValue.toString();
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          prefix: Padding(padding: EdgeInsets.only(left: 25)),
                          hintText: '0',
                          // Add the Pomodoro timer logo as the suffix icon
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 8),
                            // Adjust padding as needed
                            child: Icon(
                              Icons.timer, // Use a built-in timer icon
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            numberValue = int.parse(value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          numberValue++;
                          _controller.text = numberValue.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Buttons with icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_alert),
                      onPressed: () {
                        // Handle button press
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.assistant_photo),
                      onPressed: () {
                        // Handle button press
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.drive_file_move_outline),
                      onPressed: () {
                        // Handle button press
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                          // Call the function to show the confirmation dialog
                          bool? confirmed = await showConfirmDialog(context);

                          // Handle the user's choice (true for "OK", false for "Cancel")
                          if (confirmed == true) {
                            // User chose "OK"
                            print('User confirmed');
                          } else {
                            // User chose "Cancel"
                            print('User cancelled');
                          }
                        },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
  // Function to show the confirmation dialog
}
Future<bool?> showConfirmDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure you want to proceed?'),
        actions: [
          // "Cancel" button
          TextButton(
            onPressed: () {
              // Close the dialog and return false
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          // "OK" button
          TextButton(
            onPressed: () {
              // Close the dialog and return true
              Navigator.of(context).pop(true);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}