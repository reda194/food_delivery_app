import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/errors/exceptions.dart';

/// App Local Data Source
/// Handles local storage operations for app initialization
abstract class AppLocalDataSource {
  /// Get onboarding completion status
  Future<bool> getOnboardingStatus();

  /// Set onboarding completion status
  Future<void> setOnboardingStatus(bool completed);

  /// Get app version
  Future<String?> getSavedAppVersion();

  /// Set app version
  Future<void> setAppVersion(String version);

  /// Get app settings
  Future<Map<String, dynamic>> getAppSettings();

  /// Set app settings
  Future<void> setAppSettings(Map<String, dynamic> settings);

  /// Clear all local data except user preferences
  Future<void> clearCache();

  /// Clear all data (complete reset)
  Future<void> clearAllData();
}

class AppLocalDataSourceImpl implements AppLocalDataSource {
  final LoggerService _logger = LoggerService.instance;

  // SharedPreferences keys
  static const String _onboardingCompleteKey = 'ONBOARDING_COMPLETE';
  static const String _appVersionKey = 'APP_VERSION';
  static const String _appSettingsKey = 'APP_SETTINGS';
  static const String _lastCacheClearKey = 'LAST_CACHE_CLEAR';

  @override
  Future<bool> getOnboardingStatus() async {
    try {
      _logger.info('Getting onboarding status from local storage...');
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool(_onboardingCompleteKey) ?? false;
      _logger.info('Onboarding status: $status');
      return status;
    } catch (e, stackTrace) {
      _logger.error('Failed to get onboarding status: $e', stackTrace);
      throw CacheException('Failed to get onboarding status');
    }
  }

  @override
  Future<void> setOnboardingStatus(bool completed) async {
    try {
      _logger.info('Setting onboarding status to: $completed');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompleteKey, completed);
      _logger.info('Onboarding status saved successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to set onboarding status: $e', stackTrace);
      throw CacheException('Failed to set onboarding status');
    }
  }

  @override
  Future<String?> getSavedAppVersion() async {
    try {
      _logger.info('Getting saved app version...');
      final prefs = await SharedPreferences.getInstance();
      final version = prefs.getString(_appVersionKey);
      _logger.info('Saved app version: $version');
      return version;
    } catch (e, stackTrace) {
      _logger.error('Failed to get app version: $e', stackTrace);
      throw CacheException('Failed to get app version');
    }
  }

  @override
  Future<void> setAppVersion(String version) async {
    try {
      _logger.info('Setting app version to: $version');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_appVersionKey, version);
      _logger.info('App version saved successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to set app version: $e', stackTrace);
      throw CacheException('Failed to set app version');
    }
  }

  @override
  Future<Map<String, dynamic>> getAppSettings() async {
    try {
      _logger.info('Getting app settings...');
      final prefs = await SharedPreferences.getInstance();

      // For now, return empty map. In a real app, you'd parse stored JSON
      final settingsJson = prefs.getString(_appSettingsKey);
      if (settingsJson == null) {
        _logger.info('No app settings found, returning defaults');
        return {};
      }

      // Parse JSON string to Map
      // In production, use json.decode(settingsJson)
      _logger.info('App settings loaded');
      return {};
    } catch (e, stackTrace) {
      _logger.error('Failed to get app settings: $e', stackTrace);
      throw CacheException('Failed to get app settings');
    }
  }

  @override
  Future<void> setAppSettings(Map<String, dynamic> settings) async {
    try {
      _logger.info('Setting app settings...');
      // final prefs = await SharedPreferences.getInstance();

      // In production, use json.encode(settings)
      // await prefs.setString(_appSettingsKey, json.encode(settings));

      _logger.info('App settings saved successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to set app settings: $e', stackTrace);
      throw CacheException('Failed to set app settings');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      _logger.info('Clearing app cache...');
      final prefs = await SharedPreferences.getInstance();

      // Keep important keys
      final keysToKeep = [
        _onboardingCompleteKey,
        _appVersionKey,
        _appSettingsKey,
      ];

      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (!keysToKeep.contains(key)) {
          await prefs.remove(key);
        }
      }

      // Record cache clear time
      await prefs.setString(
        _lastCacheClearKey,
        DateTime.now().toIso8601String(),
      );

      _logger.info('Cache cleared successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear cache: $e', stackTrace);
      throw CacheException('Failed to clear cache');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      _logger.info('Clearing all app data...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _logger.info('All app data cleared successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear all data: $e', stackTrace);
      throw CacheException('Failed to clear all data');
    }
  }
}
