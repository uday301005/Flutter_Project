import 'package:equatable/equatable.dart';

enum NotificationType { reportSubmitted, reportUpdate, pickupUpdate, awareness }

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedEntityId,
  });
  final String id, userId, title, message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedEntityId;
  AppNotification markRead() => AppNotification(
    id: id,
    userId: userId,
    title: title,
    message: message,
    type: type,
    isRead: true,
    createdAt: createdAt,
    relatedEntityId: relatedEntityId,
  );
  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    message,
    type,
    isRead,
    createdAt,
    relatedEntityId,
  ];
}
