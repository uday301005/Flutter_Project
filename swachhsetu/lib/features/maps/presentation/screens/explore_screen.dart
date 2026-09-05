import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../services/maps/map_models.dart';
import '../controllers/explore_controller.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  bool _mapView = false;
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final facilities = ref.watch(exploreFacilitiesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Facilities'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(exploreFacilitiesProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: facilities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorState(
          message: 'We could not load nearby facilities.',
          onRetry: () => ref.invalidate(exploreFacilitiesProvider),
        ),
        data: (items) {
          final filtered = _filter == 'All'
              ? items
              : items
                    .where((item) => item.supportedWasteTypes.contains(_filter))
                    .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      label: Text('List'),
                      icon: Icon(Icons.list),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text('Map'),
                      icon: Icon(Icons.map_outlined),
                    ),
                  ],
                  selected: {_mapView},
                  onSelectionChanged: (value) =>
                      setState(() => _mapView = value.first),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: ['All', 'Wet', 'Dry', 'Plastic', 'E-Waste', 'Mixed']
                      .map(
                        (value) => Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: ChoiceChip(
                            label: Text(value),
                            selected: _filter == value,
                            onSelected: (_) => setState(() => _filter = value),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: _mapView
                    ? _DemoMap(items: filtered)
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) =>
                            _FacilityCard(marker: filtered[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DemoMap extends StatelessWidget {
  const _DemoMap({required this.items});
  final List<MapMarkerData> items;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surfaceTint,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Stack(
      children: [
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined, size: 64, color: AppColors.primary),
              SizedBox(height: 8),
              Text('Demo map view'),
              Text('Google Maps activates after API key setup'),
            ],
          ),
        ),
        ...items.asMap().entries.map(
          (entry) => Positioned(
            top: 40.0 + entry.key * 72,
            left: 24.0 + entry.key * 30,
            child: const Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ),
      ],
    ),
  );
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.marker});
  final MapMarkerData marker;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: CircleAvatar(
        child: Icon(
          marker.type == 'Bin'
              ? Icons.delete_outline
              : Icons.recycling_outlined,
        ),
      ),
      title: Text(marker.name),
      subtitle: Text(
        '${marker.type}  •  ${marker.distance}\n${marker.address ?? 'Location available'}',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}
