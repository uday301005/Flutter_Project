import '../../../core/network/result.dart';
import 'pickup_request.dart';

abstract interface class PickupRepository {
  Future<Result<PickupRequest>> submit(PickupRequest request);
  Future<Result<List<PickupRequest>>> getMine(String userId);
}
