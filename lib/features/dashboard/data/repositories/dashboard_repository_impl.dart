import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<DashboardStats> getDashboardStats() async {
    try {
      final stats = await _remoteDataSource.getDashboardStats();
      return stats;
    } catch (e) {
      // Return empty stats on error for now
      return DashboardStats.empty();
    }
  }
}
