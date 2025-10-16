import 'package:equatable/equatable.dart';

/// Payment Method Entity - Represents a payment method
class PaymentMethodEntity extends Equatable {
  final String id;
  final String type; // card, cash, wallet
  final String name;
  final String? cardNumber; // last 4 digits
  final String? cardBrand; // visa, mastercard, etc.
  final String? expiryDate;
  final bool isDefault;

  const PaymentMethodEntity({
    required this.id,
    required this.type,
    required this.name,
    this.cardNumber,
    this.cardBrand,
    this.expiryDate,
    this.isDefault = false,
  });

  String get displayName {
    if (type == 'card' && cardBrand != null && cardNumber != null) {
      return '$cardBrand •••• $cardNumber';
    }
    return name;
  }

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        cardNumber,
        cardBrand,
        expiryDate,
        isDefault,
      ];
}
