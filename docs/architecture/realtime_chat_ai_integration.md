---
title: "Realtime Chat & AI Integration - AI Doctor System Flutter Client"
updated: "2024-12-01"
tags: ["websocket", "ai-integration", "realtime", "chat"]
summary: "Comprehensive realtime chat and AI integration architecture for healthcare applications"
---

# Realtime Chat & AI Integration - AI Doctor System Flutter Client

## WebSocket Protocol Architecture

The AI Doctor System implements a robust WebSocket-based realtime communication system that enables seamless AI interactions, real-time chat, and streaming responses across all 10 AI services.

## WebSocket Connection Management

### **Connection Lifecycle**
```dart
class WebSocketManager {
  final Map<String, WebSocketChannel> _connections = {};
  final AuthService _authService;
  final ConnectivityService _connectivityService;
  final StreamController<ConnectionEvent> _connectionController = StreamController.broadcast();
  
  WebSocketManager({
    required AuthService authService,
    required ConnectivityService connectivityService,
  }) : _authService = authService,
       _connectivityService = connectivityService;
  
  Stream<ConnectionEvent> get connectionStream => _connectionController.stream;
  
  Future<WebSocketChannel> connect(String endpoint) async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null) {
        throw WebSocketException('Authentication required');
      }
      
      final uri = Uri.parse('$websocketUrl$endpoint?token=$token');
      final channel = WebSocketChannel.connect(uri);
      
      // Store connection
      _connections[endpoint] = channel;
      
      // Set up connection monitoring
      _monitorConnection(endpoint, channel);
      
      _connectionController.add(ConnectionEvent.connected(endpoint));
      
      return channel;
    } catch (e) {
      _connectionController.add(ConnectionEvent.error(endpoint, e.toString()));
      rethrow;
    }
  }
  
  void _monitorConnection(String endpoint, WebSocketChannel channel) {
    channel.stream.listen(
      (data) {
        _connectionController.add(ConnectionEvent.message(endpoint, data));
      },
      onError: (error) {
        _connectionController.add(ConnectionEvent.error(endpoint, error.toString()));
        _handleConnectionError(endpoint, error);
      },
      onDone: () {
        _connectionController.add(ConnectionEvent.disconnected(endpoint));
        _connections.remove(endpoint);
      },
    );
  }
  
  Future<void> disconnect(String endpoint) async {
    final connection = _connections[endpoint];
    if (connection != null) {
      await connection.sink.close();
      _connections.remove(endpoint);
      _connectionController.add(ConnectionEvent.disconnected(endpoint));
    }
  }
  
  Future<void> disconnectAll() async {
    for (final endpoint in _connections.keys.toList()) {
      await disconnect(endpoint);
    }
  }
  
  void _handleConnectionError(String endpoint, dynamic error) {
    // Implement reconnection logic
    _scheduleReconnection(endpoint);
  }
  
  void _scheduleReconnection(String endpoint) {
    Timer(Duration(seconds: 5), () async {
      if (!_connections.containsKey(endpoint)) {
        try {
          await connect(endpoint);
        } catch (e) {
          // Retry with exponential backoff
          _scheduleReconnection(endpoint);
        }
      }
    });
  }
}

enum ConnectionEventType {
  connected,
  disconnected,
  message,
  error,
}

class ConnectionEvent {
  final ConnectionEventType type;
  final String endpoint;
  final String? data;
  final String? error;
  
  ConnectionEvent._(this.type, this.endpoint, {this.data, this.error});
  
  factory ConnectionEvent.connected(String endpoint) =>
      ConnectionEvent._(ConnectionEventType.connected, endpoint);
  
  factory ConnectionEvent.disconnected(String endpoint) =>
      ConnectionEvent._(ConnectionEventType.disconnected, endpoint);
  
  factory ConnectionEvent.message(String endpoint, String data) =>
      ConnectionEvent._(ConnectionEventType.message, endpoint, data: data);
  
  factory ConnectionEvent.error(String endpoint, String error) =>
      ConnectionEvent._(ConnectionEventType.error, endpoint, error: error);
}
```

