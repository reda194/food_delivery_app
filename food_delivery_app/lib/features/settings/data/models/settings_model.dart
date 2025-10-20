import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.pushNotifications,
    required super.emailNotifications,
    required super.smsNotifications,
    required super.orderUpdates,
    required super.promotionalEmails,
    required super.language,
    required super.currency,
    required super.darkMode,
    required super.soundEffects,
    required super.vibration,
    required super.locationServices,
    required super.autoPlayVideos,
    required super.dataUsage,
  });

  /// Create from JSON map (SharedPreferences)
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      orderUpdates: json['orderUpdates'] as bool? ?? true,
      promotionalEmails: json['promotionalEmails'] as bool? ?? false,
      language: json['language'] as String? ?? 'English',
      currency: json['currency'] as String? ?? 'USD',
      darkMode: json['darkMode'] as bool? ?? false,
      soundEffects: json['soundEffects'] as bool? ?? true,
      vibration: json['vibration'] as bool? ?? true,
      locationServices: json['locationServices'] as bool? ?? true,
      autoPlayVideos: json['autoPlayVideos'] as bool? ?? false,
      dataUsage: DataUsage.fromString(
        json['dataUsage'] as String? ?? 'any',
      ),
    );
  }

  /// Convert to JSON map for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'orderUpdates': orderUpdates,
      'promotionalEmails': promotionalEmails,
      'language': language,
      'currency': currency,
      'darkMode': darkMode,
      'soundEffects': soundEffects,
      'vibration': vibration,
      'locationServices': locationServices,
      'autoPlayVideos': autoPlayVideos,
      'dataUsage': dataUsage.toJson(),
    };
  }

  /// Create default settings model
  factory SettingsModel.defaultSettings() {
    return const SettingsModel(
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: false,
      orderUpdates: true,
      promotionalEmails: false,
      language: 'English',
      currency: 'USD',
      darkMode: false,
      soundEffects: true,
      vibration: true,
      locationServices: true,
      autoPlayVideos: false,
      dataUsage: DataUsage.any,
    );
  }

  /// Create from entity
  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      pushNotifications: entity.pushNotifications,
      emailNotifications: entity.emailNotifications,
      smsNotifications: entity.smsNotifications,
      orderUpdates: entity.orderUpdates,
      promotionalEmails: entity.promotionalEmails,
      language: entity.language,
      currency: entity.currency,
      darkMode: entity.darkMode,
      soundEffects: entity.soundEffects,
      vibration: entity.vibration,
      locationServices: entity.locationServices,
      autoPlayVideos: entity.autoPlayVideos,
      dataUsage: entity.dataUsage,
    );
  }

  /// Copy with method
  @override
  SettingsModel copyWith({
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
    return SettingsModel(
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
}
