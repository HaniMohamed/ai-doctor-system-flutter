import 'package:get/get.dart';
import '../../data/datasources/symptom_checker_remote_datasource.dart';
import '../../data/repositories/symptom_checker_repository_impl.dart';
import '../../domain/repositories/symptom_checker_repository.dart';
import '../../domain/usecases/analyze_symptoms_usecase.dart';
import '../controllers/symptom_checker_controller.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/network/api_client.dart';

class SymptomCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SymptomCheckerRemoteDataSource>(() => SymptomCheckerRemoteDataSourceImpl(sl<ApiClient>()));
    Get.lazyPut<SymptomCheckerRepository>(() => SymptomCheckerRepositoryImpl(Get.find()));
    Get.lazyPut<AnalyzeSymptomsUsecase>(() => AnalyzeSymptomsUsecase(Get.find()));
    Get.lazyPut<SymptomCheckerController>(() => SymptomCheckerController(Get.find()));
  }
}


