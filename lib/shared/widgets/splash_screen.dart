import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/di/injection_container.dart';
import '../../core/logging/logger.dart';
import '../../features/auth/domain/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check authentication status and navigate accordingly
    try {
      final authService = sl<AuthService>();

      // First check if user has stored authentication state
      if (authService.isAuthenticated && authService.currentUser != null) {
        // User appears to be authenticated locally, try to validate token
        try {
          final isValidToken = await authService.validateAndRefreshToken();
          if (isValidToken) {
            Get.offNamed(AppRoutes.dashboard);
            return;
          }
        } catch (e) {
          // If validation fails, don't logout immediately - let user try to use the app
          // They'll be redirected to login if token is actually invalid when making API calls
          Logger.warning(
              'Token validation failed on startup, but keeping local auth state',
              'AUTH',
              e);
        }

        // If we have local auth state, go to dashboard (token will be validated on first API call)
        Get.offNamed(AppRoutes.dashboard);
        return;
      }

      // No local auth state, go to login
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      // If there's any error with auth service, navigate to login
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services,
              size: 100,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'AI Doctor System',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Healthcare Management Platform',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
