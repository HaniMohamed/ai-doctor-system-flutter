---
title: "Modular Project Structure - AI Doctor System Flutter Client"
updated: "2024-12-01"
tags: ["architecture", "project-structure", "flutter", "modular"]
summary: "Comprehensive modular project structure design for scalable Flutter healthcare application"
---

# Modular Project Structure - AI Doctor System Flutter Client

## Project Structure Overview

The AI Doctor System follows a clean, modular architecture that enables parallel development, easy maintenance, and scalable growth. The structure is designed to support multiple teams working simultaneously while maintaining clear boundaries and dependencies.

## Complete Folder Structure

```
ai_doctor_flutter/
├── android/                          # Android-specific configuration
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── kotlin/
│   │       └── res/
│   └── build.gradle
├── ios/                              # iOS-specific configuration
│   ├── Runner/
│   │   ├── Info.plist
│   │   ├── Runner.entitlements
│   │   └── xcodeproj/
│   └── Podfile
├── web/                              # Web-specific configuration
│   ├── index.html
│   ├── manifest.json
│   └── favicon.png
├── lib/                              # Main application code
│   ├── core/                         # Core functionality and utilities
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   ├── app_constants.dart
│   │   │   ├── storage_keys.dart
│   │   │   └── theme_constants.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   ├── failures.dart
│   │   │   └── error_handler.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── network_info.dart
│   │   │   ├── interceptors/
│   │   │   │   ├── auth_interceptor.dart
│   │   │   │   ├── error_interceptor.dart
│   │   │   │   └── logging_interceptor.dart
│   │   │   └── websocket/
│   │   │       ├── websocket_client.dart
│   │   │       ├── websocket_manager.dart
│   │   │       └── message_handler.dart
│   │   ├── storage/
│   │   │   ├── local_storage.dart
│   │   │   ├── secure_storage.dart
│   │   │   └── cache_manager.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   ├── extensions.dart
│   │   │   ├── logger.dart
│   │   │   └── platform_utils.dart
│   │   ├── di/
│   │   │   ├── injection_container.dart
│   │   │   └── service_locator.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── color_scheme.dart
│   │       ├── text_theme.dart
│   │       └── component_theme.dart
│   ├── features/                     # Feature modules
│   │   ├── auth/                     # Authentication module
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   │   └── auth_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   ├── auth_tokens_model.dart
│   │   │   │   │   └── login_request_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user.dart
│   │   │   │   │   └── auth_tokens.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── logout_usecase.dart
│   │   │   │       ├── refresh_token_usecase.dart
│   │   │   │       └── get_current_user_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   └── forgot_password_page.dart
│   │   │       ├── controllers/
│   │   │       │   └── auth_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── login_form.dart
│   │   │       │   ├── password_field.dart
│   │   │       │   └── auth_button.dart
│   │   │       └── bindings/
│   │   │           └── auth_binding.dart
│   │   ├── dashboard/                # Dashboard module
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── dashboard_remote_datasource.dart
│   │   │   │   │   └── dashboard_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── dashboard_stats_model.dart
│   │   │   │   │   └── recent_activity_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── dashboard_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── dashboard_stats.dart
│   │   │   │   │   └── recent_activity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── dashboard_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_dashboard_stats_usecase.dart
│   │   │   │       └── get_recent_activity_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── dashboard_page.dart
│   │   │       │   └── stats_overview_page.dart
│   │   │       ├── controllers/
│   │   │       │   └── dashboard_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── stats_card.dart
│   │   │       │   ├── recent_activity_list.dart
│   │   │       │   └── quick_actions.dart
│   │   │       └── bindings/
│   │   │           └── dashboard_binding.dart
│   │   ├── ai_services/              # AI Services module
│   │   │   ├── symptom_checker/      # Symptom Checker sub-module
│   │   │   │   ├── data/
│   │   │   │   │   ├── datasources/
│   │   │   │   │   │   ├── symptom_checker_remote_datasource.dart
│   │   │   │   │   │   └── symptom_checker_local_datasource.dart
│   │   │   │   │   ├── models/
│   │   │   │   │   │   ├── symptom_model.dart
│   │   │   │   │   │   ├── analysis_result_model.dart
│   │   │   │   │   │   └── specialty_recommendation_model.dart
│   │   │   │   │   └── repositories/
│   │   │   │   │       └── symptom_checker_repository_impl.dart
│   │   │   │   ├── domain/
│   │   │   │   │   ├── entities/
│   │   │   │   │   │   ├── symptom.dart
│   │   │   │   │   │   ├── analysis_result.dart
│   │   │   │   │   │   └── specialty_recommendation.dart
│   │   │   │   │   ├── repositories/
│   │   │   │   │   │   └── symptom_checker_repository.dart
│   │   │   │   │   └── usecases/
│   │   │   │   │       ├── analyze_symptoms_usecase.dart
│   │   │   │   │       └── get_specialty_recommendations_usecase.dart
│   │   │   │   └── presentation/
│   │   │   │       ├── pages/
│   │   │   │       │   ├── symptom_checker_page.dart
│   │   │   │       │   └── analysis_results_page.dart
│   │   │   │       ├── controllers/
│   │   │   │       │   └── symptom_checker_controller.dart
│   │   │   │       ├── widgets/
│   │   │   │       │   ├── symptom_input_widget.dart
│   │   │   │       │   ├── analysis_progress_widget.dart
│   │   │   │       │   └── specialty_recommendation_card.dart
│   │   │   │       └── bindings/
│   │   │   │           └── symptom_checker_binding.dart
│   │   │   ├── doctor_recommendations/ # Doctor Recommendations sub-module
│   │   │   ├── booking_assistant/     # Booking Assistant sub-module
│   │   │   ├── semantic_search/       # Semantic Search sub-module
│   │   │   ├── time_slot_suggestions/ # Time Slot Suggestions sub-module
│   │   │   ├── faq_assistant/         # FAQ Assistant sub-module
│   │   │   ├── consultation_summary/  # Consultation Summary sub-module
│   │   │   ├── patient_history/       # Patient History sub-module
│   │   │   ├── prescription_ocr/      # Prescription OCR sub-module
│   │   │   └── lab_report/            # Lab Report sub-module
│   │   ├── appointments/              # Appointments module
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── appointment_remote_datasource.dart
│   │   │   │   │   └── appointment_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── appointment_model.dart
│   │   │   │   │   ├── time_slot_model.dart
│   │   │   │   │   └── appointment_request_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── appointment_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── appointment.dart
│   │   │   │   │   ├── time_slot.dart
│   │   │   │   │   └── appointment_request.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── appointment_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── create_appointment_usecase.dart
│   │   │   │       ├── update_appointment_usecase.dart
│   │   │   │       ├── cancel_appointment_usecase.dart
│   │   │   │       └── get_appointments_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── appointments_list_page.dart
│   │   │       │   ├── appointment_details_page.dart
│   │   │       │   ├── create_appointment_page.dart
│   │   │       │   └── appointment_calendar_page.dart
│   │   │       ├── controllers/
│   │   │       │   ├── appointments_controller.dart
│   │   │       │   └── appointment_form_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── appointment_card.dart
│   │   │       │   ├── appointment_form.dart
│   │   │       │   ├── time_slot_selector.dart
│   │   │       │   └── appointment_calendar.dart
│   │   │       └── bindings/
│   │   │           └── appointments_binding.dart
│   │   ├── doctors/                  # Doctors module
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── doctor_remote_datasource.dart
│   │   │   │   │   └── doctor_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── doctor_model.dart
│   │   │   │   │   ├── specialty_model.dart
│   │   │   │   │   └── doctor_availability_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── doctor_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── doctor.dart
│   │   │   │   │   ├── specialty.dart
│   │   │   │   │   └── doctor_availability.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── doctor_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_doctors_usecase.dart
│   │   │   │       ├── get_doctor_details_usecase.dart
│   │   │   │       └── search_doctors_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── doctors_list_page.dart
│   │   │       │   ├── doctor_details_page.dart
│   │   │       │   └── doctor_search_page.dart
│   │   │       ├── controllers/
│   │   │       │   └── doctors_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── doctor_card.dart
│   │   │       │   ├── specialty_filter.dart
│   │   │       │   └── doctor_search_bar.dart
│   │   │       └── bindings/
│   │   │           └── doctors_binding.dart
│   │   ├── patients/                 # Patients module
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── patient_remote_datasource.dart
│   │   │   │   │   └── patient_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── patient_model.dart
│   │   │   │   │   ├── medical_history_model.dart
│   │   │   │   │   └── prescription_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── patient_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── patient.dart
│   │   │   │   │   ├── medical_history.dart
│   │   │   │   │   └── prescription.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── patient_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_patient_profile_usecase.dart
│   │   │   │       ├── update_patient_profile_usecase.dart
│   │   │   │       └── get_medical_history_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── patient_profile_page.dart
│   │   │       │   ├── medical_history_page.dart
│   │   │       │   └── prescriptions_page.dart
│   │   │       ├── controllers/
│   │   │       │   └── patient_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── patient_profile_form.dart
│   │   │       │   ├── medical_history_timeline.dart
│   │   │       │   └── prescription_card.dart
│   │   │       └── bindings/
│   │   │           └── patients_binding.dart
│   │   ├── chat/                     # Chat module
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── chat_remote_datasource.dart
│   │   │   │   │   └── chat_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── chat_message_model.dart
│   │   │   │   │   ├── chat_session_model.dart
│   │   │   │   │   └── ai_response_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── chat_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── chat_message.dart
│   │   │   │   │   ├── chat_session.dart
│   │   │   │   │   └── ai_response.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── chat_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── send_message_usecase.dart
│   │   │   │       ├── get_chat_history_usecase.dart
│   │   │   │       └── create_chat_session_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── chat_page.dart
│   │   │       │   ├── chat_list_page.dart
│   │   │       │   └── ai_chat_page.dart
│   │   │       ├── controllers/
│   │   │       │   └── chat_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── message_bubble.dart
│   │   │       │   ├── message_input.dart
│   │   │       │   └── typing_indicator.dart
│   │   │       └── bindings/
│   │   │           └── chat_binding.dart
│   │   ├── profile/                  # Profile module
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── profile_remote_datasource.dart
│   │   │   │   │   └── profile_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_profile_model.dart
│   │   │   │   │   └── organization_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── profile headers
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user_profile.dart
│   │   │   │   │   └── organization.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── profile_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_user_profile_usecase.dart
│   │   │   │       ├── update_user_profile_usecase.dart
│   │   │   │       └── upload_profile_image_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── profile_page.dart
│   │   │       │   ├── edit_profile_page.dart
│   │   │       │   └── settings_page.dart
│   │   │       ├── controllers/
│   │   │       │   └── profile_controller.dart
│   │   │       ├── widgets/
│   │   │       │   ├── profile_header.dart
│   │   │       │   ├── profile_form.dart
│   │   │       │   └── settings_tile.dart
│   │   │       └── bindings/
│   │   │           └── profile_binding.dart
│   │   └── notifications/            # Notifications module
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   ├── notification_remote_datasource.dart
│   │       │   │   └── notification_local_datasource.dart
│   │       │   ├── models/
│   │       │   │   ├── notification_model.dart
│   │       │   │   └── notification_settings_model.dart
│   │       │   └── repositories/
│   │       │       └── notification_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── notification.dart
│   │       │   │   └── notification_settings.dart
│   │       │   ├── repositories/
│   │       │   │   └── notification_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_notifications_usecase.dart
│   │       │       ├── mark_notification_read_usecase.dart
│   │       │       └── update_notification_settings_usecase.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── notifications_page.dart
│   │           │   └── notification_settings_page.dart
│   │           ├── controllers/
│   │           │   └── notifications_controller.dart
│   │           ├── widgets/
│   │           │   ├── notification_card.dart
│   │           │   └── notification_badge.dart
│   │           └── bindings/
│   │               └── notifications_binding.dart
│   ├── shared/                       # Shared components and utilities
│   │   ├── widgets/                  # Reusable UI components
│   │   │   ├── common/
│   │   │   │   ├── loading_widget.dart
│   │   │   │   ├── error_widget.dart
│   │   │   │   ├── empty_state_widget.dart
│   │   │   │   ├── custom_button.dart
│   │   │   │   ├── custom_text_field.dart
│   │   │   │   └── custom_dialog.dart
│   │   │   ├── forms/
│   │   │   │   ├── form_builder.dart
│   │   │   │   ├── form_validator.dart
│   │   │   │   └── form_field_wrapper.dart
│   │   │   ├── navigation/
│   │   │   │   ├── bottom_nav_bar.dart
│   │   │   │   ├── app_bar.dart
│   │   │   │   └── drawer.dart
│   │   │   └── animations/
│   │   │       ├── fade_animation.dart
│   │   │       ├── slide_animation.dart
│   │   │       └── scale_animation.dart
│   │   ├── services/                 # Shared services
│   │   │   ├── connectivity_service.dart
│   │   │   ├── permission_service.dart
│   │   │   ├── location_service.dart
│   │   │   ├── image_picker_service.dart
│   │   │   └── notification_service.dart
│   │   ├── models/                   # Shared data models
│   │   │   ├── api_response.dart
│   │   │   ├── paginated_response.dart
│   │   │   ├── error_response.dart
│   │   │   └── base_entity.dart
│   │   └── utils/                    # Shared utilities
│   │       ├── date_utils.dart
│   │       ├── string_utils.dart
│   │       ├── validation_utils.dart
│   │       └── file_utils.dart
│   ├── main.dart                     # Application entry point
│   ├── app.dart                      # Main app widget
│   └── routes/                       # Application routing
│       ├── app_pages.dart
│       ├── app_routes.dart
│       └── route_middleware.dart
├── test/                             # Test files
│   ├── unit/                         # Unit tests
│   │   ├── core/
│   │   ├── features/
│   │   └── shared/
│   ├── widget/                       # Widget tests
│   │   ├── core/
│   │   ├── features/
│   │   └── shared/
│   ├── integration/                  # Integration tests
│   │   ├── auth_flow_test.dart
│   │   ├── appointment_flow_test.dart
│   │   └── ai_services_flow_test.dart
│   └── fixtures/                     # Test data fixtures
│       ├── json/
│       └── models/
├── assets/                           # Application assets
│   ├── images/
│   │   ├── logos/
│   │   ├── icons/
│   │   └── illustrations/
│   ├── fonts/
│   └── animations/
├── docs/                             # Documentation
│   ├── api/
│   ├── architecture/
│   ├── deployment/
│   └── user_guides/
├── scripts/                          # Build and deployment scripts
│   ├── build.sh
│   ├── deploy.sh
│   └── test.sh
├── pubspec.yaml                      # Dependencies and metadata
├── analysis_options.yaml            # Linting rules
├── README.md                         # Project documentation
└── .gitignore                        # Git ignore rules
```

