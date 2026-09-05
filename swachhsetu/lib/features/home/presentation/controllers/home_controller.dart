import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/result.dart';
import '../../../../services/location/location_service.dart';
import '../../data/demo_home_repository.dart';
import '../../data/home_repository.dart';
import '../../domain/home_summary.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => const DemoHomeRepository(),
);
final locationServiceProvider = Provider<LocationService>(
  (ref) => const DemoLocationService(),
);

final homeSummaryProvider = FutureProvider<HomeSummary>((ref) async {
  final result = await ref.watch(homeRepositoryProvider).getSummary();
  return switch (result) {
    Success(value: final summary) => summary,
    FailureResult(failure: final failure) => throw failure,
  };
});

final homeLocationProvider = FutureProvider<String?>((ref) async {
  return ref.watch(locationServiceProvider).currentLocationLabel();
});
