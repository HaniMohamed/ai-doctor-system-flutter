---
title: "Observability & SLOs - AI Doctor System Flutter Client"
updated: "2024-12-01"
tags: ["observability", "monitoring", "slo", "metrics", "healthcare"]
summary: "Comprehensive observability framework and Service Level Objectives for healthcare-grade Flutter application"
---

# Observability & SLOs - AI Doctor System Flutter Client

## Observability Architecture Overview

The AI Doctor System implements a comprehensive observability framework that provides deep insights into application performance, user behavior, and system health. This framework is critical for maintaining the reliability and performance standards required in healthcare applications.

## Metrics Framework

### **Application Performance Metrics**
```dart
class PerformanceMetrics {
  static final PerformanceMetrics _instance = PerformanceMetrics._internal();
  factory PerformanceMetrics() => _instance;
  PerformanceMetrics._internal();
  
  final Map<String, MetricCollector> _collectors = {};
  
  void initialize() {
    _collectors['screen_load_time'] = MetricCollector('screen_load_time', MetricType.histogram);
    _collectors['api_response_time'] = MetricCollector('api_response_time', MetricType.histogram);
    _collectors['ai_response_time'] = MetricCollector('ai_response_time', MetricType.histogram);
    _collectors['memory_usage'] = MetricCollector('memory_usage', MetricType.gauge);
    _collectors['cpu_usage'] = MetricCollector('cpu_usage', MetricType.gauge);
    _collectors['battery_usage'] = MetricCollector('battery_usage', MetricType.gauge);
    _collectors['network_requests'] = MetricCollector('network_requests', MetricType.counter);
    _collectors['error_rate'] = MetricCollector('error_rate', MetricType.counter);
    _collectors['user_sessions'] = MetricCollector('user_sessions', MetricType.counter);
    _collectors['feature_usage'] = MetricCollector('feature_usage', MetricType.counter);
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
  
  void recordAIResponseTime(String aiFeature, Duration responseTime, bool success) {
    _collectors['ai_response_time']?.record(responseTime.inMilliseconds.toDouble(), {
      'ai_feature': aiFeature,
      'success': success.toString(),
      'platform': Platform.operatingSystem,
    });
  }
  
  void recordMemoryUsage(double memoryUsage) {
    _collectors['memory_usage']?.record(memoryUsage, {
      'platform': Platform.operatingSystem,
    });
  }
  
  void recordNetworkRequest(String endpoint, bool success) {
    _collectors['network_requests']?.increment({
      'endpoint': endpoint,
      'success': success.toString(),
      'platform': Platform.operatingSystem,
    });
  }
  
  void recordError(String errorType, String errorCode) {
    _collectors['error_rate']?.increment({
      'error_type': errorType,
      'error_code': errorCode,
      'platform': Platform.operatingSystem,
    });
  }
  
  void recordFeatureUsage(String featureName) {
    _collectors['feature_usage']?.increment({
      'feature': featureName,
      'platform': Platform.operatingSystem,
    });
  }
  
  void recordUserSession(String sessionType) {
    _collectors['user_sessions']?.increment({
      'session_type': sessionType,
      'platform': Platform.operatingSystem,
    });
  }
}

enum MetricType {
  counter,
  gauge,
  histogram,
  summary,
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
    
    // Send to remote monitoring service
    _sendToMonitoringService();
  }
  
  void increment(Map<String, String>? labels) {
    record(1.0, labels);
  }
  
  void _sendToMonitoringService() {
    // Implementation to send metrics to monitoring service
    // This would typically batch metrics and send them periodically
  }
}

class MetricData {
  final String name;
  final double value;
  final Map<String, String> labels;
  final DateTime timestamp;
  
  MetricData({
    required this.name,
    required this.value,
    required this.labels,
    required this.timestamp,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'labels': labels,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
```

