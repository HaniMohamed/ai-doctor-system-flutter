import 'package:get/get.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

class ProfileController extends GetxController {
  final GetUserProfileUsecase _getUserProfileUsecase;
  final UpdateUserProfileUsecase _updateUserProfileUsecase;

  ProfileController({
    required GetUserProfileUsecase getUserProfileUsecase,
    required UpdateUserProfileUsecase updateUserProfileUsecase,
  }) : _getUserProfileUsecase = getUserProfileUsecase,
       _updateUserProfileUsecase = updateUserProfileUsecase;

  final Rx<UserProfile?> profile = Rx<UserProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      profile.value = await _getUserProfileUsecase.execute();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UserProfile updated) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      profile.value = await _updateUserProfileUsecase.execute(updated);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}


