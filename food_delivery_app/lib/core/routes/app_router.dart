import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/authentication/presentation/pages/login_screen.dart';
import '../../features/authentication/presentation/pages/signup_screen.dart';
import '../../features/authentication/presentation/pages/forgot_password_screen.dart';
import '../../features/authentication/presentation/pages/verification_screen.dart';
import '../../features/order_tracking/presentation/pages/order_tracking_screen.dart';
import '../../features/order_successful/presentation/pages/order_successful_screen.dart';
import '../../features/call/presentation/pages/call_screen.dart';
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/profile/presentation/pages/profile_menu_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/checkout/presentation/pages/add_address_screen.dart';
import '../../features/checkout/presentation/pages/add_card_screen.dart';
import '../../features/restaurant_details/presentation/pages/restaurant_details_screen.dart';
import '../../features/food_details/presentation/pages/food_details_screen.dart';
import '../../features/category/presentation/pages/category_screen.dart';
// Profile imports commented out - screens exist but not imported yet
// import '../../features/profile/presentation/pages/profile_screen.dart';
// import '../../features/profile/presentation/pages/edit_profile_screen.dart';
// import '../../features/profile/presentation/pages/settings_screen.dart';
// import '../../features/profile/presentation/pages/addresses_screen.dart';
// import '../../features/profile/presentation/pages/favorites_screen.dart';
// import '../../features/profile/presentation/pages/payment_methods_screen.dart';
// import '../../features/profile/presentation/pages/notifications_screen.dart';
// import '../../features/profile/presentation/pages/help_screen.dart';
import '../../features/search/presentation/pages/search_screen.dart';
import '../../features/favorites/presentation/pages/saved_foods_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/favorites/domain/usecases/get_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/add_to_favorites_usecase.dart';
import '../../features/favorites/domain/usecases/remove_from_favorites_usecase.dart';
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/restaurant_details/domain/entities/menu_item_entity.dart';
import '../../features/restaurant_details/presentation/bloc/restaurant_details_bloc.dart';
import '../../features/restaurant_details/presentation/bloc/restaurant_details_event.dart';
import '../../features/restaurant_details/domain/usecases/get_restaurant_details_usecase.dart';
import '../../features/restaurant_details/domain/usecases/get_menu_items_usecase.dart';
import '../../features/restaurant_details/domain/usecases/get_reviews_usecase.dart';
import '../../features/restaurant_details/data/datasources/restaurant_details_remote_datasource.dart';
import '../../features/restaurant_details/data/repositories/restaurant_details_repository_impl.dart';
import '../../features/cart/presentation/pages/cart_screen.dart';
import '../../features/checkout/presentation/pages/checkout_screen.dart';
import '../../features/checkout/presentation/bloc/checkout_bloc.dart';
import '../../features/checkout/domain/usecases/get_addresses_usecase.dart';
import '../../features/checkout/domain/usecases/get_payment_methods_usecase.dart';
import '../../features/checkout/domain/usecases/place_order_usecase.dart';
import '../../features/checkout/data/datasources/checkout_remote_datasource.dart';
import '../../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/data/datasources/cart_local_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../core/network/api_client.dart';
import '../../shared/widgets/main_app_wrapper.dart';
import 'route_names.dart';

