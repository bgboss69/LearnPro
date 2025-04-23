import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import 'update_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder(
        future: controller.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              UserModel userData = snapshot.data as UserModel;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: userData.profilePictureUrl != null && userData.profilePictureUrl.isNotEmpty
                              ? NetworkImage(userData.profilePictureUrl)
                              : const AssetImage('assets/icons/profile_picture.png') as ImageProvider,
                          child: userData.profilePictureUrl == null || userData.profilePictureUrl.isEmpty
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileItem(
                        context,
                        icon: Icons.person,
                        title: 'Name',
                        value: userData.fullName,
                      ),
                      const SizedBox(height: 10),
                      _buildProfileItem(
                        context,
                        icon: Icons.email,
                        title: 'Email',
                        value: userData.email,
                      ),
                      const SizedBox(height: 10),
                      _buildProfileItem(
                        context,
                        icon: Icons.phone,
                        title: 'Phone Number',
                        value: userData.phoneNo,
                      ),
                      const SizedBox(height: 20),
                      _buildProfileItem(
                        context,
                        icon: Icons.casino,
                        title: 'Chance',
                        value: userData.chance.toString(),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => const UpdateProfilePage());
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 10),
                            Text('Edit Profile'),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    );
  }

  Widget _buildProfileItem(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
