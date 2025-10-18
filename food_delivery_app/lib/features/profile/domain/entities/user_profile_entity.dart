import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime? dateOfBirth;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfileEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.profileImageUrl,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.dateOfBirth,
    this.emailVerified = false,
    this.phoneVerified = false,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullAddress {
    final parts = [
      address,
      city,
      state,
      zipCode,
      country,
    ].where((part) => part != null && part.isNotEmpty);

    return parts.join(', ');
  }

  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }

    final names = displayName!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }

    return displayName!.substring(0, 1).toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        phoneNumber,
        profileImageUrl,
        address,
        city,
        state,
        zipCode,
        country,
        dateOfBirth,
        emailVerified,
        phoneVerified,
        createdAt,
        updatedAt,
      ];
}
