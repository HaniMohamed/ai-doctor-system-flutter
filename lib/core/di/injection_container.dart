import 'package:get_it/get_it.dart';
import 'service_locator.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core services
  await ServiceLocator.setup();
  
  // Feature services will be registered here as they are implemented
  // Example:
  // sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
}
