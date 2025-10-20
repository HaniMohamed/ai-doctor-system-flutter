class EnvironmentConfig {
  static const String _environment = String.fromEnvironment('ENV', defaultValue: 'development');

  static String get apiBaseUrl {
    switch (_environment) {
      case 'production':
        return 'https://api.aidoctorsystem.com';
      case 'staging':
        return 'https://staging-api.aidoctorsystem.com';
      case 'testing':
        return 'https://testing-api.aidoctorsystem.com';
      default:
        return 'http://localhost:8000';
    }
  }

  static String get websocketUrl {
    switch (_environment) {
      case 'production':
        return 'wss://api.aidoctorsystem.com/api/v1';
      case 'staging':
        return 'wss://staging-api.aidoctorsystem.com/api/v1';
      case 'testing':
        return 'wss://testing-api.aidoctorsystem.com/api/v1';
      default:
        return 'ws://localhost:8000/api/v1';
    }
  }

  static bool get enableLogging {
    switch (_environment) {
      case 'production':
        return false;
      case 'staging':
      case 'testing':
        return true;
      default:
        return true;
    }
  }
}