### **Authentication & Authorization**
```dart
class WebSocketAuthService {
  final AuthService _authService;
  final RBACService _rbacService;
  
  WebSocketAuthService({
    required AuthService authService,
    required RBACService rbacService,
  }) : _authService = authService,
       _rbacService = rbacService;
  
  Future<bool> authenticateConnection(String token, String endpoint) async {
    try {
      // Validate JWT token
      final user = await _authService.validateToken(token);
      if (user == null) return false;
      
      // Check endpoint permissions
      final hasPermission = await _checkEndpointPermission(user, endpoint);
      if (!hasPermission) return false;
      
      // Log connection
      await _logConnection(user.id, endpoint);
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkEndpointPermission(User user, String endpoint) async {
    // Map endpoints to required permissions
    final endpointPermissions = {
      '/ai/symptom-checker/ws': 'ai_services:use',
      '/ai/doctor-recommendation/ws': 'ai_services:use',
      '/ai/booking-assistant/ws': 'appointments:create',
      '/ai/semantic-search/ws': 'ai_services:use',
      '/ai/time-slots/ws': 'appointments:create',
      '/ai/faq/ws': 'ai_services:use',
      '/ai/consultation-summary/ws': 'medical_records:write',
      '/ai/patient-history/ws': 'medical_records:read',
      '/ai/prescription-ocr/ws': 'medical_records:write',
      '/ai/lab-report/ws': 'medical_records:write',
    };
    
    final requiredPermission = endpointPermissions[endpoint];
    if (requiredPermission == null) return false;
    
    return await _rbacService.hasPermission(requiredPermission);
  }
  
  Future<void> _logConnection(String userId, String endpoint) async {
    // Log WebSocket connection for audit purposes
    await AuditLogger.logAccess(
      userId,
      'websocket',
      'connect',
      {'endpoint': endpoint, 'timestamp': DateTime.now().toIso8601String()},
    );
  }
}
```

## Message Protocol & Schemas

### **Message Format Standards**
```dart
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
  final String? sessionId;
  final String? messageId;
  final DateTime timestamp;
  
  WebSocketMessage({
    required this.type,
    required this.data,
    this.sessionId,
    this.messageId,
    required this.timestamp,
  });
  
  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      sessionId: json['session_id'] as String?,
      messageId: json['message_id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
      'session_id': sessionId,
      'message_id': messageId ?? const Uuid().v4(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

enum MessageType {
  // Client to Server
  message,
  heartbeat,
  subscribe,
  unsubscribe,
  
  // Server to Client
  chunk,
  complete,
  error,
  status,
  notification,
}

class AIMessage extends WebSocketMessage {
  final String content;
  final Map<String, dynamic>? metadata;
  final String? aiFeature;
  
  AIMessage({
    required this.content,
    this.metadata,
    this.aiFeature,
    String? sessionId,
    String? messageId,
  }) : super(
    type: MessageType.message.name,
    data: {
      'content': content,
      'metadata': metadata,
      'ai_feature': aiFeature,
    },
    sessionId: sessionId,
    messageId: messageId,
    timestamp: DateTime.now(),
  );
  
  factory AIMessage.fromWebSocketMessage(WebSocketMessage message) {
    return AIMessage(
      content: message.data['content'] as String,
      metadata: message.data['metadata'] as Map<String, dynamic>?,
      aiFeature: message.data['ai_feature'] as String?,
      sessionId: message.sessionId,
      messageId: message.messageId,
    );
  }
}
```

