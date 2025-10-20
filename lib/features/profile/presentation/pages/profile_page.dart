import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data'));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                    child: profile.avatarUrl == null ? const Icon(Icons.person) : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName, style: Theme.of(context).textTheme.titleLarge),
                      Text(profile.email, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              Text('Organization: ${profile.organizationId}')
            ],
          ),
        );
      }),
    );
  }
}
