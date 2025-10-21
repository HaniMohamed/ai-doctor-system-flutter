import '../../domain/entities/analysis_result.dart';

class AnalysisResultModel extends AnalysisResult {
  const AnalysisResultModel({
    required super.recommendedSpecialties,
    required super.urgencyLevel,
    required super.confidence,
    required super.sessionId,
    required super.explanation,
    required super.suggestedQuestions,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      recommendedSpecialties:
          (json['recommended_specialties'] as List).cast<String>(),
      urgencyLevel: json['urgency_level'] as String,
      confidence: 0.8, // Default confidence since API doesn't return this field
      sessionId: json['session_id'] as String? ??
          '', // Use returned session_id or empty string
      explanation: json['explanation'] as String? ?? '',
      suggestedQuestions:
          (json['suggested_questions'] as List?)?.cast<String>() ?? [],
    );
  }
}
