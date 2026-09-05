import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';

class PickupSuccessScreen extends StatelessWidget {
  const PickupSuccessScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 72),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Pickup Requested',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Your pickup PK-$id is now requested.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to Home'),
              ),
              TextButton(
                onPressed: () => context.push('/pickup-tracking/$id'),
                child: const Text('Track Pickup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
