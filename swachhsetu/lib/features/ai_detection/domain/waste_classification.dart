import 'package:equatable/equatable.dart';

enum WasteClassificationCategory {
  wetWaste,
  dryWaste,
  plastic,
  paper,
  metal,
  glass,
  eWaste,
  hazardousWaste,
  organicWaste,
  mixedWaste,
  unknown,
}

extension WasteClassificationCategoryLabel on WasteClassificationCategory {
  String get label => switch (this) {
    WasteClassificationCategory.wetWaste => 'Wet Waste',
    WasteClassificationCategory.dryWaste => 'Dry Waste',
    WasteClassificationCategory.plastic => 'Plastic',
    WasteClassificationCategory.paper => 'Paper',
    WasteClassificationCategory.metal => 'Metal',
    WasteClassificationCategory.glass => 'Glass',
    WasteClassificationCategory.eWaste => 'E-Waste',
    WasteClassificationCategory.hazardousWaste => 'Hazardous Waste',
    WasteClassificationCategory.organicWaste => 'Organic Waste',
    WasteClassificationCategory.mixedWaste => 'Mixed Waste',
    WasteClassificationCategory.unknown => 'Unknown',
  };
}

class WasteClassificationResult extends Equatable {
  const WasteClassificationResult({
    required this.category,
    required this.confidence,
    required this.recommendation,
    required this.isDemoPrediction,
  });
  final WasteClassificationCategory category;
  final double confidence;
  final String recommendation;
  final bool isDemoPrediction;
  @override
  List<Object> get props => [
    category,
    confidence,
    recommendation,
    isDemoPrediction,
  ];
}

class WasteClassification extends Equatable {
  const WasteClassification({required this.imagePath, required this.result});
  final String imagePath;
  final WasteClassificationResult result;
  @override
  List<Object> get props => [imagePath, result];
}