### **AI Response Streaming**
```dart
class AIResponseStream {
  final String sessionId;
  final String aiFeature;
  final StreamController<AIResponseChunk> _chunkController = StreamController.broadcast();
  
  AIResponseStream({
    required this.sessionId,
    required this.aiFeature,
  });
  
  Stream<AIResponseChunk> get stream => _chunkController.stream;
  
  void addChunk(AIResponseChunk chunk) {
    _chunkController.add(chunk);
  }
  
  void complete() {
    _chunkController.add(AIResponseChunk.complete(sessionId));
    _chunkController.close();
  }
  
  void error(String error) {
    _chunkController.add(AIResponseChunk.error(sessionId, error));
    _chunkController.close();
  }
}

class AIResponseChunk {
  final String sessionId;
  final String? content;
  final bool isComplete;
  final bool isError;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;
  
  AIResponseChunk._({
    required this.sessionId,
    this.content,
    this.isComplete = false,
    this.isError = false,
    this.errorMessage,
    this.metadata,
  });
  
  factory AIResponseChunk.content(String sessionId, String content, {Map<String, dynamic>? metadata}) {
    return AIResponseChunk._(
      sessionId: sessionId,
      content: content,
      metadata: metadata,
    );
  }
  
  factory AIResponseChunk.complete(String sessionId) {
    return AIResponseChunk._(
      sessionId: sessionId,
      isComplete: true,
    );
  }
  
  factory AIResponseChunk.error(String sessionId, String errorMessage) {
    return AIResponseChunk._(
      sessionId: sessionId,
      isError: true,
      errorMessage: errorMessage,
    );
  }
}
```

## AI Service Integration

### **Symptom Checker Integration**
```dart
class SymptomCheckerWebSocketService {
  final WebSocketManager _webSocketManager;
  final StreamController<SymptomAnalysisResult> _resultController = StreamController.broadcast();
  
  SymptomCheckerWebSocketService({
    required WebSocketManager webSocketManager,
  }) : _webSocketManager = webSocketManager;
  
  Stream<SymptomAnalysisResult> get resultStream => _resultController.stream;
  
  Future<void> startAnalysis(List<Symptom> symptoms) async {
    try {
      final channel = await _webSocketManager.connect('/ai/symptom-checker/ws');
      
      // Send analysis request
      final message = AIMessage(
        content: jsonEncode({
          'symptoms': symptoms.map((s) => s.toJson()).toList(),
          'analysis_type': 'comprehensive',
        }),
        aiFeature: 'symptom_checker',
      );
      
      channel.sink.add(jsonEncode(message.toJson()));
      
      // Listen for responses
      _listenForResponses(channel);
    } catch (e) {
      _resultController.add(SymptomAnalysisResult.error(e.toString()));
    }
  }
  
  void _listenForResponses(WebSocketChannel channel) {
    channel.stream.listen((data) {
      try {
        final message = WebSocketMessage.fromJson(jsonDecode(data));
        
        switch (message.type) {
          case 'chunk':
            _handleResponseChunk(message);
            break;
          case 'complete':
            _handleResponseComplete(message);
            break;
          case 'error':
            _handleResponseError(message);
            break;
        }
      } catch (e) {
        _resultController.add(SymptomAnalysisResult.error('Failed to parse response: $e'));
      }
    });
  }
  
  void _handleResponseChunk(WebSocketMessage message) {
    final content = message.data['content'] as String?;
    if (content != null) {
      _resultController.add(SymptomAnalysisResult.chunk(content));
    }
  }
  
  void _handleResponseComplete(WebSocketMessage message) {
    final analysis = message.data['analysis'] as Map<String, dynamic>?;
    if (analysis != null) {
      final result = SymptomAnalysisResult.fromJson(analysis);
      _resultController.add(result);
    }
  }
  
  void _handleResponseError(WebSocketMessage message) {
    final error = message.data['error'] as String? ?? 'Unknown error';
    _resultController.add(SymptomAnalysisResult.error(error));
  }
}

class SymptomAnalysisResult {
  final String? content;
  final List<String>? recommendedSpecialties;
  final String? urgencyLevel;
  final bool isComplete;
  final bool isError;
  final String? errorMessage;
  
  SymptomAnalysisResult._({
    this.content,
    this.recommendedSpecialties,
    this.urgencyLevel,
    this.isComplete = false,
    this.isError = false,
    this.errorMessage,
  });
  
  factory SymptomAnalysisResult.chunk(String content) {
    return SymptomAnalysisResult._(content: content);
  }
  
  factory SymptomAnalysisResult.complete({
    required List<String> recommendedSpecialties,
    required String urgencyLevel,
  }) {
    return SymptomAnalysisResult._(
      recommendedSpecialties: recommendedSpecialties,
      urgencyLevel: urgencyLevel,
      isComplete: true,
    );
  }
  
  factory SymptomAnalysisResult.error(String errorMessage) {
    return SymptomAnalysisResult._(
      isError: true,
      errorMessage: errorMessage,
    );
  }
  
  factory SymptomAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SymptomAnalysisResult._(
      recommendedSpecialties: (json['recommended_specialties'] as List?)?.cast<String>(),
      urgencyLevel: json['urgency_level'] as String?,
      isComplete: true,
    );
  }
}
```