### **Business Metrics**
```dart
class BusinessMetrics {
  static final BusinessMetrics _instance = BusinessMetrics._internal();
  factory BusinessMetrics() => _instance;
  BusinessMetrics._internal();
  
  final Map<String, BusinessMetricCollector> _collectors = {};
  
  void initialize() {
    _collectors['appointment_bookings'] = BusinessMetricCollector('appointment_bookings');
    _collectors['ai_interactions'] = BusinessMetricCollector('ai_interactions');
    _collectors['user_retention'] = BusinessMetricCollector('user_retention');
    _collectors['feature_adoption'] = BusinessMetricCollector('feature_adoption');
    _collectors['user_satisfaction'] = BusinessMetricCollector('user_satisfaction');
    _collectors['support_tickets'] = BusinessMetricCollector('support_tickets');
    _collectors['subscription_conversions'] = BusinessMetricCollector('subscription_conversions');
  }
  
  void recordAppointmentBooking(String appointmentType, bool success) {
    _collectors['appointment_bookings']?.record({
      'appointment_type': appointmentType,
      'success': success.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void recordAIInteraction(String aiFeature, String interactionType, bool success) {
    _collectors['ai_interactions']?.record({
      'ai_feature': aiFeature,
      'interaction_type': interactionType,
      'success': success.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void recordUserRetention(String userId, String retentionPeriod, bool retained) {
    _collectors['user_retention']?.record({
      'user_id': userId,
      'retention_period': retentionPeriod,
      'retained': retained.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void recordFeatureAdoption(String featureName, String adoptionType) {
    _collectors['feature_adoption']?.record({
      'feature_name': featureName,
      'adoption_type': adoptionType,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void recordUserSatisfaction(String userId, int rating, String feedback) {
    _collectors['user_satisfaction']?.record({
      'user_id': userId,
      'rating': rating.toString(),
      'feedback': feedback,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void recordSupportTicket(String ticketType, String priority, bool resolved) {
    _collectors['support_tickets']?.record({
      'ticket_type': ticketType,
      'priority': priority,
      'resolved': resolved.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void recordSubscriptionConversion(String userId, String fromTier, String toTier) {
    _collectors['subscription_conversions']?.record({
      'user_id': userId,
      'from_tier': fromTier,
      'to_tier': toTier,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

class BusinessMetricCollector {
  final String name;
  final List<Map<String, dynamic>> _data = [];
  
  BusinessMetricCollector(this.name);
  
  void record(Map<String, dynamic> data) {
    _data.add(data);
    
    // Send to analytics service
    _sendToAnalyticsService();
  }
  
  void _sendToAnalyticsService() {
    // Implementation to send business metrics to analytics service
    // This would typically batch metrics and send them periodically
  }
}
```

## Tracing Implementation

