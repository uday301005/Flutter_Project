import 'map_models.dart';

abstract interface class MapService {
  Future<List<MapMarkerData>> nearbyFacilities();
}

class DemoMapService implements MapService {
  const DemoMapService();
  @override
  Future<List<MapMarkerData>> nearbyFacilities() async => const [
    MapMarkerData(
      id: 'bin-1',
      name: 'Community Waste Bin',
      position: LatLngModel(28.6139, 77.2090),
      type: 'Bin',
      distance: '500 m away',
      status: 'Available',
      address: 'Central community lane',
      supportedWasteTypes: ['Wet', 'Dry', 'Mixed'],
    ),
    MapMarkerData(
      id: 'center-1',
      name: 'Dry Waste Collection Center',
      position: LatLngModel(28.6148, 77.2080),
      type: 'Collection Center',
      distance: '350 m away',
      status: 'Open',
      address: 'Civic Centre Road',
      openingHours: '8:00 AM - 6:00 PM',
      supportedWasteTypes: ['Dry', 'Plastic', 'Paper'],
    ),
    MapMarkerData(
      id: 'center-2',
      name: 'Recycling Center',
      position: LatLngModel(28.6170, 77.2120),
      type: 'Collection Center',
      distance: '1.2 km away',
      status: 'Open',
      address: 'Green Park Road',
      openingHours: '9:00 AM - 5:00 PM',
      supportedWasteTypes: ['Plastic', 'E-Waste', 'Metal'],
    ),
  ];
}
