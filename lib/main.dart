import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await initializeDependencies();
  
  runApp(const AIDoctorApp());
}
