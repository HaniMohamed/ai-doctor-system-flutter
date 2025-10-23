import 'package:get/get.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/websocket/websocket_client.dart';
import '../../../../auth/domain/services/auth_service.dart';
import '../../data/datasources/booking_assistant_remote_datasource.dart';
import '../../data/repositories/booking_assistant_repository_impl.dart';
import '../../domain/repositories/booking_assistant_repository.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import '../../domain/usecases/get_available_doctors_usecase.dart';
import '../../domain/usecases/get_available_time_slots_usecase.dart';
import '../../domain/usecases/get_suggested_time_slots_usecase.dart';
import '../../domain/usecases/send_booking_message_usecase.dart';
import '../controllers/booking_assistant_controller.dart';

/// Binding for booking assistant dependencies
class BookingAssistantBinding extends Bindings {
  @override
  void dependencies() {
    // Register data sources
    Get.lazyPut<BookingAssistantRemoteDataSource>(
      () => BookingAssistantRemoteDataSourceImpl(
        apiClient: sl<ApiClient>(),
        webSocketClient: sl<WebSocketClient>(),
      ),
    );

    // Register repository
    Get.lazyPut<BookingAssistantRepository>(
      () => BookingAssistantRepositoryImpl(
        remoteDataSource: Get.find(),
      ),
    );

    // Register use cases
    Get.lazyPut<SendBookingMessageUseCase>(
      () => SendBookingMessageUseCase(Get.find()),
    );

    Get.lazyPut<GetAvailableDoctorsUseCase>(
      () => GetAvailableDoctorsUseCase(Get.find()),
    );

    Get.lazyPut<GetAvailableTimeSlotsUseCase>(
      () => GetAvailableTimeSlotsUseCase(Get.find()),
    );

    Get.lazyPut<BookAppointmentUseCase>(
      () => BookAppointmentUseCase(Get.find()),
    );

    Get.lazyPut<GetSuggestedTimeSlotsUseCase>(
      () => GetSuggestedTimeSlotsUseCase(Get.find()),
    );

    // Register controller
    Get.lazyPut<BookingAssistantController>(
      () => BookingAssistantController(
        sendMessageUseCase: Get.find(),
        getAvailableDoctorsUseCase: Get.find(),
        getAvailableTimeSlotsUseCase: Get.find(),
        bookAppointmentUseCase: Get.find(),
        getSuggestedTimeSlotsUseCase: Get.find(),
        remoteDataSource: Get.find(),
        authService: sl<AuthService>(),
      ),
    );
  }
}
