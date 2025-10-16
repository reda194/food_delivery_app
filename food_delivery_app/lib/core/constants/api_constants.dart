/// API Constants and Endpoints for Food Delivery App
class ApiConstants {
  ApiConstants._();

  // ==================== BASE URL ====================
  static const String baseUrl = 'https://api.fooddelivery.com/v1';

  // ==================== TIMEOUTS ====================
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ==================== HEADERS ====================
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ==================== AUTHENTICATION ENDPOINTS ====================
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';

  // ==================== USER ENDPOINTS ====================
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String uploadAvatar = '/user/avatar/upload';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete';

  // ==================== RESTAURANT ENDPOINTS ====================
  static const String restaurants = '/restaurants';
  static const String restaurantDetails = '/restaurants/:id';
  static const String restaurantSearch = '/restaurants/search';
  static const String restaurantsByCategory = '/restaurants/category/:category';
  static const String nearbyRestaurants = '/restaurants/nearby';
  static const String featuredRestaurants = '/restaurants/featured';
  static const String restaurantMenu = '/restaurants/:id/menu';

  // ==================== FOOD ITEMS ENDPOINTS ====================
  static const String foodItems = '/food-items';
  static const String foodItemDetails = '/food-items/:id';
  static const String foodItemSearch = '/food-items/search';
  static const String popularItems = '/food-items/popular';
  static const String recommendedItems = '/food-items/recommended';

  // ==================== CATEGORIES ENDPOINTS ====================
  static const String categories = '/categories';
  static const String categoryDetails = '/categories/:id';

  // ==================== CART ENDPOINTS ====================
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCartItem = '/cart/update/:id';
  static const String removeFromCart = '/cart/remove/:id';
  static const String clearCart = '/cart/clear';

  // ==================== ORDER ENDPOINTS ====================
  static const String orders = '/orders';
  static const String createOrder = '/orders/create';
  static const String orderDetails = '/orders/:id';
  static const String orderHistory = '/orders/history';
  static const String cancelOrder = '/orders/:id/cancel';
  static const String trackOrder = '/orders/:id/track';
  static const String reorder = '/orders/:id/reorder';
  static const String rateOrder = '/orders/:id/rate';

  // ==================== PAYMENT ENDPOINTS ====================
  static const String paymentMethods = '/payment/methods';
  static const String addPaymentMethod = '/payment/methods/add';
  static const String removePaymentMethod = '/payment/methods/:id/remove';
  static const String processPayment = '/payment/process';
  static const String paymentIntent = '/payment/intent';

  // ==================== ADDRESS ENDPOINTS ====================
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses/add';
  static const String updateAddress = '/addresses/:id/update';
  static const String deleteAddress = '/addresses/:id/delete';
  static const String setDefaultAddress = '/addresses/:id/set-default';

  // ==================== FAVORITES ENDPOINTS ====================
  static const String favorites = '/favorites';
  static const String addToFavorites = '/favorites/add';
  static const String removeFromFavorites = '/favorites/remove/:id';

  // ==================== OFFERS & COUPONS ENDPOINTS ====================
  static const String offers = '/offers';
  static const String coupons = '/coupons';
  static const String applyCoupon = '/coupons/apply';
  static const String validateCoupon = '/coupons/validate';

  // ==================== REVIEWS & RATINGS ENDPOINTS ====================
  static const String reviews = '/reviews';
  static const String addReview = '/reviews/add';
  static const String restaurantReviews = '/restaurants/:id/reviews';
  static const String foodItemReviews = '/food-items/:id/reviews';

  // ==================== NOTIFICATIONS ENDPOINTS ====================
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/:id/read';
  static const String clearNotifications = '/notifications/clear';
  static const String notificationSettings = '/notifications/settings';

  // ==================== SEARCH ENDPOINTS ====================
  static const String globalSearch = '/search';
  static const String searchSuggestions = '/search/suggestions';

  // ==================== HELPER METHODS ====================
  /// Replace path parameters (e.g., :id) with actual values
  static String replacePathParameter(String path, String parameter, dynamic value) {
    return path.replaceAll(':$parameter', value.toString());
  }

  /// Build query string from map
  static String buildQueryString(Map<String, dynamic> params) {
    final queryString = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    return queryString.isEmpty ? '' : '?$queryString';
  }
}
