import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appointments_controller.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../shared/widgets/base_scaffold.dart';

class AppointmentsListPage extends StatelessWidget {
  const AppointmentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentsController(Get.find()));

    return BaseScaffold(
      title: AppLocalizations.of(context)!.appointments,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.appointments.isEmpty) {
          return Center(
              child: Text(AppLocalizations.of(context)!.noAppointments));
        }
        return ListView.separated(
          itemCount: controller.appointments.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final a = controller.appointments[index];
            return ListTile(
              title: Text(
                  '${AppLocalizations.of(context)!.doctor}: ${a.doctorId} • ${AppLocalizations.of(context)!.patient}: ${a.patientId}'),
              subtitle: Text('${a.scheduledAt} • ${a.status.name}'),
            );
          },
        );
      }),
    );
  }
}
