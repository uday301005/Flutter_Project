import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../../domain/home_summary.dart';
import '../widgets/active_request_card.dart';
import '../widgets/facility_list_tile.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/quick_action_card.dart';

class AuthenticatedShell extends StatelessWidget {
  const AuthenticatedShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: HomeBottomNavigation(
        navigationShell: navigationShell,
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(homeSummaryProvider);
    final user = ref.watch(authControllerProvider).value?.user;
    final location = ref.watch(homeLocationProvider);
    final greetingName = user?.name.trim();
    final greeting = greetingName == null || greetingName.isEmpty
        ? 'Hello there'
        : 'Good day, $greetingName';

    return Scaffold(
      body: SafeArea(
        child: summary.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ErrorState(
            message: 'We could not load your dashboard.',
            onRetry: () => ref.invalidate(homeSummaryProvider),
          ),
          data: (data) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(homeSummaryProvider),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _HomeHeader(
                      greeting: greeting,
                      onNotifications: () => context.go('/notifications'),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _LocationRow(location: location),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(title: 'What would you like to do?'),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.crossAxisExtent >= 600
                          ? 4
                          : 2;
                      return SliverGrid.builder(
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          mainAxisExtent: columns == 4 ? 176 : 188,
                        ),
                        itemBuilder: (context, index) =>
                            _quickAction(context, index),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Active Requests',
                      action: TextButton(
                        onPressed: () => context.go('/requests'),
                        child: const Text('View all'),
                      ),
                    ),
                  ),
                ),
                if (data.activeRequests.isEmpty)
                  const SliverToBoxAdapter(child: _HomeEmptyRequests())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    sliver: SliverList.separated(
                      itemCount: data.activeRequests.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) => ActiveRequestCard(
                        request: data.activeRequests[index],
                        onTap: () => context.push(
                          '/request-detail/${data.activeRequests[index].id.substring(1)}',
                        ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SectionHeader(title: 'Nearby Facilities'),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Column(
                          children: data.nearbyFacilities
                              .map(
                                (facility) => FacilityListTile(
                                  facility: facility,
                                  onTap: () => context.go('/explore'),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _AwarenessCard(content: data.awareness),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickAction(BuildContext context, int index) {
    final actions = [
      (
        title: 'Report Waste',
        description: 'Report garbage or sanitation issues',
        icon: Icons.report_problem_outlined,
        color: AppColors.danger,
        path: '/report',
      ),
      (
        title: 'Scan Waste',
        description: 'Identify waste and dispose responsibly',
        icon: Icons.document_scanner_outlined,
        color: AppColors.secondary,
        path: '/scan',
      ),
      (
        title: 'Request Pickup',
        description: 'Schedule waste collection',
        icon: Icons.local_shipping_outlined,
        color: AppColors.primary,
        path: '/pickup',
      ),
      (
        title: 'Nearby Bins',
        description: 'Find nearby waste facilities',
        icon: Icons.location_on_outlined,
        color: AppColors.accent,
        path: '/maps',
      ),
    ];
    final action = actions[index];
    return QuickActionCard(
      title: action.title,
      description: action.description,
      icon: action.icon,
      color: action.color,
      onTap: () => action.path == '/maps'
          ? context.go('/explore')
          : context.push(action.path),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.greeting, required this.onNotifications});

  final String greeting;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.surfaceTint,
          child: Icon(Icons.person_outline, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                'Let us keep your community clean.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: onNotifications,
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.location});

  final AsyncValue<String?> location;

  @override
  Widget build(BuildContext context) {
    final label = location.valueOrNull ?? 'Location unavailable';
    return Row(
      children: [
        const Icon(
          Icons.my_location_outlined,
          size: 18,
          color: AppColors.secondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _HomeEmptyRequests extends StatelessWidget {
  const _HomeEmptyRequests();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const Text('No active requests'),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => context.push('/report'),
                child: const Text('Report a Problem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AwarenessCard extends StatelessWidget {
  const _AwarenessCard({required this.content});

  final AwarenessContent content;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            const Icon(Icons.eco_outlined, color: Colors.white, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    content.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(220),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => context.push('/guide'),
                      child: const Text(
                        'Learn More',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
