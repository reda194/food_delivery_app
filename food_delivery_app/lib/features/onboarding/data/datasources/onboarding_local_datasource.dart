import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for onboarding persistence
abstract class OnboardingLocalDataSource {
  /// Check if onboarding has been completed
  Future<bool> isOnboardingComplete();

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete();

  /// Save user preferences from onboarding
  Future<void> saveOnboardingPreferences(Map<String, dynamic> preferences);

  /// Get saved onboarding preferences
  Future<Map<String, dynamic>?> getOnboardingPreferences();

  /// Reset onboarding (for testing/debug)
  Future<void> resetOnboarding();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyUserPreferences = 'onboarding_preferences';

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isOnboardingComplete() async {
    return sharedPreferences.getBool(_keyOnboardingComplete) ?? false;
  }

  @override
  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(_keyOnboardingComplete, true);
  }

  @override
  Future<void> saveOnboardingPreferences(Map<String, dynamic> preferences) async {
    // Save individual preferences
    for (final entry in preferences.entries) {
      final key = '${_keyUserPreferences}_${entry.key}';
      final value = entry.value;

      if (value is String) {
        await sharedPreferences.setString(key, value);
      } else if (value is bool) {
        await sharedPreferences.setBool(key, value);
      } else if (value is int) {
        await sharedPreferences.setInt(key, value);
      } else if (value is double) {
        await sharedPreferences.setDouble(key, value);
      } else if (value is List<String>) {
        await sharedPreferences.setStringList(key, value);
      }
    }
  }

  @override
  Future<Map<String, dynamic>?> getOnboardingPreferences() async {
    final keys = sharedPreferences.getKeys();
    final preferences = <String, dynamic>{};

    for (final key in keys) {
      if (key.startsWith(_keyUserPreferences)) {
        final prefKey = key.replaceFirst('${_keyUserPreferences}_', '');
        final value = sharedPreferences.get(key);
        if (value != null) {
          preferences[prefKey] = value;
        }
      }
    }

    return preferences.isEmpty ? null : preferences;
  }

  @override
  Future<void> resetOnboarding() async {
    await sharedPreferences.remove(_keyOnboardingComplete);

    // Remove all preference keys
    final keys = sharedPreferences.getKeys().where(
      (key) => key.startsWith(_keyUserPreferences),
    ).toList();

    for (final key in keys) {
      await sharedPreferences.remove(key);
    }
  }
}
