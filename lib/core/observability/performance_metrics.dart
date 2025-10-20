import 'dart:io';

enum MetricType { counter, gauge, histogram, summary }

class MetricData {
  final String name;
  final double value;
  final Map<String, String> labels;
  final DateTime timestamp;

  const MetricData({
    required this.name,
    required this.value,
    required this.labels,
    required this.timestamp,
  });
}

class MetricCollector {
  final String name;
  final MetricType type;
  final List<MetricData> _data = [];

  MetricCollector(this.name, this.type);

  void record(double value, Map<String, String>? labels) {
    _data.add(MetricData(
      name: name,
      value: value,
      labels: labels ?? {},
      timestamp: DateTime.now(),
    ));
  }

  void increment(Map<String, String>? labels) {
    record(1.0, labels);
  }
}

class PerformanceMetrics {
  static final PerformanceMetrics _instance = PerformanceMetrics._internal();
  factory PerformanceMetrics() => _instance;
  PerformanceMetrics._internal();

  final Map<String, MetricCollector> _collectors = {};

  void initialize() {
    _collectors['screen_load_time'] = MetricCollector('screen_load_time', MetricType.histogram);
    _collectors['api_response_time'] = MetricCollector('api_response_time', MetricType.histogram);
    _collectors['error_rate'] = MetricCollector('error_rate', MetricType.counter);
    _collectors['user_sessions'] = MetricCollector('user_sessions', MetricType.counter);
  }

  void recordScreenLoadTime(String screenName, Duration loadTime) {
    _collectors['screen_load_time']?.record(loadTime.inMilliseconds.toDouble(), {
      'screen': screenName,
      'platform': Platform.operatingSystem,
    });
  }

  void recordApiResponseTime(String endpoint, Duration responseTime, bool success) {
    _collectors['api_response_time']?.record(responseTime.inMilliseconds.toDouble(), {
      'endpoint': endpoint,
      'success': success.toString(),
      'platform': Platform.operatingSystem,
    });
  }

  void incrementError(String type, String code) {
    _collectors['error_rate']?.increment({
      'error_type': type,
      'error_code': code,
      'platform': Platform.operatingSystem,
    });
  }
}


