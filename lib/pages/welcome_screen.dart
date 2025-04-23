import '../pages/login_page.dart';
import '../pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/authentication_repository.dart';

class LearnProWelcomeScreen extends StatefulWidget {
  const LearnProWelcomeScreen({super.key});

  @override
  State<LearnProWelcomeScreen> createState() => _LearnProWelcomeScreenState();
}

class _LearnProWelcomeScreenState extends State<LearnProWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/learnpro_logo.png'),
            // Assuming you have a logo image
            const SizedBox(height: 20),
            const Text(
              'Welcome to LearnPro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your gateway to limitless learning!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => Get.to(const LoginPage()),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    onPressed: () => Get.to(const RegisterPage()),
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
