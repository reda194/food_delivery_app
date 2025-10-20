import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/settings_entity.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

/// App Settings Screen - Complete settings management
/// Provides access to all app configuration options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load settings when screen opens
    context.read<SettingsBloc>().add(const LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        } else if (state is SettingsResetSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        SettingsEntity? settings;
        bool isLoading = false;

        if (state is SettingsLoading) {
          isLoading = true;
        } else if (state is SettingsLoaded) {
          settings = state.settings;
        } else if (state is SettingsUpdating) {
          settings = state.settings;
          isLoading = true;
        } else if (state is SettingsUpdateSuccess) {
          settings = state.settings;
        } else if (state is SettingsResetSuccess) {
          settings = state.settings;
        } else if (state is SettingsError && state.settings != null) {
          settings = state.settings;
        }

        final isDarkMode = settings?.darkMode ?? false;

        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, isDarkMode),

                // Settings Content
                Expanded(
                  child: isLoading && settings == null
                      ? const Center(child: CircularProgressIndicator())
                      : _buildSettingsContent(context, settings!, isLoading),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
          ),

          const Spacer(),

          // Title
          Text(
            'App Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black,
              letterSpacing: -0.5,
            ),
          ),

          const Spacer(),

          // Reset Button
          GestureDetector(
            onTap: () => _showResetDialog(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.refresh,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(
      BuildContext context, SettingsEntity settings, bool isLoading) {
    final isDarkMode = settings.darkMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications Section
          _buildSectionTitle('Notifications', isDarkMode),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Push Notifications',
            value: settings.pushNotifications,
            onChanged: isLoading
                ? null
                : (value) => context
                    .read<SettingsBloc>()
                    .add(UpdatePushNotificationsEvent(enabled: value)),
            isDarkMode: isDarkMode,
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            value: settings.emailNotifications,
            onChanged: isLoading
                ? null
                : (value) => context
                    .read<SettingsBloc>()
                    .add(UpdateEmailNotificationsEvent(enabled: value)),
            isDarkMode: isDarkMode,
          ),
          _buildSwitchTile(
            title: 'SMS Notifications',
            value: settings.smsNotifications,
            onChanged: isLoading
                ? null
                : (value) => context
                    .read<SettingsBloc>()
                    .add(UpdateSmsNotificationsEvent(enabled: value)),
            isDarkMode: isDarkMode,
          ),
          _buildSwitchTile(
            title: 'Order Updates',
            value: settings.orderUpdates,
            onChanged: isLoading
                ? null
                : (value) => context.read<SettingsBloc>().add(
                      ToggleSettingEvent(settingKey: 'orderUpdates'),
                    ),
            isDarkMode: isDarkMode,
          ),
          _buildSwitchTile(
            title: 'Promotional Emails',
            value: settings.promotionalEmails,
            onChanged: isLoading
                ? null
                : (value) => context.read<SettingsBloc>().add(
                      ToggleSettingEvent(settingKey: 'promotionalEmails'),
                    ),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 32),

          // Appearance Section
          _buildSectionTitle('Appearance', isDarkMode),
          const SizedBox(height: 16),
          _buildThemeToggle(context, settings, isLoading),

          const SizedBox(height: 32),

          // Preferences Section
          _buildSectionTitle('Preferences', isDarkMode),
          const SizedBox(height: 16),
          _buildLanguageSelector(context, settings, isLoading, isDarkMode),
          const SizedBox(height: 8),
          _buildCurrencySelector(context, settings, isLoading, isDarkMode),

          const SizedBox(height: 32),

          // Audio & Haptics Section
          _buildSectionTitle('Audio & Haptics', isDarkMode),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Sound Effects',
            value: settings.soundEffects,
            onChanged: isLoading
                ? null
                : (value) => context.read<SettingsBloc>().add(
                      ToggleSettingEvent(settingKey: 'soundEffects'),
                    ),
            isDarkMode: isDarkMode,
          ),
          _buildSwitchTile(
            title: 'Vibration',
            value: settings.vibration,
            onChanged: isLoading
                ? null
                : (value) => context.read<SettingsBloc>().add(
                      ToggleSettingEvent(settingKey: 'vibration'),
                    ),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 32),

          // Privacy Section
          _buildSectionTitle('Privacy & Permissions', isDarkMode),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Location Services',
            value: settings.locationServices,
            onChanged: isLoading
                ? null
                : (value) => context.read<SettingsBloc>().add(
                      ToggleSettingEvent(settingKey: 'locationServices'),
                    ),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 32),

          // Media Section
          _buildSectionTitle('Media', isDarkMode),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Auto-Play Videos',
            value: settings.autoPlayVideos,
            onChanged: isLoading
                ? null
                : (value) => context.read<SettingsBloc>().add(
                      ToggleSettingEvent(settingKey: 'autoPlayVideos'),
                    ),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildDataUsageSelector(context, settings, isLoading, isDarkMode),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDarkMode ? Colors.white : Colors.black,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required void Function(bool)? onChanged,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.white.withAlpha(25)
                : Colors.grey.withAlpha(25),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFFFFC529),
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(
      BuildContext context, SettingsEntity settings, bool isLoading) {
    final isDarkMode = settings.darkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Light Mode Button
          GestureDetector(
            onTap: isLoading || !isDarkMode
                ? null
                : () => context
                    .read<SettingsBloc>()
                    .add(const UpdateDarkModeEvent(enabled: false)),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: !isDarkMode
                    ? const Color(0xFFFFF8E7)
                    : (isDarkMode
                        ? const Color(0xFF2A2A2A)
                        : Colors.grey[200]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wb_sunny_outlined,
                color: !isDarkMode
                    ? Colors.black
                    : (isDarkMode ? Colors.grey[600] : Colors.grey),
                size: 32,
              ),
            ),
          ),

          const SizedBox(width: 32),

          // Dark Mode Button
          GestureDetector(
            onTap: isLoading || isDarkMode
                ? null
                : () => context
                    .read<SettingsBloc>()
                    .add(const UpdateDarkModeEvent(enabled: true)),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color:
                    isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[200],
                shape: BoxShape.circle,
                border: isDarkMode
                    ? Border.all(color: Colors.white24, width: 1)
                    : null,
              ),
              child: Icon(
                Icons.nightlight_outlined,
                color: isDarkMode ? Colors.white : Colors.grey,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsEntity settings,
      bool isLoading, bool isDarkMode) {
    return InkWell(
      onTap: isLoading
          ? null
          : () => _showLanguageDialog(context, settings.language),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? Colors.white.withAlpha(25)
                  : Colors.grey.withAlpha(25),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Language',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  settings.language,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector(BuildContext context, SettingsEntity settings,
      bool isLoading, bool isDarkMode) {
    return InkWell(
      onTap: isLoading
          ? null
          : () => _showCurrencyDialog(context, settings.currency),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? Colors.white.withAlpha(25)
                  : Colors.grey.withAlpha(25),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Currency',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  settings.currency,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataUsageSelector(BuildContext context, SettingsEntity settings,
      bool isLoading, bool isDarkMode) {
    return InkWell(
      onTap: isLoading
          ? null
          : () => _showDataUsageDialog(context, settings.dataUsage),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDarkMode
                  ? Colors.white.withAlpha(25)
                  : Colors.grey.withAlpha(25),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Data Usage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  settings.dataUsage.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Arabic'];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context
                      .read<SettingsBloc>()
                      .add(UpdateLanguageEvent(language: value));
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, String currentCurrency) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CNY', 'AED'];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((curr) {
            return RadioListTile<String>(
              title: Text(curr),
              value: curr,
              groupValue: currentCurrency,
              onChanged: (value) {
                if (value != null) {
                  context
                      .read<SettingsBloc>()
                      .add(UpdateCurrencyEvent(currency: value));
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDataUsageDialog(BuildContext context, DataUsage currentUsage) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Data Usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DataUsage.values.map((usage) {
            return RadioListTile<DataUsage>(
              title: Text(usage.displayName),
              value: usage,
              groupValue: currentUsage,
              onChanged: (value) {
                if (value != null) {
                  context
                      .read<SettingsBloc>()
                      .add(UpdateDataUsageEvent(dataUsage: value));
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to default?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SettingsBloc>().add(const ResetSettingsEvent());
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
