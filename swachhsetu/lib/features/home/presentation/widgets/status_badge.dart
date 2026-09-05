import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/home_summary.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      RequestStatus.submitted => (AppColors.secondary, 'Submitted'),
      RequestStatus.underReview => (AppColors.accent, 'Under Review'),
      RequestStatus.assigned => (AppColors.secondary, 'Assigned'),
      RequestStatus.inProgress => (AppColors.primary, 'In Progress'),
      RequestStatus.resolved => (AppColors.primary, 'Resolved'),
      RequestStatus.completed => (AppColors.primaryDark, 'Completed'),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
