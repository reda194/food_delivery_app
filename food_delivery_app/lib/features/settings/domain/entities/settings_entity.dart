import 'package:equatable/equatable.dart';

/// Data usage options for the app
enum DataUsage {
  wifiOnly,
  mobileData,
  any;

  String get displayName {
    switch (this) {
      case DataUsage.wifiOnly:
        return 'Wi-Fi Only';
      case DataUsage.mobileData:
        return 'Mobile Data';
      case DataUsage.any:
        return 'Wi-Fi & Mobile Data';
    }
  }

  static DataUsage fromString(String value) {
    switch (value.toLowerCase()) {
      case 'wifi-only':
      case 'wifionly':
        return DataUsage.wifiOnly;
      case 'mobile-data':
      case 'mobiledata':
        return DataUsage.mobileData;
      case 'any':
      default:
        return DataUsage.any;
    }
  }

  String toJson() {
    switch (this) {
      case DataUsage.wifiOnly:
        return 'wifi-only';
      case DataUsage.mobileData:
        return 'mobile-data';
      case DataUsage.any:
        return 'any';
    }
  }
}

/// App Settings Entity
class SettingsEntity extends Equatable {
  // Notification Settings
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool orderUpdates;
  final bool promotionalEmails;

  // App Preferences
  final String language;
  final String currency;
  final bool darkMode;

  // Audio & Haptics
  final bool soundEffects;
  final bool vibration;

  // Privacy & Permissions
  final bool locationServices;

  // Media Settings
  final bool autoPlayVideos;
  final DataUsage dataUsage;

  const SettingsEntity({
    // Notification Settings
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.orderUpdates = true,
    this.promotionalEmails = false,
    // App Preferences
    this.language = 'English',
    this.currency = 'USD',
    this.darkMode = false,
    // Audio & Haptics
    this.soundEffects = true,
    this.vibration = true,
    // Privacy & Permissions
    this.locationServices = true,
    // Media Settings
    this.autoPlayVideos = false,
    this.dataUsage = DataUsage.any,
  });

  /// Default settings
  factory SettingsEntity.defaultSettings() {
    return const SettingsEntity();
  }

  /// Copy with method for easy updates
  SettingsEntity copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? orderUpdates,
    bool? promotionalEmails,
    String? language,
    String? currency,
    bool? darkMode,
    bool? soundEffects,
    bool? vibration,
    bool? locationServices,
    bool? autoPlayVideos,
    DataUsage? dataUsage,
  }) {
    return SettingsEntity(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotionalEmails: promotionalEmails ?? this.promotionalEmails,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      darkMode: darkMode ?? this.darkMode,
      soundEffects: soundEffects ?? this.soundEffects,
      vibration: vibration ?? this.vibration,
      locationServices: locationServices ?? this.locationServices,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      dataUsage: dataUsage ?? this.dataUsage,
    );
  }

  /// Check if all notifications are enabled
  bool get allNotificationsEnabled {
    return pushNotifications &&
        emailNotifications &&
        smsNotifications &&
        orderUpdates &&
        promotionalEmails;
  }

  /// Check if all notifications are disabled
  bool get allNotificationsDisabled {
    return !pushNotifications &&
        !emailNotifications &&
        !smsNotifications &&
        !orderUpdates &&
        !promotionalEmails;
  }

  @override
  List<Object?> get props => [
        pushNotifications,
        emailNotifications,
        smsNotifications,
        orderUpdates,
        promotionalEmails,
        language,
        currency,
        darkMode,
        soundEffects,
        vibration,
        locationServices,
        autoPlayVideos,
        dataUsage,
      ];
}
