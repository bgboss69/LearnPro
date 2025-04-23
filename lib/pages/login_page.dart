import '../pages/forget_password_page.dart';
import '../controllers/login_controller.dart';
import '../pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
              const SizedBox(height: 20),
              const Text(
                'Welcome back!',
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
                      controller: controller.email,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.password,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.to(const ForgetPasswordPage()),
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      // Make width same for both buttons
                      child: ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            //trim() method of String values removes whitespace from both ends of this string
                            LoginController.instance.loginUser(controller.email.text.trim(), controller.password.text.trim(),);
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Get.to(const RegisterPage()),
                          child: const Text('Sign up'),
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