### **Doctor Recommendation Integration**
```dart
class DoctorRecommendationWebSocketService {
  final WebSocketManager _webSocketManager;
  final StreamController<DoctorRecommendationResult> _resultController = StreamController.broadcast();
  
  DoctorRecommendationWebSocketService({
    required WebSocketManager webSocketManager,
  }) : _webSocketManager = webSocketManager;
  
  Stream<DoctorRecommendationResult> get resultStream => _resultController.stream;
  
  Future<void> requestRecommendations({
    required List<String> symptoms,
    String? specialtyId,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final channel = await _webSocketManager.connect('/ai/doctor-recommendation/ws');
      
      final message = AIMessage(
        content: jsonEncode({
          'symptoms': symptoms,
          'specialty_id': specialtyId,
          'preferences': preferences,
        }),
        aiFeature: 'doctor_recommendation',
      );
      
      channel.sink.add(jsonEncode(message.toJson()));
      
      _listenForResponses(channel);
    } catch (e) {
      _resultController.add(DoctorRecommendationResult.error(e.toString()));
    }
  }
  
  void _listenForResponses(WebSocketChannel channel) {
    channel.stream.listen((data) {
      try {
        final message = WebSocketMessage.fromJson(jsonDecode(data));
        
        switch (message.type) {
          case 'chunk':
            _handleResponseChunk(message);
            break;
          case 'complete':
            _handleResponseComplete(message);
            break;
          case 'error':
            _handleResponseError(message);
            break;
        }
      } catch (e) {
        _resultController.add(DoctorRecommendationResult.error('Failed to parse response: $e'));
      }
    });
  }
  
  void _handleResponseChunk(WebSocketMessage message) {
    final content = message.data['content'] as String?;
    if (content != null) {
      _resultController.add(DoctorRecommendationResult.chunk(content));
    }
  }
  
  void _handleResponseComplete(WebSocketMessage message) {
    final recommendations = message.data['recommendations'] as List<dynamic>?;
    if (recommendations != null) {
      final doctors = recommendations
          .map((json) => Doctor.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _resultController.add(DoctorRecommendationResult.complete(doctors));
    }
  }
  
  void _handleResponseError(WebSocketMessage message) {
    final error = message.data['error'] as String? ?? 'Unknown error';
    _resultController.add(DoctorRecommendationResult.error(error));
  }
}

class DoctorRecommendationResult {
  final String? content;
  final List<Doctor>? doctors;
  final bool isComplete;
  final bool isError;
  final String? errorMessage;
  
  DoctorRecommendationResult._({
    this.content,
    this.doctors,
    this.isComplete = false,
    this.isError = false,
    this.errorMessage,
  });
  
  factory DoctorRecommendationResult.chunk(String content) {
    return DoctorRecommendationResult._(content: content);
  }
  
  factory DoctorRecommendationResult.complete(List<Doctor> doctors) {
    return DoctorRecommendationResult._(
      doctors: doctors,
      isComplete: true,
    );
  }
  
  factory DoctorRecommendationResult.error(String errorMessage) {
    return DoctorRecommendationResult._(
      isError: true,
      errorMessage: errorMessage,
    );
  }
}
```

