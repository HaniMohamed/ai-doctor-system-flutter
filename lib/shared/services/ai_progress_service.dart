import 'dart:async';
import 'dart:math' as math;

class AIProgressService {
  static final AIProgressService _instance = AIProgressService._internal();
  factory AIProgressService() => _instance;
  AIProgressService._internal();

  final StreamController<double> _progressController =
      StreamController<double>.broadcast();
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  Stream<double> get progressStream => _progressController.stream;
  Stream<String> get messageStream => _messageController.stream;

  Timer? _progressTimer;
  Timer? _messageTimer;

  final List<String> _analysisSteps = [
    "🧠 Initializing neural network...",
    "🔍 Scanning symptom patterns...",
    "📊 Analyzing medical history...",
    "🧬 Processing genetic data...",
    "🤖 Running AI diagnostics...",
    "📈 Cross-referencing databases...",
    "💡 Generating insights...",
    "🔬 Evaluating biomarkers...",
    "🎯 Calculating probabilities...",
    "✨ Finalizing recommendations...",
  ];

  int _currentStep = 0;
  double _currentProgress = 0.0;

  void startProgress() {
    _currentStep = 0;
    _currentProgress = 0.0;

    // Start progress simulation
    _progressTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (_currentProgress < 100) {
        // Simulate realistic progress with some randomness
        final increment = math.Random().nextDouble() * 2 + 0.5; // 0.5 to 2.5
        _currentProgress = math.min(100, _currentProgress + increment);
        _progressController.add(_currentProgress);

        // Update step based on progress
        final stepIndex = (_currentProgress / 10).floor();
        if (stepIndex < _analysisSteps.length && stepIndex != _currentStep) {
          _currentStep = stepIndex;
          _messageController.add(_analysisSteps[_currentStep]);
        }
      } else {
        timer.cancel();
      }
    });

    // Start message updates
    _messageTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_currentStep < _analysisSteps.length - 1) {
        _currentStep++;
        _messageController.add(_analysisSteps[_currentStep]);
      }
    });

    // Send initial message
    _messageController.add(_analysisSteps[0]);
  }

  void stopProgress() {
    _progressTimer?.cancel();
    _messageTimer?.cancel();
    _progressController.add(0.0);
  }

  void dispose() {
    _progressController.close();
    _messageController.close();
  }
}