## Package Naming Conventions

### **Feature Package Structure**
Each feature follows a consistent naming pattern:
```
feature_name/
├── data/
│   ├── datasources/feature_name_remote_datasource.dart
│   ├── datasources/feature_name_local_datasource.dart
│   ├── models/feature_name_model.dart
│   └── repositories/feature_name_repository_impl.dart
├── domain/
│   ├── entities/feature_name.dart
│   ├── repositories/feature_name_repository.dart
│   └── usecases/feature_name_usecase.dart
└── presentation/
    ├── pages/feature_name_page.dart
    ├── controllers/feature_name_controller.dart
    ├── widgets/feature_name_widget.dart
    └── bindings/feature_name_binding.dart
```

### **File Naming Conventions**
- **snake_case** for all file names
- **Descriptive names** that clearly indicate purpose
- **Consistent suffixes**: `_page.dart`, `_controller.dart`, `_widget.dart`, `_model.dart`, `_usecase.dart`

## Module APIs and Interaction

### **Clean Architecture Layers**

#### **Presentation Layer**
```dart
// Controller example
class AppointmentController extends GetxController {
  final CreateAppointmentUsecase _createAppointmentUsecase;
  final GetAppointmentsUsecase _getAppointmentsUsecase;
  
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxBool isLoading = false.obs;
  
  AppointmentController({
    required CreateAppointmentUsecase createAppointmentUsecase,
    required GetAppointmentsUsecase getAppointmentsUsecase,
  }) : _createAppointmentUsecase = createAppointmentUsecase,
       _getAppointmentsUsecase = getAppointmentsUsecase;
  
  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }
  
  Future<void> loadAppointments() async {
    isLoading.value = true;
    try {
      final result = await _getAppointmentsUsecase.execute();
      if (result.isRight()) {
        appointments.value = result.getOrElse(() => []);
      } else {
        _handleError(result.fold((l) => l, (r) => null));
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> createAppointment(CreateAppointmentRequest request) async {
    isLoading.value = true;
    try {
      final result = await _createAppointmentUsecase.execute(request);
      if (result.isRight()) {
        appointments.add(result.getOrElse(() => null)!);
        Get.snackbar('Success', 'Appointment created successfully');
      } else {
        _handleError(result.fold((l) => l, (r) => null));
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
  
  void _handleError(dynamic error) {
    Get.snackbar('Error', error.toString());
  }
}
```

