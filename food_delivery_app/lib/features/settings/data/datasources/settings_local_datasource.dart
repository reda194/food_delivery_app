import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  /// Get settings from local storage
  Future<SettingsModel> getSettings();

  /// Save settings to local storage
  Future<void> saveSettings(SettingsModel settings);

  /// Clear all settings (reset to default)
  Future<void> clearSettings();

  /// Update a specific setting
  Future<SettingsModel> updateSetting(String key, dynamic value);

  /// Toggle a boolean setting
  Future<SettingsModel> toggleSetting(String key);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String settingsKey = 'app_settings';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final jsonString = sharedPreferences.getString(settingsKey);

      if (jsonString == null) {
        // Return default settings if none exist
        final defaultSettings = SettingsModel.defaultSettings();
        await saveSettings(defaultSettings);
        return defaultSettings;
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return SettingsModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException('Failed to get settings: ${e.toString()}');
    }
  }

  @override
  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final jsonString = json.encode(settings.toJson());
      await sharedPreferences.setString(settingsKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save settings: ${e.toString()}');
    }
  }

  @override
  Future<void> clearSettings() async {
    try {
      await sharedPreferences.remove(settingsKey);
    } catch (e) {
      throw CacheException('Failed to clear settings: ${e.toString()}');
    }
  }

  @override
  Future<SettingsModel> updateSetting(String key, dynamic value) async {
    try {
      final currentSettings = await getSettings();
      final jsonMap = currentSettings.toJson();

      // Update the specific key
      jsonMap[key] = value;

      final updatedSettings = SettingsModel.fromJson(jsonMap);
      await saveSettings(updatedSettings);

      return updatedSettings;
    } catch (e) {
      throw CacheException('Failed to update setting: ${e.toString()}');
    }
  }

  @override
  Future<SettingsModel> toggleSetting(String key) async {
    try {
      final currentSettings = await getSettings();
      final jsonMap = currentSettings.toJson();

      // Check if the key exists and is a boolean
      if (!jsonMap.containsKey(key)) {
        throw CacheException('Setting key not found: $key');
      }

      final currentValue = jsonMap[key];
      if (currentValue is! bool) {
        throw CacheException('Setting is not a boolean: $key');
      }

      // Toggle the value
      jsonMap[key] = !currentValue;

      final updatedSettings = SettingsModel.fromJson(jsonMap);
      await saveSettings(updatedSettings);

      return updatedSettings;
    } catch (e) {
      throw CacheException('Failed to toggle setting: ${e.toString()}');
    }
  }
}
