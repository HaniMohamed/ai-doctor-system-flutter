import '../../../../core/storage/local_storage.dart';
import '../../data/models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheUserProfile(UserProfileModel profile);
  Future<UserProfileModel?> getCachedUserProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorage _localStorage;
  static const String _key = 'user_profile';

  ProfileLocalDataSourceImpl(this._localStorage);

  @override
  Future<void> cacheUserProfile(UserProfileModel profile) async {
    await _localStorage.setString(_key, profile.toJson());
  }

  @override
  Future<UserProfileModel?> getCachedUserProfile() async {
    final data = _localStorage.getString(_key);
    if (data != null) {
      return UserProfileModel.fromJson(data);
    }
    return null;
  }
}


