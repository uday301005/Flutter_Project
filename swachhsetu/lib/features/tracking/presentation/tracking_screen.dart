import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import 'tracking_timeline.dart';
import '../domain/tracking.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key, required this.id, required this.pickup});
  final String id;
  final bool pickup;
  @override
  Widget build(BuildContext context) {
    final statuses = pickup
        ? [
            TrackingStatus.requested,
            TrackingStatus.accepted,
            TrackingStatus.assigned,
            TrackingStatus.onTheWay,
            TrackingStatus.collected,
            TrackingStatus.completed,
          ]
        : [
            TrackingStatus.submitted,
            TrackingStatus.underReview,
            TrackingStatus.assigned,
            TrackingStatus.inProgress,
            TrackingStatus.resolved,
          ];
    final events = statuses
        .asMap()
        .entries
        .map(
          (entry) => TrackingEvent(
            status: entry.value,
            description: entry.key == statuses.length - 1
                ? 'Current status'
                : 'Status update recorded',
            timestamp: DateTime.now().subtract(
              Duration(days: statuses.length - entry.key),
            ),
          ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(pickup ? 'Track Pickup' : 'Track Report')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('#$id', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          TrackingTimeline(events: events),
        ],
      ),
    );
  }
}
