import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController(Get.find()));

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications'));
        }
        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final n = controller.notifications[index];
            return ListTile(
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: Text(
                n.createdAt.toLocal().toIso8601String(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            );
          },
        );
      }),
    );
  }
}
