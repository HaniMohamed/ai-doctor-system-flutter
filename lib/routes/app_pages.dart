import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/bindings/auth_binding.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/appointments/presentation/pages/appointments_list_page.dart';
import '../features/doctors/presentation/pages/doctors_list_page.dart';
import '../features/patients/presentation/pages/patient_profile_page.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/ai_services/symptom_checker/presentation/pages/symptom_checker_page.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../shared/widgets/splash_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: AppRoutes.appointments,
      page: () => const AppointmentsListPage(),
    ),
    GetPage(
      name: AppRoutes.doctors,
      page: () => const DoctorsListPage(),
    ),
    GetPage(
      name: AppRoutes.patients,
      page: () => const PatientProfilePage(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
    ),
    GetPage(
      name: AppRoutes.symptomChecker,
      page: () => const SymptomCheckerPage(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
    ),
  ];
}
