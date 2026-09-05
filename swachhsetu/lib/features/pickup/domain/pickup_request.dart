import 'package:equatable/equatable.dart';

enum PickupWasteType { wet, dry, plastic, eWaste, organic, mixed, other }

enum PickupQuantity { small, medium, large }

enum PickupStatus {
  requested,
  accepted,
  assigned,
  onTheWay,
  collected,
  completed,
  cancelled,
}

extension PickupWasteTypeLabel on PickupWasteType {
  String get label => switch (this) {
    PickupWasteType.wet => 'Wet',
    PickupWasteType.dry => 'Dry',
    PickupWasteType.plastic => 'Plastic',
    PickupWasteType.eWaste => 'E-Waste',
    PickupWasteType.organic => 'Organic',
    PickupWasteType.mixed => 'Mixed',
    PickupWasteType.other => 'Other',
  };
}

extension PickupQuantityLabel on PickupQuantity {
  String get label => switch (this) {
    PickupQuantity.small => 'Small',
    PickupQuantity.medium => 'Medium',
    PickupQuantity.large => 'Large',
  };
}

extension PickupStatusLabel on PickupStatus {
  String get label => switch (this) {
    PickupStatus.requested => 'Requested',
    PickupStatus.accepted => 'Accepted',
    PickupStatus.assigned => 'Assigned',
    PickupStatus.onTheWay => 'On the Way',
    PickupStatus.collected => 'Collected',
    PickupStatus.completed => 'Completed',
    PickupStatus.cancelled => 'Cancelled',
  };
}

class PickupRequest extends Equatable {
  const PickupRequest({
    required this.id,
    required this.userId,
    required this.wasteType,
    required this.quantity,
    required this.address,
    this.latitude,
    this.longitude,
    required this.preferredDate,
    required this.preferredTime,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id, userId, address, preferredTime;
  final PickupWasteType wasteType;
  final PickupQuantity quantity;
  final double? latitude, longitude;
  final DateTime preferredDate, createdAt, updatedAt;
  final String? notes;
  final PickupStatus status;
  @override
  List<Object?> get props => [
    id,
    userId,
    wasteType,
    quantity,
    address,
    latitude,
    longitude,
    preferredDate,
    preferredTime,
    notes,
    status,
    createdAt,
    updatedAt,
  ];
}
