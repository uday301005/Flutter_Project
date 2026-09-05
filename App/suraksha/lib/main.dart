import 'package:flutter/material.dart';
import 'app.dart';
import 'services/background_service.dart';

void main() async {
  debugPrint('🔍 main() started');

  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundService.initialize();

  debugPrint('✅ WidgetsFlutterBinding ensured');

  runApp(const MyApp());

  debugPrint('✅ MyApp started');
}