### **Distributed Tracing**
```dart
class TracingService {
  static final TracingService _instance = TracingService._internal();
  factory TracingService() => _instance;
  TracingService._internal();
  
  final Map<String, Trace> _activeTraces = {};
  final List<Trace> _completedTraces = [];
  
  Trace startTrace(String operationName, Map<String, String>? tags) {
    final trace = Trace(
      traceId: const Uuid().v4(),
      operationName: operationName,
      startTime: DateTime.now(),
      tags: tags ?? {},
      spans: [],
    );
    
    _activeTraces[trace.traceId] = trace;
    return trace;
  }
  
  Span startSpan(String spanName, String traceId, Map<String, String>? tags) {
    final trace = _activeTraces[traceId];
    if (trace == null) {
      throw ArgumentError('Trace not found: $traceId');
    }
    
    final span = Span(
      spanId: const Uuid().v4(),
      traceId: traceId,
      operationName: spanName,
      startTime: DateTime.now(),
      tags: tags ?? {},
      logs: [],
    );
    
    trace.spans.add(span);
    return span;
  }
  
  void finishSpan(String spanId, String traceId, {Map<String, String>? tags}) {
    final trace = _activeTraces[traceId];
    if (trace == null) return;
    
    final span = trace.spans.firstWhere(
      (s) => s.spanId == spanId,
      orElse: () => throw ArgumentError('Span not found: $spanId'),
    );
    
    span.endTime = DateTime.now();
    span.duration = span.endTime!.difference(span.startTime);
    
    if (tags != null) {
      span.tags.addAll(tags);
    }
  }
  
  void finishTrace(String traceId) {
    final trace = _activeTraces.remove(traceId);
    if (trace != null) {
      trace.endTime = DateTime.now();
      trace.duration = trace.endTime!.difference(trace.startTime);
      _completedTraces.add(trace);
      
      // Send to tracing service
      _sendToTracingService(trace);
    }
  }
  
  void _sendToTracingService(Trace trace) {
    // Implementation to send trace to tracing service
    // This would typically batch traces and send them periodically
  }
}

class Trace {
  final String traceId;
  final String operationName;
  final DateTime startTime;
  DateTime? endTime;
  Duration? duration;
  final Map<String, String> tags;
  final List<Span> spans;
  
  Trace({
    required this.traceId,
    required this.operationName,
    required this.startTime,
    this.endTime,
    this.duration,
    required this.tags,
    required this.spans,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'trace_id': traceId,
      'operation_name': operationName,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration_ms': duration?.inMilliseconds,
      'tags': tags,
      'spans': spans.map((span) => span.toJson()).toList(),
    };
  }
}

class Span {
  final String spanId;
  final String traceId;
  final String operationName;
  final DateTime startTime;
  DateTime? endTime;
  Duration? duration;
  final Map<String, String> tags;
  final List<SpanLog> logs;
  
  Span({
    required this.spanId,
    required this.traceId,
    required this.operationName,
    required this.startTime,
    this.endTime,
    this.duration,
    required this.tags,
    required this.logs,
  });
  
  void addLog(String message, Map<String, String>? fields) {
    logs.add(SpanLog(
      message: message,
      timestamp: DateTime.now(),
      fields: fields ?? {},
    ));
  }
  
  Map<String, dynamic> toJson() {
    return {
      'span_id': spanId,
      'trace_id': traceId,
      'operation_name': operationName,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration_ms': duration?.inMilliseconds,
      'tags': tags,
      'logs': logs.map((log) => log.toJson()).toList(),
    };
  }
}

class SpanLog {
  final String message;
  final DateTime timestamp;
  final Map<String, String> fields;
  
  SpanLog({
    required this.message,
    required this.timestamp,
    required this.fields,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'fields': fields,
    };
  }
}
```

### **Performance Tracing**
```dart
class PerformanceTracer {
  final TracingService _tracingService;
  
  PerformanceTracer({
    required TracingService tracingService,
  }) : _tracingService = tracingService;
  
  Future<T> traceOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    Map<String, String>? tags,
  }) async {
    final trace = _tracingService.startTrace(operationName, tags);
    
    try {
      final result = await operation();
      _tracingService.finishTrace(trace.traceId);
      return result;
    } catch (error) {
      _tracingService.finishTrace(trace.traceId);
      rethrow;
    }
  }
  
  Future<T> traceSpan<T>(
    String spanName,
    String traceId,
    Future<T> Function() operation, {
    Map<String, String>? tags,
  }) async {
    final span = _tracingService.startSpan(spanName, traceId, tags);
    
    try {
      final result = await operation();
      _tracingService.finishSpan(span.spanId, traceId);
      return result;
    } catch (error) {
      _tracingService.finishSpan(span.spanId, traceId, tags: {
        'error': error.toString(),
        'error_type': error.runtimeType.toString(),
      });
      rethrow;
    }
  }
}
```

## Alerting System

