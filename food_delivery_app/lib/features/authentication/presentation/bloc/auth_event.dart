import 'package:equatable/equatable.dart';

/// Authentication Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Login Event
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register Event
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String? phoneNumber;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}

/// Logout Event
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Forgot Password Event
class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

/// Verify OTP Event
class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

/// Check Auth Status Event
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}
