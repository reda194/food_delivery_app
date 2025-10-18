import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifications Screen - Matches Figma design exactly
/// Allows users to manage SMS and Email notification preferences
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _smsNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;

  static const String _smsNotificationsKey = 'SMS_NOTIFICATIONS_KEY';
  static const String _emailNotificationsKey = 'EMAIL_NOTIFICATIONS_KEY';

  @override
  void initState() {
    super.initState();
    _loadNotificationPreferences();
  }

  Future<void> _loadNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _smsNotificationsEnabled = prefs.getBool(_smsNotificationsKey) ?? true;
      _emailNotificationsEnabled = prefs.getBool(_emailNotificationsKey) ?? false;
    });
  }

  Future<void> _saveSmsNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smsNotificationsKey, value);
  }

  Future<void> _saveEmailNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailNotificationsKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Title
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
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

            // Notification Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // SMS Notifications
                  _buildNotificationToggle(
                    title: 'SMS Notifications',
                    description:
                        'Change the email & phone notifications settings and manage yourself',
                    isEnabled: _smsNotificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _smsNotificationsEnabled = value;
                      });
                      _saveSmsNotificationPreference(value);
                    },
                  ),

                  const SizedBox(height: 8),

                  // Email Notifications
                  _buildNotificationToggle(
                    title: 'Email Notifications',
                    description:
                        'Change the email & phone notifications settings and manage yourself',
                    isEnabled: _emailNotificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _emailNotificationsEnabled = value;
                      });
                      _saveEmailNotificationPreference(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String description,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withAlpha(25),
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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9796A1),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Custom Toggle Switch
          GestureDetector(
            onTap: () => onChanged(!isEnabled),
            child: Container(
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                color: isEnabled ? const Color(0xFF4CAF50) : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(2),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
