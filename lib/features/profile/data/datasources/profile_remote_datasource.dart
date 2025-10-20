import '../../../../core/network/api_client.dart';
import '../../data/models/organization_model.dart';
import '../../data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile);
  Future<UserProfileModel> uploadProfileImage(String base64Image);
  Future<OrganizationModel> getOrganization();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;
  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserProfileModel> getUserProfile() async {
    final res = await _apiClient.get('/users/me');
    return UserProfileModel.fromJson(res.data);
  }

  @override
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    final res = await _apiClient.put('/users/me', data: profile.toJson());
    return UserProfileModel.fromJson(res.data);
  }

  @override
  Future<UserProfileModel> uploadProfileImage(String base64Image) async {
    final res = await _apiClient.post('/users/me/avatar', data: {
      'image_base64': base64Image,
    });
    return UserProfileModel.fromJson(res.data);
  }

  @override
  Future<OrganizationModel> getOrganization() async {
    final res = await _apiClient.get('/users/organization');
    return OrganizationModel.fromJson(res.data);
  }
}


