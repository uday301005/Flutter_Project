import '../../../core/network/result.dart';
import '../domain/notification_model.dart';

abstract interface class NotificationRepository {
  Future<Result<List<AppNotification>>> getMine(String userId);
  Future<Result<void>> markRead(String id);
  Future<Result<void>> markAllRead(String userId);
}

class DemoNotificationRepository implements NotificationRepository {
  final _items = <AppNotification>[
    AppNotification(
      id: 'n1',
      userId: 'demo-user',
      title: 'Report submitted',
      message: 'Your waste report is now under review.',
      type: NotificationType.reportSubmitted,
      isRead: false,
      createdAt: DateTime.now(),
    ),
    AppNotification(
      id: 'n2',
      userId: 'demo-user',
      title: 'Small actions matter',
      message: 'Separate wet and dry waste before disposal.',
      type: NotificationType.awareness,
      isRead: true,
      createdAt: DateTime.now(),
    ),
  ];
  @override
  Future<Result<List<AppNotification>>> getMine(String userId) async =>
      Success(_items.where((e) => e.userId == userId).toList());
  @override
  Future<Result<void>> markRead(String id) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i >= 0) _items[i] = _items[i].markRead();
    return const Success(null);
  }

  @override
  Future<Result<void>> markAllRead(String userId) async {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].userId == userId) _items[i] = _items[i].markRead();
    }
    return const Success(null);
  }
}
