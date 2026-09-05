import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/maps/map_models.dart';
import '../../../../services/maps/map_service.dart';

final mapServiceProvider = Provider<MapService>(
  (ref) => const DemoMapService(),
);
final exploreFacilitiesProvider = FutureProvider<List<MapMarkerData>>(
  (ref) => ref.watch(mapServiceProvider).nearbyFacilities(),
);
