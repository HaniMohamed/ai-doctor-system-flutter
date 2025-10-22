// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI Doctor System';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get symptomChecker => 'Symptom Checker';

  @override
  String get appointments => 'Appointments';

  @override
  String get bookingAssistant => 'Booking Assistant';

  @override
  String get welcomeToBookingAssistant => 'Welcome to AI Booking Assistant';

  @override
  String get bookingAssistantDescription =>
      'I can help you book appointments, find doctors, and manage your healthcare schedule. Just tell me what you need!';

  @override
  String get iNeedToBookAnAppointment => 'I need to book an appointment';

  @override
  String get startBooking => 'Start Booking';

  @override
  String get clearConversation => 'Clear Conversation';

  @override
  String get typeYourMessage => 'Type your message...';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get availableDoctors => 'Available Doctors';

  @override
  String get suggestedTimeSlots => 'Suggested Time Slots';

  @override
  String get select => 'Select';

  @override
  String get doctors => 'Doctors';

  @override
  String get patients => 'Patients';

  @override
  String get notifications => 'Notifications';

  @override
  String get chat => 'Chat';

  @override
  String get send => 'Send';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get finish => 'Finish';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get refresh => 'Refresh';

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get cut => 'Cut';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinAIDoctorSystem => 'Join AI Doctor System';

  @override
  String get createYourAccount => 'Create your account to get started';

  @override
  String get iAmA => 'I am a:';

  @override
  String get patient => 'Patient';

  @override
  String get doctor => 'Doctor';

  @override
  String get iNeedMedicalCare => 'I need medical care';

  @override
  String get iProvideMedicalCare => 'I provide medical care';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get validEmailRequired => 'Please enter a valid email';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get agreeToTerms => 'I agree to the';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => 'and';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get agreeToTermsError =>
      'Please agree to the Terms of Service and Privacy Policy';

  @override
  String get accountCreatedSuccessfully =>
      'Account created successfully! Please sign in.';

  @override
  String get registrationFailed => 'Registration failed:';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmailForReset =>
      'Enter your email address and we\'ll send you instructions to reset your password';

  @override
  String get checkYourEmail => 'Check Your Email';

  @override
  String get resetInstructionsSent =>
      'We\'ve sent password reset instructions to your email address';

  @override
  String get enterRegisteredEmail => 'Enter your registered email';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Reset link sent!';

  @override
  String get checkEmailInstructions =>
      'Please check your email and follow the instructions to reset your password. The link will expire in 24 hours.';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get checkSpamFolder =>
      'If you don\'t receive an email within a few minutes, please check your spam folder or contact support.';

  @override
  String get passwordResetSent =>
      'Password reset instructions sent to your email';

  @override
  String get failedToSendReset => 'Failed to send reset email:';

  @override
  String get resetInstructionsResent =>
      'Reset instructions resent to your email';

  @override
  String get failedToResend => 'Failed to resend email:';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get clearChat => 'Clear chat';

  @override
  String get welcomeMessage =>
      'Hello! I\'m your AI healthcare assistant. How can I help you today?';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get demoResponse =>
      'Thank you for your message. This is a demo response. The actual AI integration is coming soon!';

  @override
  String get noAppointments => 'No appointments';

  @override
  String get noDoctors => 'No doctors';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noProfileData => 'No profile data';

  @override
  String get organization => 'Organization:';

  @override
  String get describeYourSymptoms => 'Describe your symptoms';

  @override
  String get enterSymptomsHint =>
      'Enter your symptoms (e.g., headache, fever, nausea)';

  @override
  String get clearAllSymptoms => 'Clear all symptoms';

  @override
  String get addSymptom => 'Add Symptom';

  @override
  String get analyzeSymptoms => 'Analyze Symptoms';

  @override
  String get symptoms => 'Symptoms';

  @override
  String get analysisResults => 'Analysis Results';

  @override
  String get possibleConditions => 'Possible Conditions';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get severity => 'Severity';

  @override
  String get confidence => 'Confidence';

  @override
  String get nextSteps => 'Next Steps';

  @override
  String get whenToSeekHelp => 'When to Seek Help';

  @override
  String get emergency => 'Emergency';

  @override
  String get urgent => 'Urgent';

  @override
  String get moderate => 'Moderate';

  @override
  String get mild => 'Mild';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get unread => 'Unread';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get scheduleWithDoctor => 'Schedule with a doctor';

  @override
  String get aiPoweredHealthCheck => 'AI-powered health check';

  @override
  String get getInstantMedicalAdvice => 'Get instant medical advice';

  @override
  String get browseAvailableDoctors => 'Browse available doctors';

  @override
  String get viewYourAlerts => 'View your alerts';

  @override
  String get manageYourAccount => 'Manage your account';

  @override
  String get overview => 'Overview';

  @override
  String get totalAppointments => 'Total Appointments';

  @override
  String get totalNotifications => 'Total Notifications';

  @override
  String get appDescription =>
      'A comprehensive healthcare management platform powered by AI.';

  @override
  String get appBuiltWith =>
      'Built with Flutter for cross-platform compatibility.';

  @override
  String get confirmSignOut => 'Are you sure you want to sign out?';

  @override
  String get aiInitializingNeuralNetwork => '🧠 Initializing neural network...';

  @override
  String get aiScanningSymptomPatterns => '🔍 Scanning symptom patterns...';

  @override
  String get aiAnalyzingMedicalHistory => '📊 Analyzing medical history...';

  @override
  String get aiProcessingGeneticData => '🧬 Processing genetic data...';

  @override
  String get aiRunningDiagnostics => '🤖 Running AI diagnostics...';

  @override
  String get aiCrossReferencingDatabases => '📈 Cross-referencing databases...';

  @override
  String get aiGeneratingInsights => '💡 Generating insights...';

  @override
  String get aiEvaluatingBiomarkers => '🔬 Evaluating biomarkers...';

  @override
  String get aiCalculatingProbabilities => '🎯 Calculating probabilities...';

  @override
  String get aiFinalizingRecommendations => '✨ Finalizing recommendations...';

  @override
  String get currentSymptoms => 'Current Symptoms';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get addSymptomsAboveToGetAnalysis =>
      'Add symptoms above to get AI-powered analysis';

  @override
  String get clickAnalyzeSymptomsToGetRecommendations =>
      'Click \"Analyze Symptoms\" to get recommendations';

  @override
  String get urgency => 'URGENCY';

  @override
  String get recommendedSpecialties => 'Recommended Specialties';

  @override
  String get analysisFailed => 'Analysis Failed';

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String get suggestedQuestions => 'Suggested Questions';
}
