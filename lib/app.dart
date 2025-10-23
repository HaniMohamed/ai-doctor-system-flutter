import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/a11y/accessibility_config.dart';
import 'core/config/language_config.dart';
import 'core/services/language_service.dart';
import 'core/theme/app_theme.dart';
import 'generated/l10n/app_localizations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class AIDoctorApp extends StatelessWidget {
  const AIDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AccessibilityConfig(
      child: GetBuilder<LanguageService>(
        init: LanguageService.instance,
        builder: (languageService) {
          return GetMaterialApp(
            title: 'AI Doctor System',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: AppRoutes.splash,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 300),

            // Localization configuration
            locale: languageService.currentLocale,
            fallbackLocale: LanguageConfig.defaultLocale,
            supportedLocales: LanguageConfig.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
