import '../../domain/entities/dashboard_stats.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStats> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<DashboardStats> getDashboardStats() async {
    // TODO: Replace with actual API call
    // For now, return mock data
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const DashboardStats(
      appointmentsCount: 5,
      notificationsCount: 12,
      unreadNotificationsCount: 3,
      upcomingAppointmentsCount: 2,
    );
  }
}
