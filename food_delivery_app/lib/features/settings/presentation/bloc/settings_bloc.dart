import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/reset_settings_usecase.dart';
import '../../domain/usecases/toggle_setting_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;
  final ResetSettingsUseCase resetSettingsUseCase;
  final ToggleSettingUseCase toggleSettingUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
    required this.resetSettingsUseCase,
    required this.toggleSettingUseCase,
  }) : super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateAllSettingsEvent>(_onUpdateAllSettings);
    on<ToggleSettingEvent>(_onToggleSetting);
    on<UpdatePushNotificationsEvent>(_onUpdatePushNotifications);
    on<UpdateEmailNotificationsEvent>(_onUpdateEmailNotifications);
    on<UpdateSmsNotificationsEvent>(_onUpdateSmsNotifications);
    on<UpdateDarkModeEvent>(_onUpdateDarkMode);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateCurrencyEvent>(_onUpdateCurrency);
    on<UpdateDataUsageEvent>(_onUpdateDataUsage);
    on<ResetSettingsEvent>(_onResetSettings);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await getSettingsUseCase(const NoParams());

    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateAllSettings(
    UpdateAllSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    emit(SettingsUpdating(
      settings: currentSettings,
      message: 'Updating settings...',
    ));

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: event.settings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsUpdateSuccess(
        settings: settings,
        message: 'Settings updated successfully',
      )),
    );
  }

  Future<void> _onToggleSetting(
    ToggleSettingEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final result = await toggleSettingUseCase(
      ToggleSettingParams(key: event.settingKey),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdatePushNotifications(
    UpdatePushNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final updatedSettings = currentSettings.copyWith(
      pushNotifications: event.enabled,
    );

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateEmailNotifications(
    UpdateEmailNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final updatedSettings = currentSettings.copyWith(
      emailNotifications: event.enabled,
    );

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateSmsNotifications(
    UpdateSmsNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final updatedSettings = currentSettings.copyWith(
      smsNotifications: event.enabled,
    );

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateDarkMode(
    UpdateDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final updatedSettings = currentSettings.copyWith(
      darkMode: event.enabled,
    );

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final updatedSettings = currentSettings.copyWith(
      language: event.language,
    );

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsUpdateSuccess(
        settings: settings,
        message: 'Language updated to ${event.language}',
      )),
    );
  }

  Future<void> _onUpdateCurrency(
    UpdateCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final updatedSettings = currentSettings.copyWith(
      currency: event.currency,
    );

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsUpdateSuccess(
        settings: settings,
        message: 'Currency updated to ${event.currency}',
      )),
    );
  }

  Future<void> _onUpdateDataUsage(
    UpdateDataUsageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    final updatedSettings = currentSettings.copyWith(
      dataUsage: event.dataUsage,
    );

    final result = await updateSettingsUseCase(
      UpdateSettingsParams(settings: updatedSettings),
    );

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsUpdateSuccess(
        settings: settings,
        message: 'Data usage updated to ${event.dataUsage.displayName}',
      )),
    );
  }

  Future<void> _onResetSettings(
    ResetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = _getCurrentSettings(currentState);

    emit(SettingsUpdating(
      settings: currentSettings,
      message: 'Resetting settings...',
    ));

    final result = await resetSettingsUseCase(const NoParams());

    result.fold(
      (failure) => emit(SettingsError(
        message: failure.message,
        settings: currentSettings,
      )),
      (settings) => emit(SettingsResetSuccess(
        settings: settings,
        message: 'Settings reset to default',
      )),
    );
  }

  /// Helper method to get current settings from state
  SettingsEntity _getCurrentSettings(SettingsState state) {
    if (state is SettingsLoaded) return state.settings;
    if (state is SettingsUpdating) return state.settings;
    if (state is SettingsUpdateSuccess) return state.settings;
    if (state is SettingsResetSuccess) return state.settings;
    if (state is SettingsError && state.settings != null) {
      return state.settings!;
    }

    // Return default settings if none available
    return SettingsEntity.defaultSettings();
  }
}
