import 'package:uuid/uuid.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/result.dart';
import '../domain/pickup_repository.dart';
import '../domain/pickup_request.dart';

class DemoPickupRepository implements PickupRepository {
  final _items = <PickupRequest>[];
  @override
  Future<Result<PickupRequest>> submit(PickupRequest request) async {
    if (request.address.trim().isEmpty) {
      return const FailureResult(ValidationFailure('Address is required.'));
    }
    final saved = PickupRequest(
      id: request.id.isEmpty
          ? 'PK-${const Uuid().v4().substring(0, 4).toUpperCase()}'
          : request.id,
      userId: request.userId,
      wasteType: request.wasteType,
      quantity: request.quantity,
      address: request.address.trim(),
      latitude: request.latitude,
      longitude: request.longitude,
      preferredDate: request.preferredDate,
      preferredTime: request.preferredTime,
      notes: request.notes,
      status: PickupStatus.requested,
      createdAt: request.createdAt,
      updatedAt: DateTime.now(),
    );
    _items.add(saved);
    return Success(saved);
  }

  @override
  Future<Result<List<PickupRequest>>> getMine(String userId) async =>
      Success(List.unmodifiable(_items.where((item) => item.userId == userId)));
}
