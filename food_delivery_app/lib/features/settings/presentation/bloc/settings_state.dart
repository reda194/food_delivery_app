import 'package:equatable/equatable.dart';
import '../../domain/entities/settings_entity.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading settings
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Settings loaded successfully
class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;

  const SettingsLoaded({required this.settings});

  @override
  List<Object?> get props => [settings];
}

/// Settings updating (show loading but keep data)
class SettingsUpdating extends SettingsState {
  final SettingsEntity settings;
  final String message;

  const SettingsUpdating({
    required this.settings,
    required this.message,
  });

  @override
  List<Object?> get props => [settings, message];
}

/// Settings updated successfully
class SettingsUpdateSuccess extends SettingsState {
  final SettingsEntity settings;
  final String message;

  const SettingsUpdateSuccess({
    required this.settings,
    required this.message,
  });

  @override
  List<Object?> get props => [settings, message];
}

/// Settings reset to default
class SettingsResetSuccess extends SettingsState {
  final SettingsEntity settings;
  final String message;

  const SettingsResetSuccess({
    required this.settings,
    required this.message,
  });

  @override
  List<Object?> get props => [settings, message];
}

/// Settings error
class SettingsError extends SettingsState {
  final String message;
  final SettingsEntity? settings;

  const SettingsError({
    required this.message,
    this.settings,
  });

  @override
  List<Object?> get props => [message, settings];
}
