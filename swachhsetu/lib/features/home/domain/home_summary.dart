import 'package:equatable/equatable.dart';

enum RequestKind { report, pickup }

enum RequestStatus {
  submitted,
  underReview,
  assigned,
  inProgress,
  resolved,
  completed,
}

class HomeRequest extends Equatable {
  const HomeRequest({
    required this.kind,
    required this.id,
    required this.status,
    required this.createdLabel,
    required this.location,
  });

  final RequestKind kind;
  final String id;
  final RequestStatus status;
  final String createdLabel;
  final String location;

  String get typeLabel =>
      kind == RequestKind.report ? 'Waste Report' : 'Pickup Request';
  String get statusLabel => switch (status) {
    RequestStatus.submitted => 'Submitted',
    RequestStatus.underReview => 'Under Review',
    RequestStatus.assigned => 'Assigned',
    RequestStatus.inProgress => 'In Progress',
    RequestStatus.resolved => 'Resolved',
    RequestStatus.completed => 'Completed',
  };

  @override
  List<Object> get props => [kind, id, status, createdLabel, location];
}

class NearbyFacility extends Equatable {
  const NearbyFacility({
    required this.name,
    required this.distance,
    required this.type,
  });

  final String name;
  final String distance;
  final String type;

  @override
  List<Object> get props => [name, distance, type];
}

class AwarenessContent extends Equatable {
  const AwarenessContent({required this.title, required this.message});

  final String title;
  final String message;

  @override
  List<Object> get props => [title, message];
}

class HomeSummary extends Equatable {
  const HomeSummary({
    required this.activeRequests,
    required this.nearbyFacilities,
    required this.awareness,
  });

  final List<HomeRequest> activeRequests;
  final List<NearbyFacility> nearbyFacilities;
  final AwarenessContent awareness;

  @override
  List<Object> get props => [activeRequests, nearbyFacilities, awareness];
}