#### **Domain Layer**
```dart
// Use case example
class CreateAppointmentUsecase {
  final AppointmentRepository _repository;
  
  CreateAppointmentUsecase(this._repository);
  
  Future<Either<Failure, Appointment>> execute(CreateAppointmentRequest request) async {
    try {
      // Business logic validation
      if (request.doctorId.isEmpty) {
        return Left(ValidationFailure('Doctor ID is required'));
      }
      
      if (request.scheduledAt.isBefore(DateTime.now())) {
        return Left(ValidationFailure('Appointment cannot be scheduled in the past'));
      }
      
      // Call repository
      final result = await _repository.createAppointment(request);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// Repository interface
abstract class AppointmentRepository {
  Future<Appointment> createAppointment(CreateAppointmentRequest request);
  Future<List<Appointment>> getAppointments();
  Future<Appointment> updateAppointment(String id, UpdateAppointmentRequest request);
  Future<void> deleteAppointment(String id);
}
```

#### **Data Layer**
```dart
// Repository implementation
class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource _remoteDataSource;
  final AppointmentLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  
  AppointmentRepositoryImpl({
    required AppointmentRemoteDataSource remoteDataSource,
    required AppointmentLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;
  
  @override
  Future<Appointment> createAppointment(CreateAppointmentRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final appointmentModel = await _remoteDataSource.createAppointment(request);
        await _localDataSource.cacheAppointment(appointmentModel);
        return appointmentModel.toEntity();
      } catch (e) {
        // Fallback to local storage for offline capability
        final appointmentModel = await _localDataSource.createAppointment(request);
        return appointmentModel.toEntity();
      }
    } else {
      // Offline mode
      final appointmentModel = await _localDataSource.createAppointment(request);
      return appointmentModel.toEntity();
    }
  }
  
  @override
  Future<List<Appointment>> getAppointments() async {
    if (await _networkInfo.isConnected) {
      try {
        final appointmentModels = await _remoteDataSource.getAppointments();
        await _localDataSource.cacheAppointments(appointmentModels);
        return appointmentModels.map((model) => model.toEntity()).toList();
      } catch (e) {
        // Fallback to local data
        final appointmentModels = await _localDataSource.getCachedAppointments();
        return appointmentModels.map((model) => model.toEntity()).toList();
      }
    } else {
      // Offline mode
      final appointmentModels = await _localDataSource.getCachedAppointments();
      return appointmentModels.map((model) => model.toEntity()).toList();
    }
  }
}
```

