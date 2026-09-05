import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:swachhsetu/features/onboarding/data/onboarding_storage.dart';
import 'package:swachhsetu/features/onboarding/presentation/controllers/onboarding_controller.dart';

class FakeOnboardingStorage implements OnboardingStorage {
  FakeOnboardingStorage({this.completed = false});

  bool completed;

  @override
  Future<bool> hasCompletedOnboarding() async => completed;

  @override
  Future<void> markCompleted() async {
    completed = true;
  }
}

void main() {
  test('onboarding starts incomplete', () async {
    final storage = FakeOnboardingStorage();
    final container = ProviderContainer(
      overrides: [
        onboardingStorageProvider.overrideWith((ref) async => storage),
      ],
    );
    addTearDown(container.dispose);

    expect(await container.read(onboardingControllerProvider.future), isFalse);
  });

  test('completion is persisted and exposed by the controller', () async {
    final storage = FakeOnboardingStorage();
    final container = ProviderContainer(
      overrides: [
        onboardingStorageProvider.overrideWith((ref) async => storage),
      ],
    );
    addTearDown(container.dispose);

    await container.read(onboardingControllerProvider.future);
    await container
        .read(onboardingControllerProvider.notifier)
        .completeOnboarding();

    expect(storage.completed, isTrue);
    expect(container.read(onboardingControllerProvider).value, isTrue);
  });
}
