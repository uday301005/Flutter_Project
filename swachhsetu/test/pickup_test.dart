import 'package:flutter_test/flutter_test.dart';
import 'package:swachhsetu/core/network/result.dart';
import 'package:swachhsetu/features/pickup/data/demo_pickup_repository.dart';
import 'package:swachhsetu/features/pickup/domain/pickup_request.dart';

void main() {
  test('demo pickup submission creates requested owned item', () async {
    final result = await DemoPickupRepository().submit(
      PickupRequest(
        id: '',
        userId: 'u1',
        wasteType: PickupWasteType.dry,
        quantity: PickupQuantity.medium,
        address: 'Civic Road',
        preferredDate: DateTime(2026, 9, 1),
        preferredTime: '10:00 AM',
        status: PickupStatus.requested,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    expect(result, isA<Success<PickupRequest>>());
    final item = (result as Success<PickupRequest>).value;
    expect(item.id, startsWith('PK-'));
    expect(item.status, PickupStatus.requested);
  });
}