## Team Parallelization Model

### **Team Structure**

#### **Core Platform Team**
- **Responsibilities**: Core infrastructure, shared components, CI/CD
- **Modules**: `core/`, `shared/`, `main.dart`, `app.dart`, `routes/`
- **Key Files**: 
  - `lib/core/`
  - `lib/shared/`
  - `lib/main.dart`
  - `lib/app.dart`
  - `lib/routes/`

#### **Authentication & Security Team**
- **Responsibilities**: User authentication, security, permissions
- **Modules**: `auth/`, `profile/`
- **Key Files**:
  - `lib/features/auth/`
  - `lib/features/profile/`

#### **AI Services Team**
- **Responsibilities**: All AI-powered features and integrations
- **Modules**: `ai_services/` (all sub-modules)
- **Key Files**:
  - `lib/features/ai_services/`

#### **Healthcare Features Team**
- **Responsibilities**: Core healthcare functionality
- **Modules**: `appointments/`, `doctors/`, `patients/`
- **Key Files**:
  - `lib/features/appointments/`
  - `lib/features/doctors/`
  - `lib/features/patients/`

#### **Communication Team**
- **Responsibilities**: Chat, notifications, real-time features
- **Modules**: `chat/`, `notifications/`
- **Key Files**:
  - `lib/features/chat/`
  - `lib/features/notifications/`

