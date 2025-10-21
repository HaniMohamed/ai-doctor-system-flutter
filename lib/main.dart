import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection_container.dart';
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

  runApp(const AIDoctorApp());
}
