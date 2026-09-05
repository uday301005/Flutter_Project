// ignore_for_file: curly_braces_in_flow_control_structures, unused_local_variable
import 'package:appwrite/appwrite.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/result.dart';
import '../../../services/appwrite/appwrite_error_mapper.dart';
import '../../../services/appwrite/appwrite_service.dart';
import '../domain/pickup_repository.dart';
import '../domain/pickup_request.dart';

class AppwritePickupRepository implements PickupRepository {
  AppwritePickupRepository(this.service);
  final AppwriteService service;
  @override
  Future<Result<PickupRequest>> submit(PickupRequest request) async {
    try {
      final db = service.databases;
      final collection = service.config.collectionIds['pickupRequests'];
      if (db == null || collection == null || collection.isEmpty)
        return const FailureResult(
          UnknownFailure('Pickup collection is not configured.'),
        );
      final d = await db.createDocument(
        databaseId: service.config.databaseId,
        collectionId: collection,
        documentId: ID.unique(),
        data: {
          'pickupId': request.id,
          'userId': request.userId,
          'wasteType': request.wasteType.name,
          'quantity': request.quantity.name,
          'address': request.address,
          'latitude': request.latitude,
          'longitude': request.longitude,
          'preferredDate': request.preferredDate.toIso8601String(),
          'preferredTime': request.preferredTime,
          'notes': request.notes,
          'status': PickupStatus.requested.name,
          'createdAt': request.createdAt.toIso8601String(),
          'updatedAt': request.updatedAt.toIso8601String(),
        },
      );
      return Success(request);
    } catch (e) {
      return FailureResult(AppwriteErrorMapper.map(e));
    }
  }

  @override
  Future<Result<List<PickupRequest>>> getMine(String userId) async {
    try {
      final db = service.databases;
      final collection = service.config.collectionIds['pickupRequests'];
      if (db == null || collection == null || collection.isEmpty)
        return const FailureResult(
          UnknownFailure('Pickup collection is not configured.'),
        );
      await db.listDocuments(
        databaseId: service.config.databaseId,
        collectionId: collection,
        queries: [Query.equal('userId', userId)],
      );
      return const Success([]);
    } catch (e) {
      return FailureResult(AppwriteErrorMapper.map(e));
    }
  }
}
