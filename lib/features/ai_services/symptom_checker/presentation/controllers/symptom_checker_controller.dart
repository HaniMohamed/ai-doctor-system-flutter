import 'package:get/get.dart';
import '../../domain/entities/symptom.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/usecases/analyze_symptoms_usecase.dart';

class SymptomCheckerController extends GetxController {
  final AnalyzeSymptomsUsecase _analyzeSymptomsUsecase;
  SymptomCheckerController(this._analyzeSymptomsUsecase);

  final RxList<Symptom> symptoms = <Symptom>[] .obs;
  final Rx<AnalysisResult?> result = Rx<AnalysisResult?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> analyze({int? age, String? gender}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      result.value = await _analyzeSymptomsUsecase.execute(symptoms, age: age, gender: gender);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}


