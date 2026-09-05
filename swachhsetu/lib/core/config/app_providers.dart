import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/appwrite/appwrite_service.dart';
import 'app_config.dart';
import 'appwrite_config.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});

final appwriteConfigProvider = Provider<AppwriteConfig>((ref) {
  return AppwriteConfig.fromEnvironment();
});

final appwriteServiceProvider = Provider<AppwriteService>((ref) {
  return AppwriteService(ref.watch(appwriteConfigProvider));
});
