import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

/// Edit Profile Screen - Matches Figma design exactly
/// Allows users to edit their profile information
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _countryController;

  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  UserProfileEntity? _currentProfile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _countryController = TextEditingController();

    // Load profile when screen opens
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _updateControllersFromProfile(UserProfileEntity profile) {
    _currentProfile = profile;
    _nameController.text = profile.displayName ?? '';
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber ?? '';
    _addressController.text = profile.address ?? '';
    _cityController.text = profile.city ?? '';
    _stateController.text = profile.state ?? '';
    _zipCodeController.text = profile.zipCode ?? '';
    _countryController.text = profile.country ?? '';
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null && mounted) {
        // Upload image using ProfileBloc
        context.read<ProfileBloc>().add(
              UploadProfileImageEvent(imagePath: image.path),
            );
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveChanges() {
    // Validate inputs
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update profile using ProfileBloc
    context.read<ProfileBloc>().add(
          UpdateProfileEvent(
            displayName: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isNotEmpty
                ? _phoneController.text.trim()
                : null,
            address: _addressController.text.trim().isNotEmpty
                ? _addressController.text.trim()
                : null,
            city: _cityController.text.trim().isNotEmpty
                ? _cityController.text.trim()
                : null,
            state: _stateController.text.trim().isNotEmpty
                ? _stateController.text.trim()
                : null,
            zipCode: _zipCodeController.text.trim().isNotEmpty
                ? _zipCodeController.text.trim()
                : null,
            country: _countryController.text.trim().isNotEmpty
                ? _countryController.text.trim()
                : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded ||
              state is ProfileUpdateSuccess ||
              state is ProfileImageUploadSuccess) {
            // Update controllers when profile is loaded
            final profile = state is ProfileLoaded
                ? state.profile
                : state is ProfileUpdateSuccess
                    ? state.profile
                    : (state as ProfileImageUploadSuccess).profile;

            if (_currentProfile == null) {
              _updateControllersFromProfile(profile);
            }
          }

          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back after successful update
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.pop(context);
              }
            });
          } else if (state is ProfileImageUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile image uploaded successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading ||
              state is ProfileUpdating ||
              state is ProfileImageUploading;

          UserProfileEntity? profile;
          if (state is ProfileLoaded) {
            profile = state.profile;
          } else if (state is ProfileUpdateSuccess) {
            profile = state.profile;
          } else if (state is ProfileUpdating) {
            profile = state.profile;
          } else if (state is ProfileImageUploading) {
            profile = state.profile;
          } else if (state is ProfileImageUploadSuccess) {
            profile = state.profile;
          } else if (state is ProfileError && state.profile != null) {
            profile = state.profile;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Profile Image with Edit Badge
                  Stack(
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: ClipOval(
                          child: _buildProfileImage(profile),
                        ),
                      ),

                      // Edit Icon Badge
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: isLoading ? null : _pickImage,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // User Name Display
                  Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : (profile?.displayName ?? 'Loading...'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // User Email Display
                  Text(
                    _emailController.text.isNotEmpty
                        ? _emailController.text
                        : (profile?.email ?? ''),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Name Input Field
                  _buildInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 24),

                  // Phone Input Field
                  _buildInputField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    enabled: !isLoading,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  // Address Input Field
                  _buildInputField(
                    controller: _addressController,
                    label: 'Address',
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 24),

                  // City Input Field
                  _buildInputField(
                    controller: _cityController,
                    label: 'City',
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 60),

                  // Save Change Button
                  SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF8E7),
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey[300],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : const Text(
                              'Save Change',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(UserProfileEntity? profile) {
    // Show local image if selected
    if (_selectedImagePath != null) {
      return Image.file(
        File(_selectedImagePath!),
        fit: BoxFit.cover,
        width: 180,
        height: 180,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: 80,
            color: Colors.grey[600],
          );
        },
      );
    }

    // Show profile image from server
    if (profile?.profileImageUrl != null) {
      return Image.network(
        profile!.profileImageUrl!,
        fit: BoxFit.cover,
        width: 180,
        height: 180,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: 80,
            color: Colors.grey[600],
          );
        },
      );
    }

    // Default avatar
    return Icon(
      Icons.person,
      size: 80,
      color: Colors.grey[600],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFF5F5F5) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: label,
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[400],
          ),
        ),
        onChanged: (value) {
          setState(() {}); // Update display text
        },
      ),
    );
  }
}
