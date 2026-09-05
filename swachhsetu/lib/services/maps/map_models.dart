import 'package:equatable/equatable.dart';

class LatLngModel extends Equatable {
  const LatLngModel(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
  @override
  List<Object> get props => [latitude, longitude];
}

class MapMarkerData extends Equatable {
  const MapMarkerData({
    required this.id,
    required this.name,
    required this.position,
    required this.type,
    required this.distance,
    required this.status,
    this.address,
    this.openingHours,
    this.supportedWasteTypes = const [],
  });
  final String id;
  final String name;
  final LatLngModel position;
  final String type;
  final String distance;
  final String status;
  final String? address;
  final String? openingHours;
  final List<String> supportedWasteTypes;
  @override
  List<Object?> get props => [
    id,
    name,
    position,
    type,
    distance,
    status,
    address,
    openingHours,
    supportedWasteTypes,
  ];
}
