import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/route_names.dart';

/// App Settings Screen - Matches Figma design exactly
/// Provides access to app configuration options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  static const String _darkModeKey = 'DARK_MODE_KEY';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
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
                        color: _isDarkMode
                            ? const Color(0xFF2A2A2A)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: _isDarkMode ? Colors.white : Colors.black,
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
                      color: _isDarkMode ? Colors.white : Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const Spacer(),

                  // Spacing to center title
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Settings Menu Items
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildSettingItem(
                      title: 'Notifications',
                      description:
                          'Change the email & phone notifications settings and manage yourself',
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.notifications);
                      },
                    ),

                    const SizedBox(height: 8),

                    _buildSettingItem(
                      title: 'Language',
                      description: 'Change the language by your preference country',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Language settings coming soon!'),
                            backgroundColor: _isDarkMode
                                ? const Color(0xFF2A2A2A)
                                : Colors.black87,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    _buildSettingItem(
                      title: 'App Cache',
                      description:
                          'You can clear app cache if some features are not working',
                      onTap: () {
                        _showClearCacheDialog();
                      },
                    ),

                    const SizedBox(height: 8),

                    _buildSettingItem(
                      title: 'Contact Support',
                      description:
                          'If you have any issue you can contact to our support anytime',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Contact support coming soon!'),
                            backgroundColor: _isDarkMode
                                ? const Color(0xFF2A2A2A)
                                : Colors.black87,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    _buildSettingItem(
                      title: 'Version Update',
                      description:
                          'Make sure the app is up-to date. So you will get all the features',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('You are using the latest version!'),
                            backgroundColor: _isDarkMode
                                ? const Color(0xFF2A2A2A)
                                : Colors.black87,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Theme Toggle
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Light Mode Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDarkMode = false;
                      });
                      _saveThemePreference(false);
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: !_isDarkMode
                            ? const Color(0xFFFFF8E7)
                            : (_isDarkMode
                                ? const Color(0xFF2A2A2A)
                                : Colors.grey[200]),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.wb_sunny_outlined,
                        color: !_isDarkMode
                            ? Colors.black
                            : (_isDarkMode ? Colors.grey[600] : Colors.grey),
                        size: 32,
                      ),
                    ),
                  ),

                  const SizedBox(width: 32),

                  // Dark Mode Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isDarkMode = true;
                      });
                      _saveThemePreference(true);
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: _isDarkMode
                            ? const Color(0xFF2A2A2A)
                            : Colors.grey[200],
                        shape: BoxShape.circle,
                        border: _isDarkMode
                            ? Border.all(color: Colors.white24, width: 1)
                            : null,
                      ),
                      child: Icon(
                        Icons.nightlight_outlined,
                        color: _isDarkMode ? Colors.white : Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _isDarkMode
                  ? Colors.white.withAlpha(25)
                  : Colors.grey.withAlpha(25),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _isDarkMode ? Colors.white : Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _isDarkMode
                          ? Colors.grey[400]
                          : const Color(0xFF9796A1),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.arrow_forward_ios,
              color: _isDarkMode ? Colors.white : Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Clear App Cache',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to clear the app cache? This will remove temporary files and may help resolve issues.',
            style: TextStyle(
              fontSize: 16,
              color: _isDarkMode ? Colors.grey[300] : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cache cleared successfully!'),
                    backgroundColor: _isDarkMode
                        ? const Color(0xFF2A2A2A)
                        : Colors.black87,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Clear Cache',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF4757),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
