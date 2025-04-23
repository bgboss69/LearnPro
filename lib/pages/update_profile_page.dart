import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

import 'dashboard.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Get.offAll(() => const Dashboard());
          },
        ),
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
                  final id = TextEditingController(text: userData.id);
                  final email = TextEditingController(text: userData.email);
                  final currentPassword = userData.password;
                  final password =
                      TextEditingController(text: userData.password);
                  final fullName =
                      TextEditingController(text: userData.fullName);
                  final phoneNo = TextEditingController(text: userData.phoneNo);
                  final chance = userData.chance;
                  final rewardList = userData.rewardList;
                  final profilePictureUrl = TextEditingController(text:userData.profilePictureUrl);
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile picture
                        // Name text field
                        TextFormField(
                          controller: fullName,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        // Email text field
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                // Toggle the visibility of the password
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !isPasswordVisible,
                        ),

                        const SizedBox(height: 10),

                        TextFormField(
                          controller: phoneNo,
                          decoration: const InputDecoration(
                              labelText: 'PhoneNo',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Phone Number';
                            }
                            final phoneNumberRegex =
                                RegExp(r'^\+?[0-9\s\-()]{7,15}$');
                            // Check if the input value matches the phone number regex
                            if (!phoneNumberRegex.hasMatch(value)) {
                              return 'Please enter a valid Phone Number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          controller: profilePictureUrl,
                          decoration: const InputDecoration(
                            labelText: 'Profile Picture URL',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a profile picture URL';
                            }
                            const urlPattern = r'^(http|https):\/\/[\w\-_]+(\.[\w\-_]+)+[/#?]?.*$';
                            final urlRegex = RegExp(urlPattern);
                            if (!urlRegex.hasMatch(value)) {
                              return 'Please enter a valid URL';
                            }
                            return null;
                          },
                        ),


                        // Add a spacer to push the button to the bottom
                        const SizedBox(height: 50),
                        // Button at the bottom
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // Handle form submission
                              final user = UserModel(
                                id: id.text.trim(),
                                email: email.text.trim(),
                                password: password.text.trim(),
                                fullName: fullName.text.trim(),
                                phoneNo: phoneNo.text.trim(),
                                profilePictureUrl: profilePictureUrl.text.trim(),
                                chance: chance,
                                rewardList: rewardList,
                              );

                              await controller.updateRecord(
                                  user, currentPassword);
                            }
                          },
                          child: const Text('Update'),
                        ),

                        const SizedBox(height: 50),

                        // ElevatedButton(
                        //   onPressed: () async {
                        //     if (formKey.currentState!.validate()) {
                        //       // Handle form submission
                        //       final user = UserModel(
                        //         email : email.text.trim(),
                        //         password : password.text.trim(),
                        //         fullName: fullName.text.trim(),
                        //         phoneNo: phoneNo.text.trim(),
                        //       );
                        //
                        //       await controller.updateRecord(user);
                        //     }
                        //   },
                        //   child: const Text('Update'),
                        // ),
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
