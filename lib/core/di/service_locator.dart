import 'package:connectivity_plus/connectivity_plus.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/services/auth_service_impl.dart';
import '../../features/auth/domain/services/auth_service.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../storage/cache_manager.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import 'injection_container.dart';

class ServiceLocator {
  static Future<void> setup() async {
    // Network
    sl.registerLazySingleton<ApiClient>(() => ApiClient());

    // Storage
    sl.registerLazySingleton<LocalStorage>(() => LocalStorage());
    sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
    sl.registerLazySingleton<CacheManager>(() => CacheManager());

    // Network info
    sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(Connectivity()));

    // Auth data sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
    );
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        localStorage: sl<LocalStorage>(),
        secureStorage: sl<SecureStorage>(),
      ),
    );

    // Auth service
    sl.registerLazySingleton<AuthService>(
      () => AuthServiceImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        localDataSource: sl<AuthLocalDataSource>(),
        secureStorage: sl<SecureStorage>(),
      ),
    );

    // Initialize storage services
    await sl<LocalStorage>().initialize();
    await sl<SecureStorage>().initialize();
    await sl<CacheManager>().initialize();
  }
}
