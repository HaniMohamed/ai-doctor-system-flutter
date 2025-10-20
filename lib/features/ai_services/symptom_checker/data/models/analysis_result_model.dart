import '../../domain/entities/analysis_result.dart';

class AnalysisResultModel extends AnalysisResult {
  const AnalysisResultModel({
    required super.recommendedSpecialties,
    required super.urgencyLevel,
    required super.confidence,
  });

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      recommendedSpecialties: (json['recommended_specialties'] as List).cast<String>(),
      urgencyLevel: json['urgency_level'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}


