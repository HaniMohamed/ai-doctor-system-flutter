import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt appointmentsCount = 0.obs;
  final RxInt notificationsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO: load real stats via usecases
    appointmentsCount.value = 0;
    notificationsCount.value = 0;
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(() => _StatCard(
                        label: 'Appointments',
                        value: controller.appointmentsCount.value.toString(),
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => _StatCard(
                        label: 'Notifications',
                        value: controller.notificationsCount.value.toString(),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}
