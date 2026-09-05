import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingStorage {
  Future<bool> hasCompletedOnboarding();

  Future<void> markCompleted();
}

class SharedPreferencesOnboardingStorage implements OnboardingStorage {
  SharedPreferencesOnboardingStorage(this._preferences);

  static const completionKey = 'hasCompletedOnboarding';

  final SharedPreferences _preferences;

  @override
  Future<bool> hasCompletedOnboarding() async {
    return _preferences.getBool(completionKey) ?? false;
  }

  @override
  Future<void> markCompleted() async {
    await _preferences.setBool(completionKey, true);
  }
}
