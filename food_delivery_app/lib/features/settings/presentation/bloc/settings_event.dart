import 'package:equatable/equatable.dart';
import '../../domain/entities/settings_entity.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load settings from storage
class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

/// Update all settings
class UpdateAllSettingsEvent extends SettingsEvent {
  final SettingsEntity settings;

  const UpdateAllSettingsEvent({required this.settings});

  @override
  List<Object?> get props => [settings];
}

/// Toggle a specific boolean setting
class ToggleSettingEvent extends SettingsEvent {
  final String settingKey;

  const ToggleSettingEvent({required this.settingKey});

  @override
  List<Object?> get props => [settingKey];
}

/// Update push notifications
class UpdatePushNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const UpdatePushNotificationsEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Update email notifications
class UpdateEmailNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const UpdateEmailNotificationsEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Update SMS notifications
class UpdateSmsNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const UpdateSmsNotificationsEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Update dark mode
class UpdateDarkModeEvent extends SettingsEvent {
  final bool enabled;

  const UpdateDarkModeEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Update language
class UpdateLanguageEvent extends SettingsEvent {
  final String language;

  const UpdateLanguageEvent({required this.language});

  @override
  List<Object?> get props => [language];
}

/// Update currency
class UpdateCurrencyEvent extends SettingsEvent {
  final String currency;

  const UpdateCurrencyEvent({required this.currency});

  @override
  List<Object?> get props => [currency];
}

/// Update data usage
class UpdateDataUsageEvent extends SettingsEvent {
  final DataUsage dataUsage;

  const UpdateDataUsageEvent({required this.dataUsage});

  @override
  List<Object?> get props => [dataUsage];
}

/// Reset all settings to default
class ResetSettingsEvent extends SettingsEvent {
  const ResetSettingsEvent();
}