#### **UI/UX Team**
- **Responsibilities**: Design system, animations, user experience
- **Modules**: All `presentation/` layers, `shared/widgets/`
- **Key Files**:
  - All `lib/features/*/presentation/` directories
  - `lib/shared/widgets/`
  - `lib/core/theme/`

### **Parallel Development Workflow**

#### **Feature Branch Strategy**
```bash
# Each team works on feature branches
git checkout -b feature/team-name/feature-description

# Examples:
git checkout -b feature/auth/jwt-authentication
git checkout -b feature/ai/symptom-checker
git checkout -b feature/healthcare/appointment-booking
git checkout -b feature/communication/real-time-chat
```

#### **Integration Points**
```dart
// Shared interfaces for team coordination
abstract class IAuthService {
  Future<AuthResult> login(String email, String password);
  Future<void> logout();
  Future<String?> getAccessToken();
}

abstract class INotificationService {
  Future<void> sendNotification(Notification notification);
  Stream<Notification> getNotificationStream();
}

abstract class IAnalyticsService {
  void trackEvent(String eventName, Map<String, dynamic> properties);
  void trackScreen(String screenName);
}
```

#### **Dependency Management**
```dart
// Service locator for dependency injection
class ServiceLocator {
  static final GetIt _instance = GetIt.instance;
  
  static void setup() {
    // Core services
    _instance.registerLazySingleton<IAuthService>(() => AuthService());
    _instance.registerLazySingleton<INotificationService>(() => NotificationService());
    _instance.registerLazySingleton<IAnalyticsService>(() => AnalyticsService());
    
    // Feature-specific services
    _instance.registerLazySingleton<SymptomCheckerService>(() => SymptomCheckerServiceImpl());
    _instance.registerLazySingleton<AppointmentService>(() => AppointmentServiceImpl());
  }
}
```

