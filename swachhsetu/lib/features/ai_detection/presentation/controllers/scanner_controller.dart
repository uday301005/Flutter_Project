import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/waste_classification.dart';
import '../../data/mock_waste_classification_service.dart';
import '../../domain/waste_classification_service.dart';

final wasteClassificationServiceProvider = Provider<WasteClassificationService>(
  (ref) => const MockWasteClassificationService(),
);
final scannerControllerProvider =
    AsyncNotifierProvider<ScannerController, WasteClassificationResult?>(
      ScannerController.new,
    );

class ScannerController extends AsyncNotifier<WasteClassificationResult?> {
  @override
  Future<WasteClassificationResult?> build() async => null;
  Future<void> analyze(String imagePath) async {
    state = const AsyncLoading();
    try {
      state = AsyncData(
        await ref.read(wasteClassificationServiceProvider).classify(imagePath),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  void reset() => state = const AsyncData(null);
}
