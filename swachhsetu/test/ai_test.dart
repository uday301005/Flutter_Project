import 'package:flutter_test/flutter_test.dart';

import 'package:swachhsetu/features/ai_detection/data/mock_waste_classification_service.dart';
import 'package:swachhsetu/features/ai_detection/domain/waste_classification.dart';

void main() {
  test('classification supports all documented categories', () {
    expect(WasteClassificationCategory.values, hasLength(11));
    expect(WasteClassificationCategory.eWaste.label, 'E-Waste');
    expect(WasteClassificationCategory.unknown.label, 'Unknown');
  });

  test(
    'mock classifier returns an explicitly labeled demo prediction',
    () async {
      final result = await const MockWasteClassificationService().classify(
        'local-image.jpg',
      );
      expect(result.isDemoPrediction, isTrue);
      expect(result.category, WasteClassificationCategory.dryWaste);
      expect(result.confidence, inInclusiveRange(0, 1));
      expect(result.recommendation, isNotEmpty);
    },
  );
}
