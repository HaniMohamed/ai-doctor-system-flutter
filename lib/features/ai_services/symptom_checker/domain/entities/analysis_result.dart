class AnalysisResult {
  final List<String> recommendedSpecialties;
  final String urgencyLevel; // low/medium/high
  final double confidence; // 0-1

  const AnalysisResult({
    required this.recommendedSpecialties,
    required this.urgencyLevel,
    required this.confidence,
  });
}