### **Alert Configuration**
```dart
class AlertManager {
  static final AlertManager _instance = AlertManager._internal();
  factory AlertManager() => _instance;
  AlertManager._internal();
  
  final List<AlertRule> _alertRules = [];
  final List<AlertChannel> _alertChannels = [];
  
  void initialize() {
    _setupDefaultAlertRules();
    _setupDefaultAlertChannels();
  }
  
  void _setupDefaultAlertRules() {
    // Performance alerts
    _alertRules.add(AlertRule(
      name: 'High API Response Time',
      condition: MetricCondition(
        metric: 'api_response_time',
        operator: MetricOperator.greaterThan,
        threshold: 2000, // 2 seconds
        duration: Duration(minutes: 5),
      ),
      severity: AlertSeverity.warning,
      channels: ['slack', 'email'],
    ));
    
    _alertRules.add(AlertRule(
      name: 'High Error Rate',
      condition: MetricCondition(
        metric: 'error_rate',
        operator: MetricOperator.greaterThan,
        threshold: 0.05, // 5% error rate
        duration: Duration(minutes: 5),
      ),
      severity: AlertSeverity.critical,
      channels: ['slack', 'email', 'pagerduty'],
    ));
    
    // Business alerts
    _alertRules.add(AlertRule(
      name: 'Low User Engagement',
      condition: MetricCondition(
        metric: 'user_sessions',
        operator: MetricOperator.lessThan,
        threshold: 100, // Less than 100 sessions
        duration: Duration(hours: 1),
      ),
      severity: AlertSeverity.warning,
      channels: ['slack'],
    ));
    
    // AI service alerts
    _alertRules.add(AlertRule(
      name: 'AI Service Failure',
      condition: MetricCondition(
        metric: 'ai_response_time',
        operator: MetricOperator.greaterThan,
        threshold: 5000, // 5 seconds
        duration: Duration(minutes: 2),
      ),
      severity: AlertSeverity.critical,
      channels: ['slack', 'email', 'pagerduty'],
    ));
  }
  
  void _setupDefaultAlertChannels() {
    _alertChannels.add(SlackAlertChannel(
      webhookUrl: 'https://hooks.slack.com/services/...',
      channel: '#alerts',
    ));
    
    _alertChannels.add(EmailAlertChannel(
      smtpServer: 'smtp.gmail.com',
      port: 587,
      username: 'alerts@aidoctorsystem.com',
      password: 'password',
      recipients: ['devops@aidoctorsystem.com', 'engineering@aidoctorsystem.com'],
    ));
    
    _alertChannels.add(PagerDutyAlertChannel(
      integrationKey: 'integration_key',
    ));
  }
  
  void checkAlerts() {
    for (final rule in _alertRules) {
      if (rule.condition.evaluate()) {
        _triggerAlert(rule);
      }
    }
  }
  
  void _triggerAlert(AlertRule rule) {
    final alert = Alert(
      rule: rule,
      timestamp: DateTime.now(),
      message: _generateAlertMessage(rule),
    );
    
    for (final channelName in rule.channels) {
      final channel = _alertChannels.firstWhere(
        (c) => c.name == channelName,
        orElse: () => throw ArgumentError('Alert channel not found: $channelName'),
      );
      
      channel.sendAlert(alert);
    }
  }
  
  String _generateAlertMessage(AlertRule rule) {
    return 'Alert: ${rule.name}\n'
        'Severity: ${rule.severity.name}\n'
        'Condition: ${rule.condition.toString()}\n'
        'Timestamp: ${DateTime.now().toIso8601String()}';
  }
}

class AlertRule {
  final String name;
  final MetricCondition condition;
  final AlertSeverity severity;
  final List<String> channels;
  
  AlertRule({
    required this.name,
    required this.condition,
    required this.severity,
    required this.channels,
  });
}

class MetricCondition {
  final String metric;
  final MetricOperator operator;
  final double threshold;
  final Duration duration;
  
  MetricCondition({
    required this.metric,
    required this.operator,
    required this.threshold,
    required this.duration,
  });
  
  bool evaluate() {
    // Implementation to evaluate metric condition
    // This would typically query the metrics store
    return false;
  }
  
  @override
  String toString() {
    return '$metric ${operator.symbol} $threshold for ${duration.inMinutes} minutes';
  }
}

enum MetricOperator {
  greaterThan('>'),
  lessThan('<'),
  equals('='),
  notEquals('!=');
  
  const MetricOperator(this.symbol);
  final String symbol;
}

enum AlertSeverity {
  info,
  warning,
  critical,
}

class Alert {
  final AlertRule rule;
  final DateTime timestamp;
  final String message;
  
  Alert({
    required this.rule,
    required this.timestamp,
    required this.message,
  });
}

abstract class AlertChannel {
  String get name;
  Future<void> sendAlert(Alert alert);
}

class SlackAlertChannel implements AlertChannel {
  final String webhookUrl;
  final String channel;
  
  SlackAlertChannel({
    required this.webhookUrl,
    required this.channel,
  });
  
  @override
  String get name => 'slack';
  
  @override
  Future<void> sendAlert(Alert alert) async {
    // Implementation to send alert to Slack
    final payload = {
      'channel': channel,
      'text': alert.message,
      'username': 'AI Doctor System Alerts',
      'icon_emoji': ':warning:',
    };
    
    // Send HTTP request to Slack webhook
  }
}

class EmailAlertChannel implements AlertChannel {
  final String smtpServer;
  final int port;
  final String username;
  final String password;
  final List<String> recipients;
  
  EmailAlertChannel({
    required this.smtpServer,
    required this.port,
    required this.username,
    required this.password,
    required this.recipients,
  });
  
  @override
  String get name => 'email';
  
  @override
  Future<void> sendAlert(Alert alert) async {
    // Implementation to send email alert
    // This would typically use an email service
  }
}

class PagerDutyAlertChannel implements AlertChannel {
  final String integrationKey;
  
  PagerDutyAlertChannel({
    required this.integrationKey,
  });
  
  @override
  String get name => 'pagerduty';
  
  @override
  Future<void> sendAlert(Alert alert) async {
    // Implementation to send alert to PagerDuty
    final payload = {
      'routing_key': integrationKey,
      'event_action': 'trigger',
      'payload': {
        'summary': alert.rule.name,
        'source': 'AI Doctor System',
        'severity': alert.rule.severity.name,
        'custom_details': {
          'message': alert.message,
          'timestamp': alert.timestamp.toIso8601String(),
        },
      },
    };
    
    // Send HTTP request to PagerDuty API
  }
}
```

