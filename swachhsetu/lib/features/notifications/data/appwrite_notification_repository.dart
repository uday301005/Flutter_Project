// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:appwrite/appwrite.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/result.dart';
import '../../../services/appwrite/appwrite_error_mapper.dart';
import '../../../services/appwrite/appwrite_service.dart';
import '../domain/notification_model.dart';
import 'notification_repository.dart';

class AppwriteNotificationRepository implements NotificationRepository {
  AppwriteNotificationRepository(this.service);
  final AppwriteService service;

  @override
  Future<Result<List<AppNotification>>> getMine(String userId) async {
    try {
      final db = service.databases;
      final collection = service.config.collectionIds['notifications'];
      if (db == null || collection == null || collection.isEmpty)
        return const FailureResult(
          UnknownFailure('Notification collection is not configured.'),
        );
      final docs = await db.listDocuments(
        databaseId: service.config.databaseId,
        collectionId: collection,
        queries: [Query.equal('userId', userId), Query.orderDesc('createdAt')],
      );
      return Success(
        docs.documents.map((d) {
          final x = d.data;
          return AppNotification(
            id: d.$id,
            userId: x['userId'] as String? ?? userId,
            title: x['title'] as String? ?? '',
            message: x['message'] as String? ?? '',
            type: NotificationType.values.byName(
              x['type'] as String? ?? 'awareness',
            ),
            isRead: x['isRead'] as bool? ?? false,
            createdAt:
                DateTime.tryParse(x['createdAt'] as String? ?? '') ??
                DateTime.now(),
            relatedEntityId: x['relatedEntityId'] as String?,
          );
        }).toList(),
      );
    } catch (e) {
      return FailureResult(AppwriteErrorMapper.map(e));
    }
  }

  @override
  Future<Result<void>> markRead(String id) async {
    try {
      final db = service.databases;
      final c = service.config.collectionIds['notifications'];
      if (db == null || c == null || c.isEmpty)
        return const FailureResult(
          UnknownFailure('Notification collection is not configured.'),
        );
      await db.updateDocument(
        databaseId: service.config.databaseId,
        collectionId: c,
        documentId: id,
        data: {'isRead': true},
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(AppwriteErrorMapper.map(e));
    }
  }

  @override
  Future<Result<void>> markAllRead(String userId) async {
    final result = await getMine(userId);
    if (result is FailureResult<List<AppNotification>>)
      return FailureResult(result.failure);
    for (final item in (result as Success<List<AppNotification>>).value) {
      await markRead(item.id);
    }
    return const Success(null);
  }
}
