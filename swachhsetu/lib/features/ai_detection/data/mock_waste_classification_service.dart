import '../domain/waste_classification.dart';
import '../domain/waste_classification_service.dart';

class MockWasteClassificationService implements WasteClassificationService {
  const MockWasteClassificationService();
  @override
  Future<WasteClassificationResult> classify(
    String imagePath,
  ) async => const WasteClassificationResult(
    category: WasteClassificationCategory.dryWaste,
    confidence: 0.87,
    recommendation:
        'Place clean paper, cardboard, and recyclable packaging in the dry waste stream.',
    isDemoPrediction: true,
  );
}
