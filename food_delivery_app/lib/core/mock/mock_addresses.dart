/// Mock addresses data for food delivery app
class MockAddresses {
  static final List<Map<String, dynamic>> addresses = [
    {
      'id': 'addr_1',
      'userId': 'user_123',
      'label': 'Home',
      'recipientName': 'John Doe',
      'recipientPhone': '+1 (555) 123-4567',
      'street': '123 Main Street',
      'apartment': 'Apt 4B',
      'city': 'San Francisco',
      'state': 'California',
      'zipCode': '94102',
      'country': 'USA',
      'latitude': 37.7749,
      'longitude': -122.4194,
      'deliveryInstructions': 'Ring the doorbell. If no answer, leave at the door.',
      'isDefault': true,
      'createdAt': '2024-01-01T10:00:00Z',
      'updatedAt': '2024-01-01T10:00:00Z',
    },
    {
      'id': 'addr_2',
      'userId': 'user_123',
      'label': 'Office',
      'recipientName': 'John Doe',
      'recipientPhone': '+1 (555) 123-4567',
      'street': '456 Tech Street',
      'apartment': 'Suite 200',
      'city': 'San Francisco',
      'state': 'California',
      'zipCode': '94105',
      'country': 'USA',
      'latitude': 37.7891,
      'longitude': -122.4012,
      'deliveryInstructions': 'Call when you arrive at the lobby.',
      'isDefault': false,
      'createdAt': '2024-01-05T14:30:00Z',
      'updatedAt': '2024-01-05T14:30:00Z',
    },
    {
      'id': 'addr_3',
      'userId': 'user_123',
      'label': 'Mom\'s House',
      'recipientName': 'Jane Doe',
      'recipientPhone': '+1 (555) 987-6543',
      'street': '789 Oak Avenue',
      'apartment': '',
      'city': 'Berkeley',
      'state': 'California',
      'zipCode': '94704',
      'country': 'USA',
      'latitude': 37.8715,
      'longitude': -122.2730,
      'deliveryInstructions': 'Use the side entrance.',
      'isDefault': false,
      'createdAt': '2024-01-10T09:15:00Z',
      'updatedAt': '2024-01-10T09:15:00Z',
    },
  ];

  /// Get default address
  static Map<String, dynamic>? getDefaultAddress() {
    try {
      return addresses.firstWhere((addr) => addr['isDefault'] == true);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  /// Get address by ID
  static Map<String, dynamic>? getAddressById(String addressId) {
    try {
      return addresses.firstWhere((addr) => addr['id'] == addressId);
    } catch (e) {
      return null;
    }
  }

  /// Add new address
  static Map<String, dynamic> addAddress(Map<String, dynamic> addressData) {
    final newAddress = {
      'id': 'addr_${DateTime.now().millisecondsSinceEpoch}',
      'userId': 'user_123',
      ...addressData,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
    addresses.add(newAddress);
    return newAddress;
  }

  /// Update address
  static Map<String, dynamic>? updateAddress(
      String addressId, Map<String, dynamic> updates) {
    try {
      final index = addresses.indexWhere((addr) => addr['id'] == addressId);
      if (index != -1) {
        addresses[index] = {
          ...addresses[index],
          ...updates,
          'updatedAt': DateTime.now().toIso8601String(),
        };
        return addresses[index];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Delete address
  static bool deleteAddress(String addressId) {
    try {
      addresses.removeWhere((addr) => addr['id'] == addressId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Set default address
  static bool setDefaultAddress(String addressId) {
    try {
      for (var addr in addresses) {
        addr['isDefault'] = addr['id'] == addressId;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
