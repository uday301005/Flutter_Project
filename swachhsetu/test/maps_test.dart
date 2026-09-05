import 'package:flutter_test/flutter_test.dart';

import 'package:swachhsetu/services/maps/map_models.dart';
import 'package:swachhsetu/services/maps/map_service.dart';

void main() {
  test('demo map service provides bins and collection centers', () async {
    final markers = await const DemoMapService().nearbyFacilities();
    expect(markers, isNotEmpty);
    expect(markers.any((marker) => marker.type == 'Bin'), isTrue);
    expect(markers.any((marker) => marker.type == 'Collection Center'), isTrue);
    expect(markers.first.position, const LatLngModel(28.6139, 77.2090));
  });

  test('facility waste filters can select supported types', () async {
    final markers = await const DemoMapService().nearbyFacilities();
    final filtered = markers
        .where((marker) => marker.supportedWasteTypes.contains('Plastic'))
        .toList();
    expect(filtered, isNotEmpty);
    expect(
      filtered.every(
        (marker) => marker.supportedWasteTypes.contains('Plastic'),
      ),
      isTrue,
    );
  });
}