## Service Level Objectives (SLOs)

### **SLO Definition Framework**
```dart
class SLOManager {
  static final SLOManager _instance = SLOManager._internal();
  factory SLOManager() => _instance;
  SLOManager._internal();
  
  final Map<String, SLO> _slos = {};
  
  void initialize() {
    _setupDefaultSLOs();
  }
  
  void _setupDefaultSLOs() {
    // Availability SLOs
    _slos['api_availability'] = SLO(
      name: 'API Availability',
      description: 'Percentage of successful API requests',
      target: 99.9,
      measurementWindow: Duration(days: 30),
      errorBudget: 0.1,
      metrics: [
        SLOMetric(
          name: 'api_requests_total',
          type: SLOMetricType.counter,
          labels: {'status': 'success'},
        ),
      ],
    );
    
    _slos['ai_service_availability'] = SLO(
      name: 'AI Service Availability',
      description: 'Percentage of successful AI service requests',
      target: 99.5,
      measurementWindow: Duration(days: 30),
      errorBudget: 0.5,
      metrics: [
        SLOMetric(
          name: 'ai_requests_total',
          type: SLOMetricType.counter,
          labels: {'status': 'success'},
        ),
      ],
    );
    
    // Performance SLOs
    _slos['api_response_time'] = SLO(
      name: 'API Response Time',
      description: 'Percentage of API requests under 2 seconds',
      target: 95.0,
      measurementWindow: Duration(days: 30),
      errorBudget: 5.0,
      metrics: [
        SLOMetric(
          name: 'api_response_time',
          type: SLOMetricType.histogram,
          labels: {'le': '2000'}, // 2 seconds
        ),
      ],
    );
    
    _slos['ai_response_time'] = SLO(
      name: 'AI Response Time',
      description: 'Percentage of AI requests under 5 seconds',
      target: 90.0,
      measurementWindow: Duration(days: 30),
      errorBudget: 10.0,
      metrics: [
        SLOMetric(
          name: 'ai_response_time',
          type: SLOMetricType.histogram,
          labels: {'le': '5000'}, // 5 seconds
        ),
      ],
    );
    
    // Business SLOs
    _slos['appointment_booking_success'] = SLO(
      name: 'Appointment Booking Success',
      description: 'Percentage of successful appointment bookings',
      target: 98.0,
      measurementWindow: Duration(days: 30),
      errorBudget: 2.0,
      metrics: [
        SLOMetric(
          name: 'appointment_bookings_total',
          type: SLOMetricType.counter,
          labels: {'status': 'success'},
        ),
      ],
    );
    
    _slos['user_satisfaction'] = SLO(
      name: 'User Satisfaction',
      description: 'Average user satisfaction rating',
      target: 4.5,
      measurementWindow: Duration(days: 30),
      errorBudget: 0.5,
      metrics: [
        SLOMetric(
          name: 'user_satisfaction_rating',
          type: SLOMetricType.gauge,
          labels: {},
        ),
      ],
    );
  }
  
  SLO? getSLO(String name) {
    return _slos[name];
  }
  
  List<SLO> getAllSLOs() {
    return _slos.values.toList();
  }
  
  Map<String, SLOStatus> getSLOStatus() {
    final status = <String, SLOStatus>{};
    
    for (final slo in _slos.values) {
      status[slo.name] = _calculateSLOStatus(slo);
    }
    
    return status;
  }
  
  SLOStatus _calculateSLOStatus(SLO slo) {
    // Implementation to calculate SLO status
    // This would typically query the metrics store
    return SLOStatus(
      slo: slo,
      currentValue: 99.5,
      targetValue: slo.target,
      errorBudgetRemaining: 0.5,
      status: SLOStatusType.healthy,
      lastUpdated: DateTime.now(),
    );
  }
}

class SLO {
  final String name;
  final String description;
  final double target;
  final Duration measurementWindow;
  final double errorBudget;
  final List<SLOMetric> metrics;
  
  SLO({
    required this.name,
    required this.description,
    required this.target,
    required this.measurementWindow,
    required this.errorBudget,
    required this.metrics,
  });
}

class SLOMetric {
  final String name;
  final SLOMetricType type;
  final Map<String, String> labels;
  
  SLOMetric({
    required this.name,
    required this.type,
    required this.labels,
  });
}

enum SLOMetricType {
  counter,
  gauge,
  histogram,
  summary,
}

class SLOStatus {
  final SLO slo;
  final double currentValue;
  final double targetValue;
  final double errorBudgetRemaining;
  final SLOStatusType status;
  final DateTime lastUpdated;
  
  SLOStatus({
    required this.slo,
    required this.currentValue,
    required this.targetValue,
    required this.errorBudgetRemaining,
    required this.status,
    required this.lastUpdated,
  });
}

enum SLOStatusType {
  healthy,
  warning,
  critical,
  breached,
}
```

