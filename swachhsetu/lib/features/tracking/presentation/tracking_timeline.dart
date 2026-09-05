import 'package:flutter/material.dart';
import '../domain/tracking.dart';

class TrackingTimeline extends StatelessWidget {
  const TrackingTimeline({super.key, required this.events});
  final List<TrackingEvent> events;
  @override
  Widget build(BuildContext context) => Column(
    children: events.asMap().entries.map((entry) {
      final event = entry.value;
      return ListTile(
        leading: CircleAvatar(
          child: Icon(
            entry.key == events.length - 1 ? Icons.check : Icons.circle,
            size: 14,
          ),
        ),
        title: Text(event.status.name),
        subtitle: Text('${event.description}\n${event.timestamp}'),
      );
    }).toList(),
  );
}
