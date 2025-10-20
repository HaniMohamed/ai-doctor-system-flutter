import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUsecase {
  final ProfileRepository _repository;
  UpdateUserProfileUsecase(this._repository);

  Future<UserProfile> execute(UserProfile profile) {
    return _repository.updateUserProfile(profile);
  }
}


