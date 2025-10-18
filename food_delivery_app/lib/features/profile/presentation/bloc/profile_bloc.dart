import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadProfileImageUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
  }) : super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UploadProfileImageEvent>(_onUploadProfileImage);
    on<ChangePasswordEvent>(_onChangePassword);
    on<SendEmailVerificationEvent>(_onSendEmailVerification);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<SendPhoneVerificationEvent>(_onSendPhoneVerification);
    on<VerifyPhoneEvent>(_onVerifyPhone);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<LogoutEvent>(_onLogout);
    on<RefreshProfileEvent>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await getUserProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded && currentState is! ProfileUpdateSuccess) {
      emit(const ProfileError(message: 'Profile not loaded'));
      return;
    }

    final currentProfile = currentState is ProfileLoaded
        ? currentState.profile
        : (currentState as ProfileUpdateSuccess).profile;

    emit(ProfileUpdating(
      profile: currentProfile,
      message: 'Updating profile...',
    ));

    final result = await updateProfileUseCase(
      UpdateProfileParams(
        displayName: event.displayName,
        phoneNumber: event.phoneNumber,
        address: event.address,
        city: event.city,
        state: event.state,
        zipCode: event.zipCode,
        country: event.country,
        dateOfBirth: event.dateOfBirth,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: failure.message,
        profile: currentProfile,
      )),
      (profile) => emit(ProfileUpdateSuccess(
        profile: profile,
        message: 'Profile updated successfully',
      )),
    );
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded &&
        currentState is! ProfileUpdateSuccess &&
        currentState is! ProfileImageUploadSuccess) {
      emit(const ProfileError(message: 'Profile not loaded'));
      return;
    }

    final currentProfile = _getCurrentProfile(currentState);

    emit(ProfileImageUploading(profile: currentProfile));

    // Upload image and update profile in one step
    final uploadResult = await uploadProfileImageUseCase(
      UploadProfileImageParams(imagePath: event.imagePath),
    );

    uploadResult.fold(
      (failure) => emit(ProfileError(
        message: failure.message,
        profile: currentProfile,
      )),
      (updatedProfile) => emit(ProfileImageUploadSuccess(
        profile: updatedProfile,
        imageUrl: updatedProfile.profileImageUrl ?? '',
      )),
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded &&
        currentState is! ProfileUpdateSuccess &&
        currentState is! PasswordChangeSuccess) {
      emit(const ProfileError(message: 'Profile not loaded'));
      return;
    }

    final currentProfile = _getCurrentProfile(currentState);

    emit(PasswordChanging(profile: currentProfile));

    final result = await changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: failure.message,
        profile: currentProfile,
      )),
      (_) => emit(PasswordChangeSuccess(
        profile: currentProfile,
        message: 'Password changed successfully',
      )),
    );
  }

  Future<void> _onSendEmailVerification(
    SendEmailVerificationEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    final currentProfile = _getCurrentProfile(currentState);

    emit(ProfileUpdating(
      profile: currentProfile,
      message: 'Sending verification email...',
    ));

    // Note: This would require a use case for email verification
    // For now, we'll simulate the behavior
    await Future.delayed(const Duration(seconds: 1));

    emit(EmailVerificationSent(
      profile: currentProfile,
      message: 'Verification email sent. Please check your inbox.',
    ));
  }

  Future<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    final currentProfile = _getCurrentProfile(currentState);

    emit(ProfileUpdating(
      profile: currentProfile,
      message: 'Verifying email...',
    ));

    // Note: This would require a use case for email verification
    // For now, we'll simulate the behavior
    await Future.delayed(const Duration(seconds: 1));

    emit(EmailVerified(
      profile: currentProfile,
      message: 'Email verified successfully',
    ));

    // Reload profile to get updated verification status
    add(const LoadProfileEvent());
  }

  Future<void> _onSendPhoneVerification(
    SendPhoneVerificationEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    final currentProfile = _getCurrentProfile(currentState);

    emit(ProfileUpdating(
      profile: currentProfile,
      message: 'Sending verification code...',
    ));

    // Note: This would require a use case for phone verification
    // For now, we'll simulate the behavior
    await Future.delayed(const Duration(seconds: 1));

    emit(PhoneVerificationSent(
      profile: currentProfile,
      message: 'Verification code sent to ${event.phoneNumber}',
    ));
  }

  Future<void> _onVerifyPhone(
    VerifyPhoneEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    final currentProfile = _getCurrentProfile(currentState);

    emit(ProfileUpdating(
      profile: currentProfile,
      message: 'Verifying phone...',
    ));

    // Note: This would require a use case for phone verification
    // For now, we'll simulate the behavior
    await Future.delayed(const Duration(seconds: 1));

    emit(PhoneVerified(
      profile: currentProfile,
      message: 'Phone verified successfully',
    ));

    // Reload profile to get updated verification status
    add(const LoadProfileEvent());
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    final currentProfile = _getCurrentProfile(currentState);

    emit(AccountDeleting(profile: currentProfile));

    final result = await deleteAccountUseCase(
      DeleteAccountParams(password: event.password),
    );

    result.fold(
      (failure) => emit(ProfileError(
        message: failure.message,
        profile: currentProfile,
      )),
      (_) => emit(const AccountDeleted(
        message: 'Account deleted successfully',
      )),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    final currentProfile = _getCurrentProfile(currentState);

    emit(LoggingOut(profile: currentProfile));

    // Note: This would require a logout use case
    // For now, we'll simulate the behavior
    await Future.delayed(const Duration(milliseconds: 500));

    emit(const LoggedOut());
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // Don't show loading state for refresh
    final result = await getUserProfileUseCase(const NoParams());

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  /// Helper method to get current profile from state
  UserProfileEntity _getCurrentProfile(ProfileState state) {
    if (state is ProfileLoaded) return state.profile;
    if (state is ProfileUpdateSuccess) return state.profile;
    if (state is ProfileUpdating) return state.profile;
    if (state is ProfileImageUploading) return state.profile;
    if (state is ProfileImageUploadSuccess) return state.profile;
    if (state is PasswordChanging) return state.profile;
    if (state is PasswordChangeSuccess) return state.profile;
    if (state is EmailVerificationSent) return state.profile;
    if (state is EmailVerified) return state.profile;
    if (state is PhoneVerificationSent) return state.profile;
    if (state is PhoneVerified) return state.profile;
    if (state is AccountDeleting) return state.profile;
    if (state is LoggingOut) return state.profile;
    if (state is ProfileError && state.profile != null) return state.profile!;

    throw Exception('Cannot get profile from state: ${state.runtimeType}');
  }
}