### **SLO Monitoring Dashboard**
```dart
class SLODashboard extends StatelessWidget {
  final SLOManager _sloManager;
  
  const SLODashboard({
    Key? key,
    required SLOManager sloManager,
  }) : _sloManager = sloManager,
       super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SLO Dashboard'),
      ),
      body: StreamBuilder<Map<String, SLOStatus>>(
        stream: _sloManager.getSLOStatusStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          
          final sloStatus = snapshot.data!;
          
          return ListView.builder(
            itemCount: sloStatus.length,
            itemBuilder: (context, index) {
              final entry = sloStatus.entries.elementAt(index);
              final slo = entry.key;
              final status = entry.value;
              
              return SLOCard(
                slo: slo,
                status: status,
              );
            },
          );
        },
      ),
    );
  }
}

class SLOCard extends StatelessWidget {
  final String slo;
  final SLOStatus status;
  
  const SLOCard({
    Key? key,
    required this.slo,
    required this.status,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slo,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status.status.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              status.slo.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Current Value',
                    '${status.currentValue.toStringAsFixed(1)}%',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Target',
                    '${status.targetValue.toStringAsFixed(1)}%',
                    Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Error Budget',
                    '${status.errorBudgetRemaining.toStringAsFixed(1)}%',
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(SLOStatusType status) {
    switch (status) {
      case SLOStatusType.healthy:
        return Colors.green;
      case SLOStatusType.warning:
        return Colors.orange;
      case SLOStatusType.critical:
        return Colors.red;
      case SLOStatusType.breached:
        return Colors.red[800]!;
    }
  }
}
```

## Health Checks

