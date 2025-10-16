/// Mock user profile data for food delivery app
class MockUser {
  static final Map<String, dynamic> currentUser = {
    'id': 'user_123',
    'email': 'john.doe@example.com',
    'firstName': 'John',
    'lastName': 'Doe',
    'fullName': 'John Doe',
    'phone': '+1 (555) 123-4567',
    'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    'dateOfBirth': '1990-05-15',
    'gender': 'male',
    'emailVerified': true,
    'phoneVerified': true,
    'createdAt': '2024-01-01T00:00:00Z',
    'updatedAt': '2024-01-15T10:30:00Z',
    'preferences': {
      'language': 'en',
      'currency': 'USD',
      'notifications': {
        'orderUpdates': true,
        'promotions': true,
        'newsletter': false,
        'pushNotifications': true,
      },
      'dietary': {
        'vegetarian': false,
        'vegan': false,
        'glutenFree': false,
        'allergies': <String>[],
      },
    },
    'stats': {
      'totalOrders': 47,
      'totalSpent': 1247.89,
      'favoriteRestaurants': 8,
      'reviewsWritten': 12,
    },
  };

  /// Get user display name
  static String getDisplayName() {
    return currentUser['fullName'] as String;
  }

  /// Get user initials for avatar
  static String getInitials() {
    final firstName = currentUser['firstName'] as String;
    final lastName = currentUser['lastName'] as String;
    return '${firstName[0]}${lastName[0]}'.toUpperCase();
  }

  /// Update user profile
  static Map<String, dynamic> updateProfile(Map<String, dynamic> updates) {
    currentUser.addAll({
      ...updates,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    return Map<String, dynamic>.from(currentUser);
  }

  /// Update preferences
  static void updatePreferences(Map<String, dynamic> preferences) {
    currentUser['preferences'] = {
      ...currentUser['preferences'] as Map,
      ...preferences,
    };
    currentUser['updatedAt'] = DateTime.now().toIso8601String();
  }

  /// Update notification settings
  static void updateNotificationSettings(Map<String, bool> settings) {
    final prefs = currentUser['preferences'] as Map<String, dynamic>;
    prefs['notifications'] = {
      ...prefs['notifications'] as Map,
      ...settings,
    };
    currentUser['updatedAt'] = DateTime.now().toIso8601String();
  }

  /// Check if email is verified
  static bool isEmailVerified() {
    return currentUser['emailVerified'] as bool;
  }

  /// Check if phone is verified
  static bool isPhoneVerified() {
    return currentUser['phoneVerified'] as bool;
  }
}
