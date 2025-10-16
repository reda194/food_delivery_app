import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Authentication States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading State
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated State (User logged in)
class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated State (User not logged in)
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Error State
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Password Reset Email Sent State
class PasswordResetEmailSent extends AuthState {
  final String email;

  const PasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

/// OTP Verified State
class OtpVerified extends AuthState {
  const OtpVerified();
}
