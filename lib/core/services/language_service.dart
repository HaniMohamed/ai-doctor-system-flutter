import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/language_config.dart';
import '../constants/storage_keys.dart';
import '../network/api_client.dart';
import '../di/injection_container.dart';

class LanguageService extends GetxController {
  static LanguageService get instance => Get.find<LanguageService>();
  
  final SharedPreferences _prefs;
  final Rx<Locale> _currentLocale = Rx<Locale>(LanguageConfig.defaultLocale);
  final Rx<SupportedLanguage> _currentLanguage = Rx<SupportedLanguage>(
    LanguageConfig.supportedLanguages.first,
  );

  LanguageService(this._prefs);

  Locale get currentLocale => _currentLocale.value;
  SupportedLanguage get currentLanguage => _currentLanguage.value;
  String get currentLanguageCode => _currentLanguage.value.code;
  String get currentLanguageHeader => LanguageConfig.getLanguageHeaderValue(currentLanguageCode);

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final savedLanguageCode = _prefs.getString(StorageKeys.selectedLanguage);
      if (savedLanguageCode != null) {
        final language = LanguageConfig.getLanguageByCode(savedLanguageCode);
        if (language != null) {
          await _setLanguage(language);
        }
      }
    } catch (e) {
      // If loading fails, use default language
      await _setLanguage(LanguageConfig.supportedLanguages.first);
    }
  }

  Future<void> setLanguage(SupportedLanguage language) async {
    await _setLanguage(language);
    await _saveLanguagePreference(language.code);
    _updateApiClientLanguage();
  }

  Future<void> _setLanguage(SupportedLanguage language) async {
    _currentLanguage.value = language;
    _currentLocale.value = language.locale;
    
    // Update GetX locale
    Get.updateLocale(language.locale);
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    try {
      await _prefs.setString(StorageKeys.selectedLanguage, languageCode);
    } catch (e) {
      // Handle storage error silently
    }
  }

  Future<void> resetToDefault() async {
    await setLanguage(LanguageConfig.supportedLanguages.first);
  }

  void _updateApiClientLanguage() {
    try {
      if (sl.isRegistered<ApiClient>()) {
        sl<ApiClient>().updateLanguageHeader();
      }
    } catch (e) {
      // Handle error silently
    }
  }

  List<SupportedLanguage> get supportedLanguages => LanguageConfig.supportedLanguages;

  bool isRTL() {
    return _currentLanguage.value.code == 'ar' || 
           _currentLanguage.value.code == 'he' ||
           _currentLanguage.value.code == 'fa' ||
           _currentLanguage.value.code == 'ur';
  }

  TextDirection get textDirection => isRTL() ? TextDirection.rtl : TextDirection.ltr;
}