## Chat Interface Implementation

### **Real-time Chat Controller**
```dart
class ChatController extends GetxController {
  final ChatService _chatService;
  final WebSocketManager _webSocketManager;
  
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isConnected = false.obs;
  final RxString currentSessionId = ''.obs;
  
  ChatController({
    required ChatService chatService,
    required WebSocketManager webSocketManager,
  }) : _chatService = chatService,
       _webSocketManager = webSocketManager;
  
  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }
  
  Future<void> _initializeChat() async {
    try {
      // Create new chat session
      final session = await _chatService.createSession();
      currentSessionId.value = session.id;
      
      // Connect to WebSocket
      final channel = await _webSocketManager.connect('/chat/ws');
      isConnected.value = true;
      
      // Listen for incoming messages
      _webSocketManager.connectionStream.listen((event) {
        if (event.endpoint == '/chat/ws') {
          _handleConnectionEvent(event);
        }
      });
      
      // Load chat history
      await _loadChatHistory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize chat: $e');
    }
  }
  
  void _handleConnectionEvent(ConnectionEvent event) {
    switch (event.type) {
      case ConnectionEventType.connected:
        isConnected.value = true;
        break;
      case ConnectionEventType.disconnected:
        isConnected.value = false;
        break;
      case ConnectionEventType.message:
        _handleIncomingMessage(event.data!);
        break;
      case ConnectionEventType.error:
        Get.snackbar('Connection Error', event.error ?? 'Unknown error');
        break;
    }
  }
  
  void _handleIncomingMessage(String data) {
    try {
      final message = WebSocketMessage.fromJson(jsonDecode(data));
      
      switch (message.type) {
        case 'message':
          _handleChatMessage(message);
          break;
        case 'typing':
          _handleTypingIndicator(message);
          break;
        case 'status':
          _handleStatusUpdate(message);
          break;
      }
    } catch (e) {
      print('Failed to parse incoming message: $e');
    }
  }
  
  void _handleChatMessage(WebSocketMessage message) {
    final chatMessage = ChatMessage.fromJson(message.data);
    messages.add(chatMessage);
  }
  
  Future<void> sendMessage(String content, {ChatMessageType? type}) async {
    if (content.trim().isEmpty) return;
    
    try {
      isLoading.value = true;
      
      // Create message object
      final message = ChatMessage(
        id: const Uuid().v4(),
        sessionId: currentSessionId.value,
        content: content,
        type: type ?? ChatMessageType.user,
        timestamp: DateTime.now(),
        senderId: await _getCurrentUserId(),
      );
      
      // Add to local messages
      messages.add(message);
      
      // Send via WebSocket
      final wsMessage = AIMessage(
        content: content,
        sessionId: currentSessionId.value,
        aiFeature: 'chat',
      );
      
      final channel = _webSocketManager._connections['/chat/ws'];
      if (channel != null) {
        channel.sink.add(jsonEncode(wsMessage.toJson()));
      }
      
      // Save to database
      await _chatService.saveMessage(message);
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _loadChatHistory() async {
    try {
      final history = await _chatService.getChatHistory(currentSessionId.value);
      messages.value = history;
    } catch (e) {
      print('Failed to load chat history: $e');
    }
  }
  
  Future<String> _getCurrentUserId() async {
    final user = await AuthService.getCurrentUser();
    return user?.id ?? '';
  }
}

enum ChatMessageType {
  user,
  ai,
  system,
}

class ChatMessage {
  final String id;
  final String sessionId;
  final String content;
  final ChatMessageType type;
  final DateTime timestamp;
  final String senderId;
  final Map<String, dynamic>? metadata;
  
  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.senderId,
    this.metadata,
  });
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      content: json['content'] as String,
      type: ChatMessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChatMessageType.user,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      senderId: json['sender_id'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'sender_id': senderId,
      'metadata': metadata,
    };
  }
}
```

