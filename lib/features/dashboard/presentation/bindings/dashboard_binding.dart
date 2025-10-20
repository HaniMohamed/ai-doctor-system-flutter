import 'package:get/get.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(),
    );
    
    // Repositories
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(Get.find<DashboardRemoteDataSource>()),
    );
    
    // Use cases
    Get.lazyPut<GetDashboardStatsUsecase>(
      () => GetDashboardStatsUsecase(Get.find<DashboardRepository>()),
    );
    
    // Controllers
    Get.lazyPut<DashboardController>(
      () => DashboardController(Get.find<GetDashboardStatsUsecase>()),
    );
  }
}
