import 'package:get/get.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/usecases/get_doctors_usecase.dart';

class DoctorsController extends GetxController {
  final GetDoctorsUsecase _getDoctorsUsecase;
  DoctorsController(this._getDoctorsUsecase);

  final RxList<Doctor> doctors = <Doctor>[] .obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await _getDoctorsUsecase.execute();
      doctors.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}


