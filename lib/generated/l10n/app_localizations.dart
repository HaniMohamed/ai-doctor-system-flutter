import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'AI Doctor System'**
  String get appTitle;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Forgot password page title
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Dashboard page title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language selection button text
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Symptom checker feature title
  ///
  /// In en, this message translates to:
  /// **'Symptom Checker'**
  String get symptomChecker;

  /// Appointments page title
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// Doctors page title
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// Patients page title
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// Notifications page title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Chat feature title
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Error message title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Finish button text
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Sort button text
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Paste button text
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// Cut button text
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get cut;

  /// Undo button text
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Redo button text
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// Select all button text
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// Deselect all button text
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// Change language button text
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Create account button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Registration page title
  ///
  /// In en, this message translates to:
  /// **'Join AI Doctor System'**
  String get joinAIDoctorSystem;

  /// Registration page subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started'**
  String get createYourAccount;

  /// Role selection label
  ///
  /// In en, this message translates to:
  /// **'I am a:'**
  String get iAmA;

  /// Patient role option
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// Doctor role option
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// Patient role description
  ///
  /// In en, this message translates to:
  /// **'I need medical care'**
  String get iNeedMedicalCare;

  /// Doctor role description
  ///
  /// In en, this message translates to:
  /// **'I provide medical care'**
  String get iProvideMedicalCare;

  /// First name validation error
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// Last name validation error
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmailRequired;

  /// Phone validation error
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// Confirm password validation error
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// Password mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Terms agreement text
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get agreeToTerms;

  /// Terms of service link text
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Conjunction word
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// Privacy policy link text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Login link text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Terms agreement error message
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms of Service and Privacy Policy'**
  String get agreeToTermsError;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Please sign in.'**
  String get accountCreatedSuccessfully;

  /// Registration error message
  ///
  /// In en, this message translates to:
  /// **'Registration failed:'**
  String get registrationFailed;

  /// Reset password page title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Password reset instructions
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you instructions to reset your password'**
  String get enterEmailForReset;

  /// Email sent confirmation title
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// Email sent confirmation message
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent password reset instructions to your email address'**
  String get resetInstructionsSent;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email'**
  String get enterRegisteredEmail;

  /// Send reset link button
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// Reset link sent confirmation
  ///
  /// In en, this message translates to:
  /// **'Reset link sent!'**
  String get resetLinkSent;

  /// Email check instructions
  ///
  /// In en, this message translates to:
  /// **'Please check your email and follow the instructions to reset your password. The link will expire in 24 hours.'**
  String get checkEmailInstructions;

  /// Resend email button
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// Back to login button
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// Spam folder check message
  ///
  /// In en, this message translates to:
  /// **'If you don\'t receive an email within a few minutes, please check your spam folder or contact support.'**
  String get checkSpamFolder;

  /// Password reset sent confirmation
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions sent to your email'**
  String get passwordResetSent;

  /// Password reset send error
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email:'**
  String get failedToSendReset;

  /// Resend confirmation message
  ///
  /// In en, this message translates to:
  /// **'Reset instructions resent to your email'**
  String get resetInstructionsResent;

  /// Resend error message
  ///
  /// In en, this message translates to:
  /// **'Failed to resend email:'**
  String get failedToResend;

  /// AI assistant chat title
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// Clear chat tooltip
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChat;

  /// Chat input hint
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// AI assistant welcome message
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your AI healthcare assistant. How can I help you today?'**
  String get welcomeMessage;

  /// Time format for recent messages
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Time format for minutes ago
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// Time format for hours ago
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// AI demo response message
  ///
  /// In en, this message translates to:
  /// **'Thank you for your message. This is a demo response. The actual AI integration is coming soon!'**
  String get demoResponse;

  /// Empty appointments message
  ///
  /// In en, this message translates to:
  /// **'No appointments'**
  String get noAppointments;

  /// Empty doctors message
  ///
  /// In en, this message translates to:
  /// **'No doctors'**
  String get noDoctors;

  /// Empty notifications message
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// Empty profile message
  ///
  /// In en, this message translates to:
  /// **'No profile data'**
  String get noProfileData;

  /// Organization label
  ///
  /// In en, this message translates to:
  /// **'Organization:'**
  String get organization;

  /// Symptom checker title
  ///
  /// In en, this message translates to:
  /// **'Describe your symptoms'**
  String get describeYourSymptoms;

  /// Symptoms input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your symptoms (e.g., headache, fever, nausea)'**
  String get enterSymptomsHint;

  /// Clear symptoms tooltip
  ///
  /// In en, this message translates to:
  /// **'Clear all symptoms'**
  String get clearAllSymptoms;

  /// Add symptom button
  ///
  /// In en, this message translates to:
  /// **'Add Symptom'**
  String get addSymptom;

  /// Analyze symptoms button
  ///
  /// In en, this message translates to:
  /// **'Analyze Symptoms'**
  String get analyzeSymptoms;

  /// Symptoms label
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// Analysis results title
  ///
  /// In en, this message translates to:
  /// **'Analysis Results'**
  String get analysisResults;

  /// Possible conditions label
  ///
  /// In en, this message translates to:
  /// **'Possible Conditions'**
  String get possibleConditions;

  /// Recommendations label
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// Severity label
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// Confidence label
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// Next steps label
  ///
  /// In en, this message translates to:
  /// **'Next Steps'**
  String get nextSteps;

  /// When to seek help label
  ///
  /// In en, this message translates to:
  /// **'When to Seek Help'**
  String get whenToSeekHelp;

  /// Emergency label
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// Urgent label
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// Moderate label
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// Mild label
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mild;

  /// High label
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Medium label
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Low label
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Upcoming label
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// Unread label
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// Quick actions title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Book appointment subtitle
  ///
  /// In en, this message translates to:
  /// **'Schedule with a doctor'**
  String get scheduleWithDoctor;

  /// Symptom checker subtitle
  ///
  /// In en, this message translates to:
  /// **'AI-powered health check'**
  String get aiPoweredHealthCheck;

  /// Chat subtitle
  ///
  /// In en, this message translates to:
  /// **'Get instant medical advice'**
  String get getInstantMedicalAdvice;

  /// Find doctors subtitle
  ///
  /// In en, this message translates to:
  /// **'Browse available doctors'**
  String get browseAvailableDoctors;

  /// Notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'View your alerts'**
  String get viewYourAlerts;

  /// Profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your account'**
  String get manageYourAccount;

  /// Overview title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Total appointments label
  ///
  /// In en, this message translates to:
  /// **'Total Appointments'**
  String get totalAppointments;

  /// Total notifications label
  ///
  /// In en, this message translates to:
  /// **'Total Notifications'**
  String get totalNotifications;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'it',
        'ja',
        'ko',
        'nl',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
