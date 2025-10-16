import 'package:equatable/equatable.dart';

/// Address Entity - Represents a delivery address
class AddressEntity extends Equatable {
  final String id;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final String? instructions;

  const AddressEntity({
    required this.id,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.instructions,
  });

  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2,
      city,
      state,
      zipCode,
      country,
    ];
    return parts.join(', ');
  }

  String get shortAddress {
    return '$addressLine1, $city';
  }

  @override
  List<Object?> get props => [
        id,
        label,
        addressLine1,
        addressLine2,
        city,
        state,
        zipCode,
        country,
        latitude,
        longitude,
        isDefault,
        instructions,
      ];
}
