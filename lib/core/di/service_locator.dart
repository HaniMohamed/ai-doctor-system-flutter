import 'injection_container.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/cache_manager.dart';
import '../../features/auth/domain/services/auth_service.dart';
import '../../features/auth/data/services/auth_service_impl.dart';
import '../network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ServiceLocator {
  static Future<void> setup() async {
    // Network
    sl.registerLazySingleton<ApiClient>(() => ApiClient());
    
    // Storage
    sl.registerLazySingleton<LocalStorage>(() => LocalStorage());
    sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
    sl.registerLazySingleton<CacheManager>(() => CacheManager());
    
    // Network info
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));
    
    // Auth service
    sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
    
    // Initialize storage services
    await sl<LocalStorage>().initialize();
    await sl<SecureStorage>().initialize();
    await sl<CacheManager>().initialize();
  }
}
