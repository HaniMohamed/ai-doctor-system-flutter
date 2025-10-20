import 'package:get/get.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/usecases/get_appointments_usecase.dart';

class AppointmentsController extends GetxController {
  final GetAppointmentsUsecase _getAppointmentsUsecase;
  AppointmentsController(this._getAppointmentsUsecase);

  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await _getAppointmentsUsecase.execute();
      appointments.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}


