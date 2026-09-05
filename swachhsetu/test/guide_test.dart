import 'package:flutter_test/flutter_test.dart';
import 'package:swachhsetu/features/waste_guide/domain/waste_guide_entry.dart';

void main() {
  test('guide contains practical searchable categories', () {
    expect(
      wasteGuideEntries.map((e) => e.title),
      containsAll(['Wet Waste', 'Dry Waste', 'Plastic', 'E-Waste']),
    );
    final result = wasteGuideEntries.where(
      (e) => e.title.toLowerCase().contains('plastic'),
    );
    expect(result.single.recommendation, isNotEmpty);
    expect(result.single.doText, isNotEmpty);
  });
}
