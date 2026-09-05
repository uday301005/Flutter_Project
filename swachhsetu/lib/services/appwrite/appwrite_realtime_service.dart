import 'package:appwrite/appwrite.dart';

import '../../core/utils/app_logger.dart';
import 'appwrite_service.dart';

class AppwriteRealtimeService {
  AppwriteRealtimeService(this._service);

  final AppwriteService _service;
  final _subscriptions = <RealtimeSubscription>[];

  RealtimeSubscription? subscribe(
    List<String> channels,
    void Function(RealtimeMessage) onMessage,
  ) {
    final realtime = _service.realtime;
    if (realtime == null) {
      AppLogger.debug('Realtime unavailable; callers should refresh normally.');
      return null;
    }
    final subscription = realtime.subscribe(channels);
    subscription.stream.listen(onMessage);
    _subscriptions.add(subscription);
    return subscription;
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.close();
    }
    _subscriptions.clear();
  }
}
