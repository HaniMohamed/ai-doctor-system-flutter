import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsUsecase {
  final DashboardRepository _repository;
  GetDashboardStatsUsecase(this._repository);

  Future<DashboardStats> execute() => _repository.getDashboardStats();
}
