import 'package:flutter/material.dart';

class LanguageConfig {
  static const String defaultLanguageCode = 'en';
  static const String defaultCountryCode = 'US';

  static const List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage(
      code: 'en',
      countryCode: 'US',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    SupportedLanguage(
      code: 'es',
      countryCode: 'ES',
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
    ),
    SupportedLanguage(
      code: 'fr',
      countryCode: 'FR',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
    ),
    SupportedLanguage(
      code: 'de',
      countryCode: 'DE',
      name: 'German',
      nativeName: 'Deutsch',
      flag: '🇩🇪',
    ),
    SupportedLanguage(
      code: 'it',
      countryCode: 'IT',
      name: 'Italian',
      nativeName: 'Italiano',
      flag: '🇮🇹',
    ),
    SupportedLanguage(
      code: 'pt',
      countryCode: 'PT',
      name: 'Portuguese',
      nativeName: 'Português',
      flag: '🇵🇹',
    ),
    SupportedLanguage(
      code: 'ru',
      countryCode: 'RU',
      name: 'Russian',
      nativeName: 'Русский',
      flag: '🇷🇺',
    ),
    SupportedLanguage(
      code: 'zh',
      countryCode: 'CN',
      name: 'Chinese',
      nativeName: '中文',
      flag: '🇨🇳',
    ),
    SupportedLanguage(
      code: 'ja',
      countryCode: 'JP',
      name: 'Japanese',
      nativeName: '日本語',
      flag: '🇯🇵',
    ),
    SupportedLanguage(
      code: 'ko',
      countryCode: 'KR',
      name: 'Korean',
      nativeName: '한국어',
      flag: '🇰🇷',
    ),
    SupportedLanguage(
      code: 'ar',
      countryCode: 'SA',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
    ),
    SupportedLanguage(
      code: 'hi',
      countryCode: 'IN',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flag: '🇮🇳',
    ),
    SupportedLanguage(
      code: 'nl',
      countryCode: 'NL',
      name: 'Dutch',
      nativeName: 'Nederlands',
      flag: '🇳🇱',
    ),
    SupportedLanguage(
      code: 'sv',
      countryCode: 'SE',
      name: 'Swedish',
      nativeName: 'Svenska',
      flag: '🇸🇪',
    ),
    SupportedLanguage(
      code: 'no',
      countryCode: 'NO',
      name: 'Norwegian',
      nativeName: 'Norsk',
      flag: '🇳🇴',
    ),
    SupportedLanguage(
      code: 'da',
      countryCode: 'DK',
      name: 'Danish',
      nativeName: 'Dansk',
      flag: '🇩🇰',
    ),
    SupportedLanguage(
      code: 'fi',
      countryCode: 'FI',
      name: 'Finnish',
      nativeName: 'Suomi',
      flag: '🇫🇮',
    ),
    SupportedLanguage(
      code: 'pl',
      countryCode: 'PL',
      name: 'Polish',
      nativeName: 'Polski',
      flag: '🇵🇱',
    ),
    SupportedLanguage(
      code: 'tr',
      countryCode: 'TR',
      name: 'Turkish',
      nativeName: 'Türkçe',
      flag: '🇹🇷',
    ),
    SupportedLanguage(
      code: 'th',
      countryCode: 'TH',
      name: 'Thai',
      nativeName: 'ไทย',
      flag: '🇹🇭',
    ),
    SupportedLanguage(
      code: 'vi',
      countryCode: 'VN',
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳',
    ),
    SupportedLanguage(
      code: 'id',
      countryCode: 'ID',
      name: 'Indonesian',
      nativeName: 'Bahasa Indonesia',
      flag: '🇮🇩',
    ),
    SupportedLanguage(
      code: 'ms',
      countryCode: 'MY',
      name: 'Malay',
      nativeName: 'Bahasa Melayu',
      flag: '🇲🇾',
    ),
    SupportedLanguage(
      code: 'tl',
      countryCode: 'PH',
      name: 'Filipino',
      nativeName: 'Filipino',
      flag: '🇵🇭',
    ),
  ];

  static List<Locale> get supportedLocales {
    return supportedLanguages
        .map((lang) => Locale(lang.code, lang.countryCode))
        .toList();
  }

  static Locale get defaultLocale {
    return const Locale(defaultLanguageCode, defaultCountryCode);
  }

  static SupportedLanguage? getLanguageByCode(String code) {
    try {
      return supportedLanguages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  static String getLanguageHeaderValue(String languageCode) {
    final language = getLanguageByCode(languageCode);
    if (language != null) {
      return '${language.code}-${language.countryCode}';
    }
    return 'en-US';
  }
}

class SupportedLanguage {
  final String code;
  final String countryCode;
  final String name;
  final String nativeName;
  final String flag;

  const SupportedLanguage({
    required this.code,
    required this.countryCode,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  Locale get locale => Locale(code, countryCode);

  String get displayName => '$flag $nativeName ($name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupportedLanguage && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'SupportedLanguage(code: $code, name: $name)';
}
