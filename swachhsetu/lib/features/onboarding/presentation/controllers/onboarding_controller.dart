import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/onboarding_storage.dart';

final onboardingStorageProvider = FutureProvider<OnboardingStorage>((
  ref,
) async {
  final preferences = await SharedPreferences.getInstance();
  return SharedPreferencesOnboardingStorage(preferences);
});

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, bool>(OnboardingController.new);

class OnboardingController extends AsyncNotifier<bool> {
  OnboardingStorage? _storage;

  @override
  Future<bool> build() async {
    _storage = await ref.watch(onboardingStorageProvider.future);
    return _storage!.hasCompletedOnboarding();
  }

  Future<void> completeOnboarding() async {
    final storage =
        _storage ?? await ref.read(onboardingStorageProvider.future);
    await storage!.markCompleted();
    _storage = storage;
    state = const AsyncData(true);
  }
}
