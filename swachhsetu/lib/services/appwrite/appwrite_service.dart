import 'package:appwrite/appwrite.dart';

import '../../core/config/appwrite_config.dart';
import '../../core/utils/app_logger.dart';

class AppwriteService {
  AppwriteService(this.config) {
    _initialize();
  }

  final AppwriteConfig config;
  Client? _client;
  Account? _account;
  Databases? _databases;
  Storage? _storage;
  Realtime? _realtime;

  Client? get client => _client;
  Account? get account => _account;
  Databases? get databases => _databases;
  Storage? get storage => _storage;
  Realtime? get realtime => _realtime;
  bool get isReady => config.isConfigured && _client != null;

  void _initialize() {
    if (!config.isConfigured) {
      AppLogger.debug(
        'Appwrite is not configured; demo infrastructure remains active.',
      );
      return;
    }

    _client = Client()
      ..setEndpoint(config.endpoint)
      ..setProject(config.projectId);
    _account = Account(_client!);
    _databases = Databases(_client!);
    _storage = Storage(_client!);
    _realtime = Realtime(_client!);
  }
}
