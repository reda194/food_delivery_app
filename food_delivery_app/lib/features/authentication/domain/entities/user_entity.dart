import 'package:equatable/equatable.dart';

/// User Entity - Domain layer representation
/// This is the core business object that doesn't depend on any framework
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImage,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        profileImage,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name)';
  }
}
