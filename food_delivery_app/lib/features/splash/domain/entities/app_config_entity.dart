import 'package:equatable/equatable.dart';

/// App Configuration Entity
/// Represents app initialization configuration
class AppConfigEntity extends Equatable {
  final String appVersion;
  final bool onboardingComplete;
  final bool isAuthenticated;
  final String? userId;
  final bool maintenanceMode;
  final bool forceUpdate;
  final String? latestVersion;
  final Map<String, dynamic>? settings;

  const AppConfigEntity({
    required this.appVersion,
    required this.onboardingComplete,
    required this.isAuthenticated,
    this.userId,
    this.maintenanceMode = false,
    this.forceUpdate = false,
    this.latestVersion,
    this.settings,
  });

  @override
  List<Object?> get props => [
        appVersion,
        onboardingComplete,
        isAuthenticated,
        userId,
        maintenanceMode,
        forceUpdate,
        latestVersion,
        settings,
      ];

  /// Check if app needs update
  bool get needsUpdate => forceUpdate && latestVersion != appVersion;

  @override
  String toString() {
    return 'AppConfigEntity(version: $appVersion, onboarded: $onboardingComplete, '
        'authenticated: $isAuthenticated, userId: $userId)';
  }

  AppConfigEntity copyWith({
    String? appVersion,
    bool? onboardingComplete,
    bool? isAuthenticated,
    String? userId,
    bool? maintenanceMode,
    bool? forceUpdate,
    String? latestVersion,
    Map<String, dynamic>? settings,
  }) {
    return AppConfigEntity(
      appVersion: appVersion ?? this.appVersion,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      forceUpdate: forceUpdate ?? this.forceUpdate,
      latestVersion: latestVersion ?? this.latestVersion,
      settings: settings ?? this.settings,
    );
  }
}