## Presence & Heartbeat Management

### **Connection Health Monitoring**
```dart
class HeartbeatService {
  final WebSocketManager _webSocketManager;
  final StreamController<ConnectionHealth> _healthController = StreamController.broadcast();
  
  Timer? _heartbeatTimer;
  Timer? _healthCheckTimer;
  final Map<String, DateTime> _lastHeartbeat = {};
  
  HeartbeatService({
    required WebSocketManager webSocketManager,
  }) : _webSocketManager = webSocketManager;
  
  Stream<ConnectionHealth> get healthStream => _healthController.stream;
  
  void startHeartbeat() {
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _sendHeartbeat();
    });
    
    _healthCheckTimer = Timer.periodic(Duration(seconds: 60), (_) {
      _checkConnectionHealth();
    });
  }
  
  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _healthCheckTimer?.cancel();
  }
  
  Future<void> _sendHeartbeat() async {
    for (final endpoint in _webSocketManager._connections.keys) {
      try {
        final channel = _webSocketManager._connections[endpoint];
        if (channel != null) {
          final heartbeat = WebSocketMessage(
            type: 'heartbeat',
            data: {'timestamp': DateTime.now().toIso8601String()},
            timestamp: DateTime.now(),
          );
          
          channel.sink.add(jsonEncode(heartbeat.toJson()));
          _lastHeartbeat[endpoint] = DateTime.now();
        }
      } catch (e) {
        _healthController.add(ConnectionHealth.error(endpoint, e.toString()));
      }
    }
  }
  
  void _checkConnectionHealth() {
    final now = DateTime.now();
    
    for (final endpoint in _lastHeartbeat.keys) {
      final lastHeartbeat = _lastHeartbeat[endpoint];
      if (lastHeartbeat != null) {
        final timeSinceLastHeartbeat = now.difference(lastHeartbeat);
        
        if (timeSinceLastHeartbeat > Duration(minutes: 2)) {
          _healthController.add(ConnectionHealth.unhealthy(endpoint, 'No heartbeat received'));
        } else {
          _healthController.add(ConnectionHealth.healthy(endpoint));
        }
      }
    }
  }
}

class ConnectionHealth {
  final String endpoint;
  final bool isHealthy;
  final String? error;
  final DateTime timestamp;
  
  ConnectionHealth._({
    required this.endpoint,
    required this.isHealthy,
    this.error,
    required this.timestamp,
  });
  
  factory ConnectionHealth.healthy(String endpoint) {
    return ConnectionHealth._(
      endpoint: endpoint,
      isHealthy: true,
      timestamp: DateTime.now(),
    );
  }
  
  factory ConnectionHealth.unhealthy(String endpoint, String error) {
    return ConnectionHealth._(
      endpoint: endpoint,
      isHealthy: false,
      error: error,
      timestamp: DateTime.now(),
    );
  }
  
  factory ConnectionHealth.error(String endpoint, String error) {
    return ConnectionHealth._(
      endpoint: endpoint,
      isHealthy: false,
      error: error,
      timestamp: DateTime.now(),
    );
  }
}
```

## Scaling & Sharding Guidelines

