import '../controllers/signup_controller.dart';
import '../pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                width: 200, // Adjust the width as needed
                height: 200, // Adjust the height as needed
                child: Image.asset('assets/logo/learnpro_logo.png'),
              ), // Replace with your logo image
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.fullName,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.email,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.phoneNo,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        final phoneNumberRegex = RegExp(r'^\+?[0-9\s\-()]{7,15}$');
                        // Check if the input value matches the phone number regex
                        if (!phoneNumberRegex.hasMatch(value)) {
                          return 'Please enter a valid Phone Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.password,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, // Make width same for both buttons
                      child: ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            //trim() method of String values removes whitespace from both ends of this string
                            //SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim(),);

                            final user = UserModel(
                              email : controller.email.text.trim(),
                              password : controller.password.text.trim(),
                              fullName: controller.fullName.text.trim(),
                              phoneNo: controller.phoneNo.text.trim(),
                            );

                            //create user in firestore
                            SignUpController.instance.createUser(user);
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => Get.to(const LoginPage()),
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
