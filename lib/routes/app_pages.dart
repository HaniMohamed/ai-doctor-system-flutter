import 'package:get/get.dart';
import 'app_routes.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/bindings/auth_binding.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/appointments/presentation/pages/appointments_list_page.dart';
import '../features/appointments/presentation/bindings/appointments_binding.dart';
import '../features/doctors/presentation/pages/doctors_list_page.dart';
import '../features/doctors/presentation/bindings/doctors_binding.dart';
import '../features/patients/presentation/pages/patient_profile_page.dart';
import '../features/patients/presentation/bindings/patient_binding.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/notifications/presentation/bindings/notifications_binding.dart';
import '../features/ai_services/symptom_checker/presentation/pages/symptom_checker_page.dart';
import '../features/ai_services/symptom_checker/presentation/bindings/symptom_checker_binding.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../shared/widgets/splash_screen.dart';
import 'route_middleware.dart';

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
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.appointments,
      page: () => const AppointmentsListPage(),
      binding: AppointmentsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.doctors,
      page: () => const DoctorsListPage(),
      binding: DoctorsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.patients,
      page: () => const PatientProfilePage(),
      binding: PatientBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
      binding: NotificationsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.symptomChecker,
      page: () => const SymptomCheckerPage(),
      binding: SymptomCheckerBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
    ),
  ];
}
