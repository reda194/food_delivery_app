import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_names.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

/// Profile Menu Screen - Matches Figma design exactly
/// Shows user profile and menu options
class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile when screen opens
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LoggedOut) {
            // Navigate to login screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.login,
              (route) => false,
            );
          } else if (state is ProfileError && state.profile == null) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          UserProfileEntity? profile;
          bool isLoading = false;

          if (state is ProfileLoading) {
            isLoading = true;
          } else if (state is ProfileLoaded) {
            profile = state.profile;
          } else if (state is ProfileUpdateSuccess) {
            profile = state.profile;
          } else if (state is LoggingOut) {
            profile = state.profile;
            isLoading = true;
          } else if (state is ProfileError && state.profile != null) {
            profile = state.profile;
          }

          return SafeArea(
            child: Column(
              children: [
                // Header with Profile Info
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      // Profile Avatar
                      _buildProfileAvatar(profile, isLoading),

                      const SizedBox(width: 16),

                      // Name and Email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.displayName ?? 'Loading...',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile?.email ?? '',
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
                      onPressed: isLoading
                          ? null
                          : () {
                              _showLogoutDialog(context);
                            },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFFF4757),
                        backgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.grey,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF4757),
                                ),
                              ),
                            )
                          : const Text(
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
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(UserProfileEntity? profile, bool isLoading) {
    if (isLoading && profile == null) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[300],
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.grey[300],
      child: profile?.profileImageUrl != null
          ? ClipOval(
              child: Image.network(
                profile!.profileImageUrl!,
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
      builder: (BuildContext dialogContext) {
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
              onPressed: () => Navigator.pop(dialogContext),
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
                Navigator.pop(dialogContext); // Close dialog
                // Trigger logout event
                context.read<ProfileBloc>().add(const LogoutEvent());
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
