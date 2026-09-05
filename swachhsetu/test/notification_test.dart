import 'package:flutter_test/flutter_test.dart';
import 'package:swachhsetu/core/network/result.dart';
import 'package:swachhsetu/features/notifications/data/notification_repository.dart';
import 'package:swachhsetu/features/notifications/domain/notification_model.dart';

void main() {
  test('demo notifications support ownership and read actions', () async {
    final repo = DemoNotificationRepository();
    final initial = await repo.getMine('demo-user');
    final items = initial is Success<List<AppNotification>>
        ? initial.value
        : const <AppNotification>[];
    expect(items, isNotEmpty);
    expect(items.where((e) => !e.isRead), isNotEmpty);
    await repo.markAllRead('demo-user');
    final updated = await repo.getMine('demo-user');
    final values = updated is Success<List<AppNotification>>
        ? updated.value
        : const <AppNotification>[];
    expect(values.every((e) => e.isRead), isTrue);
  });
}
