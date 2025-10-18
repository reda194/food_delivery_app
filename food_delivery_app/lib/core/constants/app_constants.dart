/// Application Constants and Configuration
class AppConstants {
  AppConstants._();

  // ==================== APP INFO ====================
  static const String appName = 'Food Delivery';
  static const String appVersion = '1.0.0';
  
  // ==================== SUPABASE CONFIGURATION ====================
  /// TODO: Replace with your Supabase project URL
  static const String supabaseUrl = 'https://your-project-id.supabase.co';
  
  /// TODO: Replace with your Supabase anon key
  static const String supabaseAnonKey = 'your-anon-key-here';

  // ==================== DATABASE SCHEMA ====================
  static const String usersTable = 'users';
  static const String restaurantsTable = 'restaurants';
  static const String categoriesTable = 'categories';
  static const String menuItemsTable = 'menu_items';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String cartTable = 'cart';
  static const String cartItemsTable = 'cart_items';
  static const String addressesTable = 'addresses';
  static const String paymentMethodsTable = 'payment_methods';
  static const String reviewsTable = 'reviews';
  static const String favoritesTable = 'favorites';
  static const String notificationsTable = 'notifications';

  // ==================== STORAGE BUCKETS ====================
  static const String avatarsBucket = 'avatars';
  static const String restaurantsBucket = 'restaurants';
  static const String menuItemsBucket = 'menu-items';
  static const String documentsBucket = 'documents';

  // ==================== ENVIRONMENT ====================
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isDebugMode => environment == 'development';
  static bool get isProductionMode => environment == 'production';

  // ==================== API CONFIGURATION ====================
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // ==================== CACHE CONFIGURATION ====================
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration userCacheExpiration = Duration(minutes: 30);
  static const Duration menuCacheExpiration = Duration(minutes: 15);
  
  // ==================== PAGINATION ====================
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // ==================== VALIDATION ====================
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxUsernameLength = 50;
  static const int maxReviewLength = 500;
  
  // ==================== PAYMENT ====================
  static const double deliveryFee = 2.99;
  static const double taxRate = 0.08; // 8%
  static const Duration orderCancelWindow = Duration(minutes: 5);
  
  // ==================== RATING ====================
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double ratingStep = 0.5;
  
  // ==================== LOCATION ====================
  static const double defaultSearchRadius = 10.0; // km
  static const double maxSearchRadius = 50.0; // km
  
  // ==================== NOTIFICATIONS ====================
  static const Duration notificationRetention = Duration(days: 30);
  
  // ==================== SECURITY ====================
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  
  // ==================== FEATURE FLAGS ====================
  static const bool enableNotifications = true;
  static const bool enableLocationServices = true;
  static const bool enableSocialLogin = true;
  static const bool enableOfflineMode = false;
  
  // ==================== DEEP LINKING ====================
  static const String appScheme = 'fooddelivery';
  static const String webUrl = 'https://fooddelivery.example.com';
  
  // ==================== ERROR MESSAGE CONSTANTS ====================
  static const String defaultErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Our servers are experiencing issues. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please sign in again.';
  
  // ==================== SUCCESS MESSAGE CONSTANTS ====================
  static const String orderPlacedSuccessMessage = 'Order placed successfully!';
  static const String paymentSuccessMessage = 'Payment processed successfully!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String addressAddedSuccessMessage = 'Address added successfully!';
}
