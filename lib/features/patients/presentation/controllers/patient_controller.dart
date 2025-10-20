import 'package:get/get.dart';
import '../../domain/entities/patient.dart';
import '../../domain/usecases/get_patient_profile_usecase.dart';

class PatientController extends GetxController {
  final GetPatientProfileUsecase _getPatientProfileUsecase;
  PatientController(this._getPatientProfileUsecase);

  final Rx<Patient?> patient = Rx<Patient?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> load(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      patient.value = await _getPatientProfileUsecase.execute(id);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}


