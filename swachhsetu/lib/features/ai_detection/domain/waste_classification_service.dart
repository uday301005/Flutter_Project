import 'waste_classification.dart';

abstract interface class WasteClassificationService {
  Future<WasteClassificationResult> classify(String imagePath);
}
