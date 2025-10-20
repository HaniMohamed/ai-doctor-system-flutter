import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/profile_remote_datasource.dart';
import '../datasources/profile_local_datasource.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remote,
    required ProfileLocalDataSource local,
    required NetworkInfo networkInfo,
  }) : _remote = remote, _local = local, _networkInfo = networkInfo;

  @override
  Future<UserProfile> getUserProfile() async {
    if (await _networkInfo.isConnected) {
      try {
        final profile = await _remote.getUserProfile();
        await _local.cacheUserProfile(profile);
        return profile;
      } catch (e) {
        final cached = await _local.getCachedUserProfile();
        if (cached != null) return cached;
        throw ServerException(e.toString());
      }
    } else {
      final cached = await _local.getCachedUserProfile();
      if (cached != null) return cached;
      throw const CacheException('No cached profile');
    }
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    if (await _networkInfo.isConnected) {
      final updated = await _remote.updateUserProfile(profile as dynamic);
      await _local.cacheUserProfile(updated);
      return updated;
    }
    throw const ServerException('Offline update not supported');
  }

  @override
  Future<UserProfile> uploadProfileImage(String base64Image) async {
    final updated = await _remote.uploadProfileImage(base64Image);
    await _local.cacheUserProfile(updated);
    return updated;
  }

  @override
  Future<Organization> getOrganization() async {
    final org = await _remote.getOrganization();
    return org;
  }
}


