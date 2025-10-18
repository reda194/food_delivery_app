import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load user profile
class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

/// Update profile information
class UpdateProfileEvent extends ProfileEvent {
  final String? displayName;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime? dateOfBirth;

  const UpdateProfileEvent({
    this.displayName,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [
        displayName,
        phoneNumber,
        address,
        city,
        state,
        zipCode,
        country,
        dateOfBirth,
      ];
}

/// Upload profile image
class UploadProfileImageEvent extends ProfileEvent {
  final String imagePath;

  const UploadProfileImageEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// Change password
class ChangePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Send email verification
class SendEmailVerificationEvent extends ProfileEvent {
  const SendEmailVerificationEvent();
}

/// Verify email with OTP code
class VerifyEmailEvent extends ProfileEvent {
  final String code;

  const VerifyEmailEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

/// Send phone verification
class SendPhoneVerificationEvent extends ProfileEvent {
  final String phoneNumber;

  const SendPhoneVerificationEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// Verify phone with OTP code
class VerifyPhoneEvent extends ProfileEvent {
  final String code;

  const VerifyPhoneEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

/// Delete account
class DeleteAccountEvent extends ProfileEvent {
  final String password;

  const DeleteAccountEvent({required this.password});

  @override
  List<Object?> get props => [password];
}

/// Logout
class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}

/// Refresh profile data
class RefreshProfileEvent extends ProfileEvent {
  const RefreshProfileEvent();
}
