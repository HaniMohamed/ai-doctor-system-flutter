import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctors_controller.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/widgets/base_scaffold.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorsController(Get.find()));

    return BaseScaffold(
      title: AppLocalizations.of(context)!.doctors,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.doctors.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.noDoctors));
        }
        return ListView.separated(
          itemCount: controller.doctors.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final d = controller.doctors[index];
            return ListTile(
              title: Text(d.name),
              subtitle: Text(
                  '${d.specialty} • ${d.experience} yrs • ${d.rating.toStringAsFixed(1)}★'),
            );
          },
        );
      }),
    );
  }
}
