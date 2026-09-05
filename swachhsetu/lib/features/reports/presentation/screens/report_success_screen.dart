import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ReportSuccessScreen extends StatelessWidget {
  const ReportSuccessScreen({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.surfaceTint,
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 42,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Report Submitted',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your report #$reportId has been submitted for review.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Back to Home'),
                ),
                TextButton(
                  onPressed: () => context.push('/request-detail/$reportId'),
                  child: const Text('Track Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
