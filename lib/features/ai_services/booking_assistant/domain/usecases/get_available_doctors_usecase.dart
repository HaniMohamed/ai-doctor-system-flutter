import '../repositories/booking_assistant_repository.dart';

/// Use case for getting available doctors
class GetAvailableDoctorsUseCase {
  final BookingAssistantRepository _repository;

  const GetAvailableDoctorsUseCase(this._repository);

  /// Execute the use case to get available doctors
  Future<List<dynamic>> call({
    String? specialtyId,
    Map<String, dynamic>? preferences,
  }) async {
    return await _repository.getAvailableDoctors(
      specialtyId: specialtyId,
      preferences: preferences,
    );
  }
}
