typedef HealthCheckFn = Future<Map<String, dynamic>> Function();

enum HealthStatusType { healthy, degraded, unhealthy }

class HealthCheck {
  final String name;
  final HealthCheckFn check;
  final Duration timeout;
  const HealthCheck({
    required this.name,
    required this.check,
    required this.timeout,
  });
}

class HealthCheckResult {
  final String name;
  final HealthStatusType status;
  final String message;
  final Duration duration;
  final Map<String, dynamic>? details;
  const HealthCheckResult({
    required this.name,
    required this.status,
    required this.message,
    required this.duration,
    this.details,
  });
}

class HealthStatus {
  final HealthStatusType status;
  final Map<String, HealthCheckResult> checks;
  final DateTime timestamp;
  const HealthStatus({
    required this.status,
    required this.checks,
    required this.timestamp,
  });
}

class HealthCheckService {
  final Map<String, HealthCheck> _checks = {};

  void initialize() {
    // TODO: wire actual checks to API/WebSocket/etc.
    _checks['api_connectivity'] = HealthCheck(
      name: 'API Connectivity',
      check: () async => {'status': 'connected'},
      timeout: const Duration(seconds: 5),
    );
  }

  Future<HealthStatus> checkSystemHealth() async {
    final results = <String, HealthCheckResult>{};

    for (final entry in _checks.entries) {
      final start = DateTime.now();
      try {
        final details = await entry.value.check().timeout(entry.value.timeout);
        final duration = DateTime.now().difference(start);
        results[entry.key] = HealthCheckResult(
          name: entry.value.name,
          status: HealthStatusType.healthy,
          message: 'OK',
          duration: duration,
          details: details,
        );
      } catch (e) {
        final duration = DateTime.now().difference(start);
        results[entry.key] = HealthCheckResult(
          name: entry.value.name,
          status: HealthStatusType.unhealthy,
          message: e.toString(),
          duration: duration,
          details: null,
        );
      }
    }

    final unhealthy = results.values.where((r) => r.status == HealthStatusType.unhealthy).length;
    final status = unhealthy == 0
        ? HealthStatusType.healthy
        : (unhealthy <= results.length ~/ 2 ? HealthStatusType.degraded : HealthStatusType.unhealthy);

    return HealthStatus(status: status, checks: results, timestamp: DateTime.now());
  }
}


