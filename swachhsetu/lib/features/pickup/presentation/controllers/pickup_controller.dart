import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_providers.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/result.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/demo_pickup_repository.dart';
import '../../data/appwrite_pickup_repository.dart';
import '../../domain/pickup_repository.dart';
import '../../domain/pickup_request.dart';

final pickupRepositoryProvider = Provider<PickupRepository>(
  (ref) => ref.watch(appConfigProvider).demoMode
      ? DemoPickupRepository()
      : AppwritePickupRepository(ref.watch(appwriteServiceProvider)),
);
final pickupControllerProvider =
    AsyncNotifierProvider<PickupController, PickupRequest?>(
      PickupController.new,
    );

class PickupController extends AsyncNotifier<PickupRequest?> {
  @override
  Future<PickupRequest?> build() async => null;
  Future<Result<PickupRequest>> submit({
    required PickupWasteType? wasteType,
    required PickupQuantity? quantity,
    required String address,
    required DateTime? date,
    required String? time,
    String? notes,
  }) async {
    if (wasteType == null) {
      return const FailureResult(ValidationFailure('Choose a waste type.'));
    }
    if (quantity == null) {
      return const FailureResult(ValidationFailure('Choose a quantity.'));
    }
    if (date == null || time == null) {
      return const FailureResult(ValidationFailure('Choose a date and time.'));
    }
    if (address.trim().isEmpty) {
      return const FailureResult(ValidationFailure('Enter a pickup address.'));
    }
    state = const AsyncLoading();
    final now = DateTime.now();
    final result = await ref
        .read(pickupRepositoryProvider)
        .submit(
          PickupRequest(
            id: '',
            userId:
                ref.read(authControllerProvider).value?.user?.id ?? 'demo-user',
            wasteType: wasteType,
            quantity: quantity,
            address: address,
            preferredDate: date,
            preferredTime: time,
            notes: notes,
            status: PickupStatus.requested,
            createdAt: now,
            updatedAt: now,
          ),
        );
    state = switch (result) {
      Success(value: final item) => AsyncData(item),
      FailureResult(failure: final failure) => AsyncError(
        failure,
        StackTrace.current,
      ),
    };
    return result;
  }
}
