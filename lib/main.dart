import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/services/language_service.dart';
import 'features/auth/domain/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  // Initialize auth state from storage
  try {
    final authService = sl<AuthService>();
    await authService.initializeFromStorage();
  } catch (e) {
    // Continue with app startup even if auth initialization fails
    print('Auth initialization failed: $e');
  }

  // Initialize language service and register with GetX
  try {
    final languageService = sl<LanguageService>();
    Get.put(languageService, permanent: true);
  } catch (e) {
    print('Language service initialization failed: $e');
  }

  runApp(const AIDoctorApp());
}
