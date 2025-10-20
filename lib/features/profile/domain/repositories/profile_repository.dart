import '../entities/organization.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> updateUserProfile(UserProfile profile);
  Future<UserProfile> uploadProfileImage(String base64Image);
  Future<Organization> getOrganization();
}