## Module Communication Patterns

### **Event-Driven Communication**
```dart
// Event bus for loose coupling between modules
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();
  
  final StreamController<AppEvent> _eventController = StreamController.broadcast();
  
  Stream<T> on<T>() => _eventController.stream.where((event) => event is T).cast<T>();
  
  void emit(AppEvent event) => _eventController.add(event);
}

// Event definitions
abstract class AppEvent {}

class AppointmentCreatedEvent extends AppEvent {
  final Appointment appointment;
  AppointmentCreatedEvent(this.appointment);
}

class UserLoggedInEvent extends AppEvent {
  final User user;
  UserLoggedInEvent(this.user);
}

// Usage in controllers
class AppointmentController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    EventBus().on<AppointmentCreatedEvent>().listen((event) {
      // Handle appointment creation event
      appointments.add(event.appointment);
    });
  }
  
  Future<void> createAppointment(CreateAppointmentRequest request) async {
    // ... create appointment logic
    EventBus().emit(AppointmentCreatedEvent(appointment));
  }
}
```

### **Repository Pattern with Dependency Injection**
```dart
// Binding classes for each feature
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
    
    // Repository
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
      remoteDataSource: Get.find(),
      localDataSource: Get.find(),
    ));
    
    // Use cases
    Get.lazyPut<LoginUsecase>(() => LoginUsecase(Get.find()));
    Get.lazyPut<LogoutUsecase>(() => LogoutUsecase(Get.find()));
    
    // Controller
    Get.lazyPut<AuthController>(() => AuthController(
      loginUsecase: Get.find(),
      logoutUsecase: Get.find(),
    ));
  }
}
```

This modular structure enables teams to work independently while maintaining clear boundaries and consistent patterns across the entire application. Each module is self-contained with its own data flow, business logic, and presentation layer, making the codebase maintainable and scalable.