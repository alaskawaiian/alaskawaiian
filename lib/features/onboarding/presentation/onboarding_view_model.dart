import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/shared_preferences/shared_preferences_database.dart';
import '../../../repositories/shared_preferences/shared_preferences_providers.dart';

// Provides access to [OnboardingViewModel].
final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, bool>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesDatabaseProvider);
  return OnboardingViewModel(sharedPreferencesService);
});

/// Stores the state of onboarding in [SharedPreferencesDatabase].
/// Once someone has seen that screen once, it is not shown again.
class OnboardingViewModel extends StateNotifier<bool> {
  OnboardingViewModel(this.sharedPreferencesService)
      : super(sharedPreferencesService.isOnboardingComplete());
  final SharedPreferencesDatabase sharedPreferencesService;

  Future<void> completeOnboarding() async {
    await sharedPreferencesService.setOnboardingComplete();
    state = true;
  }

  bool get isOnboardingComplete => state;
}
