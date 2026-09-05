import 'package:equatable/equatable.dart';

enum TrackingStatus {
  submitted,
  underReview,
  assigned,
  inProgress,
  resolved,
  requested,
  accepted,
  onTheWay,
  collected,
  completed,
}

class TrackingEvent extends Equatable {
  const TrackingEvent({
    required this.status,
    required this.description,
    required this.timestamp,
  });
  final TrackingStatus status;
  final String description;
  final DateTime timestamp;
  @override
  List<Object> get props => [status, description, timestamp];
}
