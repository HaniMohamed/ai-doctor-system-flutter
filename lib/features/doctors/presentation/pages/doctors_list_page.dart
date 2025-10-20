import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctors_controller.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorsController(Get.find()));

    return Scaffold(
      appBar: AppBar(title: const Text('Doctors')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.doctors.isEmpty) {
          return const Center(child: Text('No doctors'));
        }
        return ListView.separated(
          itemCount: controller.doctors.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final d = controller.doctors[index];
            return ListTile(
              title: Text(d.name),
              subtitle: Text('${d.specialty} • ${d.experience} yrs • ${d.rating.toStringAsFixed(1)}★'),
            );
          },
        );
      }),
    );
  }
}
