/// Route Names - Centralized route name constants
class RouteNames {
  RouteNames._();

  // Authentication Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';

  // Main App Routes
  static const String home = '/home';
  static const String restaurantDetails = '/restaurant-details';
  static const String menu = '/menu';
  static const String foodItemDetails = '/food-item-details';
  static const String category = '/category';

  // Cart & Checkout Routes
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String addAddress = '/add-address';
  static const String paymentMethod = '/payment-method';

  // Order Routes
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String orderTracking = '/order-tracking';

  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String addresses = '/addresses';
  static const String favorites = '/favorites';

  // Other Routes
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String help = '/help';
}
