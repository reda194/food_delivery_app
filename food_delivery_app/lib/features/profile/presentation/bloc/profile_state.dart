import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading profile
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Profile loaded successfully
class ProfileLoaded extends ProfileState {
  final UserProfileEntity profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Updating profile (show loading indicator but keep existing data)
class ProfileUpdating extends ProfileState {
  final UserProfileEntity profile;
  final String message;

  const ProfileUpdating({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

/// Profile update success
class ProfileUpdateSuccess extends ProfileState {
  final UserProfileEntity profile;
  final String message;

  const ProfileUpdateSuccess({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

/// Image uploading
class ProfileImageUploading extends ProfileState {
  final UserProfileEntity profile;

  const ProfileImageUploading({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Image uploaded successfully
class ProfileImageUploadSuccess extends ProfileState {
  final UserProfileEntity profile;
  final String imageUrl;

  const ProfileImageUploadSuccess({
    required this.profile,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [profile, imageUrl];
}

/// Password changing
class PasswordChanging extends ProfileState {
  final UserProfileEntity profile;

  const PasswordChanging({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Password changed successfully
class PasswordChangeSuccess extends ProfileState {
  final UserProfileEntity profile;
  final String message;

  const PasswordChangeSuccess({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

/// Email verification sent
class EmailVerificationSent extends ProfileState {
  final UserProfileEntity profile;
  final String message;

  const EmailVerificationSent({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

/// Email verified successfully
class EmailVerified extends ProfileState {
  final UserProfileEntity profile;
  final String message;

  const EmailVerified({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

/// Phone verification sent
class PhoneVerificationSent extends ProfileState {
  final UserProfileEntity profile;
  final String message;

  const PhoneVerificationSent({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

/// Phone verified successfully
class PhoneVerified extends ProfileState {
  final UserProfileEntity profile;
  final String message;

  const PhoneVerified({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

/// Account deleting
class AccountDeleting extends ProfileState {
  final UserProfileEntity profile;

  const AccountDeleting({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Account deleted successfully
class AccountDeleted extends ProfileState {
  final String message;

  const AccountDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Logging out
class LoggingOut extends ProfileState {
  final UserProfileEntity profile;

  const LoggingOut({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Logged out successfully
class LoggedOut extends ProfileState {
  const LoggedOut();
}

/// Profile error
class ProfileError extends ProfileState {
  final String message;
  final UserProfileEntity? profile;

  const ProfileError({
    required this.message,
    this.profile,
  });

  @override
  List<Object?> get props => [message, profile];
}
