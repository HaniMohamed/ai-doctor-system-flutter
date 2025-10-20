import 'package:get/get.dart';
import '../../../../core/logging/logger.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';

class DashboardController extends GetxController {
  final RxInt appointmentsCount = 0.obs;
  final RxInt notificationsCount = 0.obs;
  final RxInt unreadNotificationsCount = 0.obs;
  final RxInt upcomingAppointmentsCount = 0.obs;
  final RxBool isLoading = true.obs;

  final GetDashboardStatsUsecase _getDashboardStatsUsecase;

  DashboardController(this._getDashboardStatsUsecase);

  @override
  void onInit() {
    super.onInit();
    _loadDashboardStats();
  }

  Future<void> _loadDashboardStats() async {
    try {
      isLoading.value = true;
      final stats = await _getDashboardStatsUsecase.execute();
      
      appointmentsCount.value = stats.appointmentsCount;
      notificationsCount.value = stats.notificationsCount;
      unreadNotificationsCount.value = stats.unreadNotificationsCount;
      upcomingAppointmentsCount.value = stats.upcomingAppointmentsCount;
    } catch (e) {
      // Handle error - could show snackbar or error message
      Logger.error('Error loading dashboard stats', 'DASHBOARD', e);
    } finally {
      isLoading.value = false;
    }
  }
}
