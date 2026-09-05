import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/result.dart';
import '../../../core/config/app_providers.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/notification_repository.dart';
import '../data/appwrite_notification_repository.dart';
import '../domain/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return ref.watch(appConfigProvider).demoMode
      ? DemoNotificationRepository()
      : AppwriteNotificationRepository(ref.watch(appwriteServiceProvider));
});

final notificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  final userId =
      ref.watch(authControllerProvider).value?.user?.id ?? 'demo-user';
  final result = await ref
      .watch(notificationRepositoryProvider)
      .getMine(userId);
  return switch (result) {
    Success(value: final items) => items,
    FailureResult(failure: final failure) => throw failure,
  };
});

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsProvider);
    final userId =
        ref.watch(authControllerProvider).value?.user?.id ?? 'demo-user';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref
                  .read(notificationRepositoryProvider)
                  .markAllRead(userId);
              ref.invalidate(notificationsProvider);
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorState(
          message: 'Notifications unavailable',
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (items) => items.isEmpty
            ? const EmptyState(message: 'No notifications yet')
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    onTap: () async {
                      await ref
                          .read(notificationRepositoryProvider)
                          .markRead(item.id);
                      ref.invalidate(notificationsProvider);
                    },
                    leading: Icon(
                      item.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.message),
                  );
                },
              ),
      ),
    );
  }
}