### **System Health Monitoring**
```dart
class HealthCheckService {
  static final HealthCheckService _instance = HealthCheckService._internal();
  factory HealthCheckService() => _instance;
  HealthCheckService._internal();
  
  final Map<String, HealthCheck> _healthChecks = {};
  
  void initialize() {
    _setupHealthChecks();
  }
  
  void _setupHealthChecks() {
    _healthChecks['api_connectivity'] = HealthCheck(
      name: 'API Connectivity',
      check: _checkApiConnectivity,
      timeout: Duration(seconds: 5),
    );
    
    _healthChecks['database_connectivity'] = HealthCheck(
      name: 'Database Connectivity',
      check: _checkDatabaseConnectivity,
      timeout: Duration(seconds: 5),
    );
    
    _healthChecks['websocket_connectivity'] = HealthCheck(
      name: 'WebSocket Connectivity',
      check: _checkWebSocketConnectivity,
      timeout: Duration(seconds: 5),
    );
    
    _healthChecks['ai_service_health'] = HealthCheck(
      name: 'AI Service Health',
      check: _checkAIServiceHealth,
      timeout: Duration(seconds: 10),
    );
    
    _healthChecks['local_storage'] = HealthCheck(
      name: 'Local Storage',
      check: _checkLocalStorage,
      timeout: Duration(seconds: 2),
    );
    
    _healthChecks['memory_usage'] = HealthCheck(
      name: 'Memory Usage',
      check: _checkMemoryUsage,
      timeout: Duration(seconds: 1),
    );
  }
  
  Future<HealthStatus> checkSystemHealth() async {
    final checks = <String, HealthCheckResult>{};
    
    for (final entry in _healthChecks.entries) {
      final result = await _executeHealthCheck(entry.value);
      checks[entry.key] = result;
    }
    
    final overallStatus = _calculateOverallStatus(checks);
    
    return HealthStatus(
      status: overallStatus,
      checks: checks,
      timestamp: DateTime.now(),
    );
  }
  
  Future<HealthCheckResult> _executeHealthCheck(HealthCheck healthCheck) async {
    try {
      final result = await healthCheck.check().timeout(healthCheck.timeout);
      return HealthCheckResult(
        name: healthCheck.name,
        status: HealthStatusType.healthy,
        message: 'OK',
        duration: Duration.zero, // Would be calculated in real implementation
        details: result,
      );
    } catch (error) {
      return HealthCheckResult(
        name: healthCheck.name,
        status: HealthStatusType.unhealthy,
        message: error.toString(),
        duration: Duration.zero,
        details: null,
      );
    }
  }
  
  HealthStatusType _calculateOverallStatus(Map<String, HealthCheckResult> checks) {
    final unhealthyCount = checks.values
        .where((result) => result.status == HealthStatusType.unhealthy)
        .length;
    
    if (unhealthyCount == 0) {
      return HealthStatusType.healthy;
    } else if (unhealthyCount <= checks.length ~/ 2) {
      return HealthStatusType.degraded;
    } else {
      return HealthStatusType.unhealthy;
    }
  }
  
  Future<Map<String, dynamic>> _checkApiConnectivity() async {
    // Implementation to check API connectivity
    return {'status': 'connected'};
  }
  
  Future<Map<String, dynamic>> _checkDatabaseConnectivity() async {
    // Implementation to check database connectivity
    return {'status': 'connected'};
  }
  
  Future<Map<String, dynamic>> _checkWebSocketConnectivity() async {
    // Implementation to check WebSocket connectivity
    return {'status': 'connected'};
  }
  
  Future<Map<String, dynamic>> _checkAIServiceHealth() async {
    // Implementation to check AI service health
    return {'status': 'healthy'};
  }
  
  Future<Map<String, dynamic>> _checkLocalStorage() async {
    // Implementation to check local storage
    return {'status': 'available'};
  }
  
  Future<Map<String, dynamic>> _checkMemoryUsage() async {
    // Implementation to check memory usage
    return {'usage_percent': 45.2};
  }
}

class HealthCheck {
  final String name;
  final Future<Map<String, dynamic>> Function() check;
  final Duration timeout;
  
  HealthCheck({
    required this.name,
    required this.check,
    required this.timeout,
  });
}

class HealthStatus {
  final HealthStatusType status;
  final Map<String, HealthCheckResult> checks;
  final DateTime timestamp;
  
  HealthStatus({
    required this.status,
    required this.checks,
    required this.timestamp,
  });
}

class HealthCheckResult {
  final String name;
  final HealthStatusType status;
  final String message;
  final Duration duration;
  final Map<String, dynamic>? details;
  
  HealthCheckResult({
    required this.name,
    required this.status,
    required this.message,
    required this.duration,
    this.details,
  });
}

enum HealthStatusType {
  healthy,
  degraded,
  unhealthy,
}
```

This comprehensive observability framework provides deep insights into the AI Doctor System's performance, reliability, and user experience, enabling proactive monitoring and rapid response to issues that could impact healthcare operations.
