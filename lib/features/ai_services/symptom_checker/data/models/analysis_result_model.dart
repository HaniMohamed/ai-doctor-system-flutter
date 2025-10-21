import '../../domain/entities/analysis_result.dart';

class AnalysisResultModel extends AnalysisResult {
  const AnalysisResultModel({
    required super.recommendedSpecialties,
    required super.urgencyLevel,
    required super.confidence,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      recommendedSpecialties:
          (json['recommended_specialties'] as List).cast<String>(),
      urgencyLevel: json['urgency_level'] as String,
      confidence: 0.8, // Default confidence since API doesn't return this field
    );
  }
}
