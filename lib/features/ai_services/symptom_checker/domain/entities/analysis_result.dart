class AnalysisResult {
  final List<String> recommendedSpecialties;
  final String urgencyLevel; // low/medium/high
  final double confidence; // 0-1
  final String sessionId; // Session ID returned from API
  final String explanation; // AI explanation of the analysis
  final List<String> suggestedQuestions; // Follow-up questions suggested by AI

  const AnalysisResult({
    required this.recommendedSpecialties,
    required this.urgencyLevel,
    required this.confidence,
    required this.sessionId,
    required this.explanation,
    required this.suggestedQuestions,
  });
}
