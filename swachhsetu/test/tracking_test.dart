import 'package:flutter_test/flutter_test.dart';
import 'package:swachhsetu/features/tracking/domain/tracking.dart';

void main() {
  test('report and pickup timelines contain expected status sequences', () {
    final report = [
      TrackingStatus.submitted,
      TrackingStatus.underReview,
      TrackingStatus.assigned,
      TrackingStatus.inProgress,
      TrackingStatus.resolved,
    ];
    final pickup = [
      TrackingStatus.requested,
      TrackingStatus.accepted,
      TrackingStatus.assigned,
      TrackingStatus.onTheWay,
      TrackingStatus.collected,
      TrackingStatus.completed,
    ];
    expect(report.first, TrackingStatus.submitted);
    expect(report.last, TrackingStatus.resolved);
    expect(pickup.first, TrackingStatus.requested);
    expect(pickup.last, TrackingStatus.completed);
  });
}
