import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/logging/logger.dart';
import '../../../../../features/auth/domain/services/auth_service.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/symptom.dart';
import '../../domain/usecases/analyze_symptoms_usecase.dart';

class SymptomCheckerController extends GetxController {
  final AnalyzeSymptomsUsecase _analyzeSymptomsUsecase;
  final Uuid _uuid = const Uuid();

  SymptomCheckerController(this._analyzeSymptomsUsecase);

  final RxList<Symptom> symptoms = <Symptom>[].obs;
  final Rx<AnalysisResult?> result = Rx<AnalysisResult?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString sessionId = ''.obs;

  /// Clear the current session and start a new one
  void startNewSession() {
    sessionId.value = '';
    result.value = null;
    errorMessage.value = '';
  }

  Future<void> analyze() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Get user data from auth service
      final authService = sl<AuthService>();
      final user = authService.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Extract age and gender from user data - both are required
      if (user.age == null) {
        throw Exception(
            'User age is required for symptom analysis. Please update your profile.');
      }
      if (user.gender == null) {
        throw Exception(
            'User gender is required for symptom analysis. Please update your profile.');
      }

      final int age = user.age!;
      final String gender = user.gender!;

      // Generate session_id if none exists
      if (sessionId.value.isEmpty) {
        sessionId.value = _uuid.v4();
      }

      final analysisResult = await _analyzeSymptomsUsecase.execute(symptoms,
          age: age, gender: gender, sessionId: sessionId.value);

      // Update session_id with the one returned from API
      if (analysisResult.sessionId.isNotEmpty) {
        sessionId.value = analysisResult.sessionId;
      }

      result.value = analysisResult;
    } catch (e, stackTrace) {
      Logger.error(
          'Error during symptom analysis', 'SYMPTOM_CHECKER', e, stackTrace);
      errorMessage.value = _getUserFriendlyErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Authentication errors
    if (errorString.contains('user not authenticated') ||
        errorString.contains('not authenticated')) {
      return 'Please log in to use the symptom checker.';
    }

    // Profile data errors
    if (errorString.contains('user age is required')) {
      return 'Your age is required for accurate medical analysis. Please update your profile with your age.';
    }

    if (errorString.contains('user gender is required')) {
      return 'Your gender is required for accurate medical analysis. Please update your profile with your gender.';
    }

    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503')) {
      return 'The server is temporarily unavailable. Please try again in a few moments.';
    }

    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return 'Your session has expired. Please log in again.';
    }

    if (errorString.contains('403') || errorString.contains('forbidden')) {
      return 'You don\'t have permission to use this feature.';
    }

    if (errorString.contains('404') || errorString.contains('not found')) {
      return 'The symptom analysis service is not available. Please try again later.';
    }

    if (errorString.contains('429')) {
      return 'You have reached the limit for AI requests. Please try again later.';
    }

    // API errors
    if (errorString.contains('400')) {
      return 'Invalid request. Please check your symptoms and try again.';
    }

    // Network errors
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return 'Unable to connect to the server. Please check your internet connection and try again.';
    }

    // Generic fallback
    return 'Something went wrong while analyzing your symptoms. Please try again.';
  }
}
