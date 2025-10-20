class DashboardStats {
  final int appointmentsCount;
  final int notificationsCount;
  final int unreadNotificationsCount;
  final int upcomingAppointmentsCount;

  const DashboardStats({
    required this.appointmentsCount,
    required this.notificationsCount,
    required this.unreadNotificationsCount,
    required this.upcomingAppointmentsCount,
  });

  factory DashboardStats.empty() {
    return const DashboardStats(
      appointmentsCount: 0,
      notificationsCount: 0,
      unreadNotificationsCount: 0,
      upcomingAppointmentsCount: 0,
    );
  }
}
