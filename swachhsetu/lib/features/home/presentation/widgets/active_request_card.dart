import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/home_summary.dart';
import 'status_badge.dart';

class ActiveRequestCard extends StatelessWidget {
  const ActiveRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  final HomeRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(
                  request.kind == RequestKind.report
                      ? Icons.report_problem_outlined
                      : Icons.local_shipping_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.typeLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${request.id}  •  ${request.createdLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      request.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusBadge(status: request.status),
            ],
          ),
        ),
      ),
    );
  }
}
