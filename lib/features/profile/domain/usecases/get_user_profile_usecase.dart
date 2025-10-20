import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUsecase {
  final ProfileRepository _repository;
  GetUserProfileUsecase(this._repository);

  Future<UserProfile> execute() {
    return _repository.getUserProfile();
  }
}


