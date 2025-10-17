import 'package:flutter/material.dart';
import '../../../../core/routes/route_names.dart';

/// Profile Menu Screen - Matches Figma design exactly
/// Shows user profile and menu options
class ProfileMenuScreen extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? userImage;

  const ProfileMenuScreen({
    super.key,
    this.userName,
    this.userEmail,
    this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Profile Info
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: userImage != null
                        ? ClipOval(
                            child: Image.network(
                              userImage!,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: Colors.grey[600],
                                  size: 40,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 40,
                          ),
                  ),

                  const SizedBox(width: 16),

                  // Name and Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? 'Adom Shafi',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail ?? 'adomshafi007@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Menu Items
            _buildMenuItem(
              context,
              title: 'Edit Profile',
              onTap: () {
                Navigator.pushNamed(context, RouteNames.editProfile);
              },
            ),

            _buildMenuItem(
              context,
              title: 'Saved Food',
              onTap: () {
                Navigator.pushNamed(context, RouteNames.favorites);
              },
            ),

            _buildMenuItem(
              context,
              title: 'App Settings',
              onTap: () {
                Navigator.pushNamed(context, RouteNames.settings);
              },
            ),

            _buildMenuItem(
              context,
              title: 'Delivery History',
              onTap: () {
                Navigator.pushNamed(context, RouteNames.orders);
              },
            ),

            _buildMenuItem(
              context,
              title: 'Terms & Conditions',
              onTap: () {
                // Navigate to terms and conditions
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms & Conditions screen coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            const Spacer(),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFF4757),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
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
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close menu
                // Navigate to login
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.login,
                  (route) => false,
                );
              },
              child: const Text(
                'Log Out',
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