### **Connection Scaling Strategy**
```dart
class WebSocketScalingService {
  final Map<String, List<WebSocketChannel>> _connectionPools = {};
  final LoadBalancer _loadBalancer;
  
  WebSocketScalingService({
    required LoadBalancer loadBalancer,
  }) : _loadBalancer = loadBalancer;
  
  Future<WebSocketChannel> getConnection(String endpoint) async {
    // Check if we have available connections in the pool
    final pool = _connectionPools[endpoint] ?? [];
    if (pool.isNotEmpty) {
      return pool.removeLast();
    }
    
    // Create new connection
    return await _createConnection(endpoint);
  }
  
  Future<WebSocketChannel> _createConnection(String endpoint) async {
    // Get server endpoint from load balancer
    final serverEndpoint = await _loadBalancer.getServerEndpoint(endpoint);
    
    final uri = Uri.parse('$serverEndpoint$endpoint');
    final channel = WebSocketChannel.connect(uri);
    
    // Add to pool
    _connectionPools.putIfAbsent(endpoint, () => []).add(channel);
    
    return channel;
  }
  
  void returnConnection(String endpoint, WebSocketChannel channel) {
    final pool = _connectionPools[endpoint] ?? [];
    pool.add(channel);
  }
  
  Future<void> scaleConnections(String endpoint, int targetCount) async {
    final pool = _connectionPools[endpoint] ?? [];
    
    while (pool.length < targetCount) {
      final connection = await _createConnection(endpoint);
      pool.add(connection);
    }
    
    // Remove excess connections
    while (pool.length > targetCount) {
      final connection = pool.removeLast();
      await connection.sink.close();
    }
  }
}

class LoadBalancer {
  final List<String> _servers;
  int _currentIndex = 0;
  
  LoadBalancer(List<String> servers) : _servers = servers;
  
  Future<String> getServerEndpoint(String endpoint) async {
    final server = _servers[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _servers.length;
    return server;
  }
}
```

## Error Handling & Resilience

### **Connection Error Recovery**
```dart
class WebSocketErrorHandler {
  final WebSocketManager _webSocketManager;
  final RetryPolicy _retryPolicy;
  
  WebSocketErrorHandler({
    required WebSocketManager webSocketManager,
    required RetryPolicy retryPolicy,
  }) : _webSocketManager = webSocketManager,
       _retryPolicy = retryPolicy;
  
  Future<void> handleConnectionError(String endpoint, dynamic error) async {
    // Log error
    await _logError(endpoint, error);
    
    // Determine if we should retry
    if (_shouldRetry(error)) {
      await _scheduleRetry(endpoint);
    } else {
      // Notify user of permanent failure
      _notifyUserOfFailure(endpoint, error);
    }
  }
  
  bool _shouldRetry(dynamic error) {
    if (error is WebSocketException) {
      return error.code == WebSocketErrorCode.connectionLost ||
             error.code == WebSocketErrorCode.timeout;
    }
    return false;
  }
  
  Future<void> _scheduleRetry(String endpoint) async {
    final delay = _retryPolicy.getNextDelay();
    
    Timer(delay, () async {
      try {
        await _webSocketManager.connect(endpoint);
      } catch (e) {
        await handleConnectionError(endpoint, e);
      }
    });
  }
  
  Future<void> _logError(String endpoint, dynamic error) async {
    // Log error for monitoring and debugging
    await AuditLogger.logAccess(
      'system',
      'websocket',
      'connection_error',
      {
        'endpoint': endpoint,
        'error': error.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
  
  void _notifyUserOfFailure(String endpoint, dynamic error) {
    // Show user-friendly error message
    Get.snackbar(
      'Connection Error',
      'Failed to connect to $endpoint. Please check your internet connection.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class RetryPolicy {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  
  int _currentRetry = 0;
  
  RetryPolicy({
    this.maxRetries = 5,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
  });
  
  Duration getNextDelay() {
    if (_currentRetry >= maxRetries) {
      return Duration.zero; // No more retries
    }
    
    final delay = Duration(
      milliseconds: (initialDelay.inMilliseconds * 
                    pow(backoffMultiplier, _currentRetry)).round(),
    );
    
    _currentRetry++;
    return delay;
  }
  
  void reset() {
    _currentRetry = 0;
  }
}
```

This comprehensive realtime chat and AI integration architecture provides a robust foundation for implementing all 10 AI services with real-time streaming capabilities, ensuring seamless user experiences and reliable communication across the healthcare application.