/// App Router - Centralized routing configuration
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case RouteNames.verifyOtp:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VerificationScreen(
            email: args?['email'] as String?,
            phoneNumber: args?['phoneNumber'] as String?,
          ),
        );

      case '/order-successful':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OrderSuccessfulScreen(
            orderId: args?['orderId'] as String?,
            driverName: args?['driverName'] as String?,
            driverPhone: args?['driverPhone'] as String?,
            driverImage: args?['driverImage'] as String?,
            driverOrderId: args?['driverOrderId'] as String?,
            deliveryAddress: args?['deliveryAddress'] as String?,
            estimatedMinutes: args?['estimatedMinutes'] as int?,
          ),
        );

      case RouteNames.orderTracking:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(
            orderId: args?['orderId'] as String?,
            deliveryAddress: args?['deliveryAddress'] as String?,
            driverName: args?['driverName'] as String?,
            driverPhone: args?['driverPhone'] as String?,
            driverImage: args?['driverImage'] as String?,
            driverOrderId: args?['driverOrderId'] as String?,
            estimatedMinutes: args?['estimatedMinutes'] as int?,
          ),
        );

      case RouteNames.call:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CallScreen(
            driverName: args?['driverName'] as String?,
            driverPhone: args?['driverPhone'] as String?,
            driverImage: args?['driverImage'] as String?,
          ),
        );

      case RouteNames.chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            driverName: args?['driverName'] as String?,
            driverPhone: args?['driverPhone'] as String?,
            driverImage: args?['driverImage'] as String?,
          ),
        );

      case RouteNames.addAddress:
        return MaterialPageRoute(builder: (_) => const AddAddressScreen());

      case '/add-card':
        return MaterialPageRoute(builder: (_) => const AddCardScreen());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const MainAppWrapper());

      case RouteNames.restaurantDetails:
        final restaurantId = settings.arguments as String?;
        if (restaurantId == null) {
          return _errorRoute('Restaurant ID is required');
        }

        // Initialize dependencies for restaurant details
        final apiClient = ApiClient();
        final dataSource = RestaurantDetailsRemoteDataSourceImpl(apiClient);
        final repository = RestaurantDetailsRepositoryImpl(dataSource);
        final getRestaurantDetailsUseCase = GetRestaurantDetailsUseCase(repository);
        final getMenuItemsUseCase = GetMenuItemsUseCase(repository);
        final getReviewsUseCase = GetReviewsUseCase(repository);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => RestaurantDetailsBloc(
              getRestaurantDetailsUseCase: getRestaurantDetailsUseCase,
              getMenuItemsUseCase: getMenuItemsUseCase,
              getReviewsUseCase: getReviewsUseCase,
              repository: repository,
            )..add(LoadRestaurantDetailsEvent(restaurantId)),
            child: RestaurantDetailsScreen(restaurantId: restaurantId),
          ),
        );

      case RouteNames.foodItemDetails:
        final menuItem = settings.arguments as MenuItemEntity?;
        if (menuItem == null) {
          return _errorRoute('Menu item is required');
        }
        return MaterialPageRoute(
          builder: (_) => FoodDetailsScreen(menuItem: menuItem),
        );

      case RouteNames.category:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null) {
          return _errorRoute('Category arguments are required');
        }
        final categoryName = args['categoryName'] as String? ?? 'Category';
        final items = args['items'] as List<MenuItemEntity>? ?? [];
        return MaterialPageRoute(
          builder: (_) => CategoryScreen(
            categoryName: categoryName,
            items: items,
          ),
        );

      case RouteNames.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case RouteNames.checkout:
        // Initialize dependencies for checkout
        final apiClient = ApiClient();
        final checkoutDataSource = CheckoutRemoteDataSourceImpl(apiClient);
        final checkoutRepository = CheckoutRepositoryImpl(checkoutDataSource);
        final getAddressesUseCase = GetAddressesUseCase(checkoutRepository);
        final getPaymentMethodsUseCase = GetPaymentMethodsUseCase(checkoutRepository);
        final placeOrderUseCase = PlaceOrderUseCase(checkoutRepository);

        // Cart dependencies
        final cartLocalDataSource = CartLocalDataSourceImpl();
        final cartRepository = CartRepositoryImpl(
          localDataSource: cartLocalDataSource,
          apiClient: apiClient,
        );
        final getCartUseCase = GetCartUseCase(cartRepository);
        final clearCartUseCase = ClearCartUseCase(cartRepository);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CheckoutBloc(
              getAddressesUseCase: getAddressesUseCase,
              getPaymentMethodsUseCase: getPaymentMethodsUseCase,
              placeOrderUseCase: placeOrderUseCase,
              getCartUseCase: getCartUseCase,
              clearCartUseCase: clearCartUseCase,
            ),
            child: const CheckoutScreen(),
          ),
        );

      case RouteNames.orders:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(
            title: 'My Orders',
            message: 'Orders screen coming soon!',
          ),
        );

      case RouteNames.orderDetails:
        final orderId = settings.arguments as String?;
        if (orderId == null) {
          return _errorRoute('Order ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => _PlaceholderScreen(
            title: 'Order Details',
            message: 'Order ID: $orderId\n\nOrder details screen coming soon!',
          ),
        );

      case RouteNames.profile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProfileMenuScreen(
            userName: args?['userName'] as String?,
            userEmail: args?['userEmail'] as String?,
            userImage: args?['userImage'] as String?,
          ),
        );

      case RouteNames.editProfile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(
            userName: args?['userName'] as String?,
            userEmail: args?['userEmail'] as String?,
            userPhone: args?['userPhone'] as String?,
            userImage: args?['userImage'] as String?,
          ),
        );

      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case RouteNames.addresses:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(
            title: 'Addresses',
            message: 'Addresses screen coming soon!',
          ),
        );

      case RouteNames.favorites:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF4757),
                    ),
                  ),
                );
              }

              // Initialize dependencies for favorites
              final sharedPreferences = snapshot.data!;
              final favoritesLocalDataSource = FavoritesLocalDataSourceImpl(
                sharedPreferences: sharedPreferences,
              );
              final favoritesRepository = FavoritesRepositoryImpl(
                localDataSource: favoritesLocalDataSource,
              );
              final getFavoritesUseCase = GetFavoritesUseCase(favoritesRepository);
              final addToFavoritesUseCase = AddToFavoritesUseCase(favoritesRepository);
              final removeFromFavoritesUseCase = RemoveFromFavoritesUseCase(favoritesRepository);

              return BlocProvider(
                create: (context) => FavoritesBloc(
                  getFavorites: getFavoritesUseCase,
                  addToFavorites: addToFavoritesUseCase,
                  removeFromFavorites: removeFromFavoritesUseCase,
                ),
                child: const SavedFoodsScreen(),
              );
            },
          ),
        );

      case RouteNames.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case RouteNames.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
        );

      case RouteNames.help:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(
            title: 'Help',
            message: 'Help screen coming soon!',
          ),
        );

      case RouteNames.paymentMethod:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(
            title: 'Payment Methods',
            message: 'Payment Methods screen coming soon!',
          ),
        );

      case RouteNames.menu:
        // Menu route can redirect to restaurant details or show a placeholder
        final restaurantId = settings.arguments as String?;
        if (restaurantId != null) {
          // Redirect to restaurant details if restaurant ID is provided
          return generateRoute(
            RouteSettings(
              name: RouteNames.restaurantDetails,
              arguments: restaurantId,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(
            title: 'Menu',
            message: 'Menu screen coming soon!',
          ),
        );

      // Add more routes here as features are implemented

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}

/// Placeholder screen widget for routes that are not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;

  const _PlaceholderScreen({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
