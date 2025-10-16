import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/address_model.dart';
import '../models/payment_method_model.dart';
import '../models/order_model.dart';

/// Checkout Remote Data Source - Abstract interface
abstract class CheckoutRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<PaymentMethodModel> addPaymentMethod(PaymentMethodModel paymentMethod);
  Future<void> deletePaymentMethod(String paymentMethodId);
  Future<double> calculateDeliveryFee({
    required String restaurantId,
    required String addressId,
  });
  Future<OrderModel> placeOrder({
    required String restaurantId,
    required List<dynamic> items,
    required String addressId,
    required String paymentMethodId,
    String? promoCode,
    String? specialInstructions,
  });
}

/// Checkout Remote Data Source Implementation
class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ApiClient apiClient;

  CheckoutRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await apiClient.get(ApiConstants.addresses);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['addresses'] ?? [];
        return data.map((json) => AddressModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load addresses');
    } catch (e) {
      throw Exception('Error fetching addresses: $e');
    }
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      final response = await apiClient.post(
        ApiConstants.addAddress,
        data: address.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AddressModel.fromJson(response.data['address']);
      }

      throw Exception('Failed to add address');
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    try {
      final response = await apiClient.put(
        ApiConstants.replacePathParameter(
          ApiConstants.updateAddress,
          'id',
          address.id,
        ),
        data: address.toJson(),
      );

      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['address']);
      }

      throw Exception('Failed to update address');
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      final response = await apiClient.delete(
        ApiConstants.replacePathParameter(
          ApiConstants.deleteAddress,
          'id',
          addressId,
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete address');
      }
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.replacePathParameter(
          ApiConstants.setDefaultAddress,
          'id',
          addressId,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to set default address');
      }
    } catch (e) {
      throw Exception('Error setting default address: $e');
    }
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await apiClient.get(ApiConstants.paymentMethods);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['paymentMethods'] ?? [];
        return data.map((json) => PaymentMethodModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load payment methods');
    } catch (e) {
      throw Exception('Error fetching payment methods: $e');
    }
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod(
    PaymentMethodModel paymentMethod,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.addPaymentMethod,
        data: paymentMethod.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentMethodModel.fromJson(response.data['paymentMethod']);
      }

      throw Exception('Failed to add payment method');
    } catch (e) {
      throw Exception('Error adding payment method: $e');
    }
  }

  @override
  Future<void> deletePaymentMethod(String paymentMethodId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.replacePathParameter(
          ApiConstants.removePaymentMethod,
          'id',
          paymentMethodId,
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete payment method');
      }
    } catch (e) {
      throw Exception('Error deleting payment method: $e');
    }
  }

  @override
  Future<double> calculateDeliveryFee({
    required String restaurantId,
    required String addressId,
  }) async {
    try {
      final response = await apiClient.post(
        '/delivery/calculate-fee',
        data: {
          'restaurantId': restaurantId,
          'addressId': addressId,
        },
      );

      if (response.statusCode == 200) {
        return (response.data['deliveryFee'] as num).toDouble();
      }

      throw Exception('Failed to calculate delivery fee');
    } catch (e) {
      throw Exception('Error calculating delivery fee: $e');
    }
  }

  @override
  Future<OrderModel> placeOrder({
    required String restaurantId,
    required List<dynamic> items,
    required String addressId,
    required String paymentMethodId,
    String? promoCode,
    String? specialInstructions,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.createOrder,
        data: {
          'restaurantId': restaurantId,
          'items': items,
          'addressId': addressId,
          'paymentMethodId': paymentMethodId,
          if (promoCode != null) 'promoCode': promoCode,
          if (specialInstructions != null)
            'specialInstructions': specialInstructions,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderModel.fromJson(response.data['order']);
      }

      throw Exception('Failed to place order');
    } catch (e) {
      throw Exception('Error placing order: $e');
    }
  }
}
