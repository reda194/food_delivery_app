import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/routes/route_names.dart';
import 'core/network/api_client.dart';
import 'core/services/supabase_service.dart';
import 'core/services/authentication_service.dart';
import 'core/services/database_service.dart';
import 'core/services/realtime_service.dart';
import 'core/services/logger_service.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_featured_restaurants_usecase.dart';
import 'features/home/domain/usecases/get_categories_usecase.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/cart/data/datasources/cart_local_datasource.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'features/cart/domain/usecases/get_cart_usecase.dart';
import 'features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'features/cart/domain/usecases/clear_cart_usecase.dart';
import 'features/cart/domain/usecases/apply_promo_code_usecase.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';

// Search Bloc imports
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search_items_usecase.dart';
import 'features/search/domain/usecases/get_recent_searches_usecase.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/data/datasources/search_remote_datasource.dart';
import 'features/search/data/datasources/search_local_datasource.dart';
import 'features/search/presentation/bloc/search_bloc.dart';

// Food Details Bloc imports
import 'features/food_details/domain/repositories/food_details_repository.dart';
import 'features/food_details/domain/usecases/get_menu_item_details_usecase.dart';
import 'features/food_details/domain/usecases/get_menu_item_ingredients_usecase.dart';
import 'features/food_details/domain/usecases/toggle_favorite_usecase.dart';
import 'features/food_details/data/repositories/food_details_repository_impl.dart';
import 'features/food_details/data/datasources/food_details_local_datasource.dart';
import 'features/food_details/presentation/bloc/food_details_bloc.dart';

/// Initialize all backend services
Future<void> _initializeServices() async {
  try {
    // Initialize Logger first
    LoggerService.instance.info('Initializing application services...');

    // Initialize Supabase & Authentication
    await SupabaseService.instance.initialize();
    LoggerService.instance.success('Supabase initialized');

    // Database and Real-time services are singleton instances
    // They will be lazily initialized when first accessed
    DatabaseService.instance;
    RealtimeService.instance;
    AuthenticationService.instance;

    LoggerService.instance.success('All backend services initialized successfully');
  } catch (e, stackTrace) {
    LoggerService.instance.error('Failed to initialize services: $e', e, stackTrace);
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Supabase
  try {
    await _initializeServices();
  } catch (e) {
    // Handle initialization error gracefully
    debugPrint('Failed to initialize services: $e');
  }

  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive Adapters
  Hive.registerAdapter(CartItemModelAdapter());

  // Initialize dependencies (in a real app, use get_it or injectable)
  final apiClient = ApiClient();

  // Home dependencies
  final homeRemoteDataSource = HomeRemoteDataSourceImpl(apiClient);
  final homeRepository = HomeRepositoryImpl(homeRemoteDataSource);
  final getFeaturedRestaurantsUseCase = GetFeaturedRestaurantsUseCase(homeRepository);
  final getCategoriesUseCase = GetCategoriesUseCase(homeRepository);

  // Cart dependencies
  final cartLocalDataSource = CartLocalDataSourceImpl();
  final cartRepository = CartRepositoryImpl(
    localDataSource: cartLocalDataSource,
    apiClient: apiClient,
  );
  final getCartUseCase = GetCartUseCase(cartRepository);
  final addToCartUseCase = AddToCartUseCase(cartRepository);
  final updateCartItemUseCase = UpdateCartItemUseCase(cartRepository);
  final removeFromCartUseCase = RemoveFromCartUseCase(cartRepository);
  final clearCartUseCase = ClearCartUseCase(cartRepository);
  final applyPromoCodeUseCase = ApplyPromoCodeUseCase(cartRepository);

  // Auth dependencies
  final authRepository = AuthRepositoryImpl();
  final loginUseCase = LoginUseCase(authRepository);

  // Search dependencies
  final searchRemoteDataSource = SearchRemoteDataSourceImpl(apiClient);
  final prefs = await SharedPreferences.getInstance();
  final searchLocalDataSource = SearchLocalDataSourceImpl(prefs);
  final searchRepository = SearchRepositoryImpl(
    remoteDataSource: searchRemoteDataSource,
    localDataSource: searchLocalDataSource,
  );
  final searchItemsUseCase = SearchItemsUseCase(searchRepository);
  final getRecentSearchesUseCase = GetRecentSearchesUseCase(searchRepository);

  // Food Details dependencies
  final foodDetailsLocalDataSource = FoodDetailsLocalDataSourceImpl();
  final foodDetailsRepository = FoodDetailsRepositoryImpl(
    localDataSource: foodDetailsLocalDataSource,
  );
  final getMenuItemDetailsUseCase = GetMenuItemDetailsUseCase(foodDetailsRepository);
  final getMenuItemIngredientsUseCase = GetMenuItemIngredientsUseCase(foodDetailsRepository);
  final toggleFavoriteUseCase = ToggleFavoriteUseCase(foodDetailsRepository);

  runApp(
    FoodDeliveryApp(
      homeRepository: homeRepository,
      getFeaturedRestaurantsUseCase: getFeaturedRestaurantsUseCase,
      getCategoriesUseCase: getCategoriesUseCase,
      cartRepository: cartRepository,
      getCartUseCase: getCartUseCase,
      addToCartUseCase: addToCartUseCase,
      updateCartItemUseCase: updateCartItemUseCase,
      removeFromCartUseCase: removeFromCartUseCase,
      clearCartUseCase: clearCartUseCase,
      applyPromoCodeUseCase: applyPromoCodeUseCase,
      authRepository: authRepository,
      loginUseCase: loginUseCase,
      searchRepository: searchRepository,
      searchItemsUseCase: searchItemsUseCase,
      getRecentSearchesUseCase: getRecentSearchesUseCase,
      foodDetailsRepository: foodDetailsRepository,
      getMenuItemDetailsUseCase: getMenuItemDetailsUseCase,
      getMenuItemIngredientsUseCase: getMenuItemIngredientsUseCase,
      toggleFavoriteUseCase: toggleFavoriteUseCase,
    ),
  );
}

class FoodDeliveryApp extends StatelessWidget {
  final HomeRepository homeRepository;
  final GetFeaturedRestaurantsUseCase getFeaturedRestaurantsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final dynamic cartRepository;
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final ApplyPromoCodeUseCase applyPromoCodeUseCase;
  final AuthRepository authRepository;
  final LoginUseCase loginUseCase;
  final SearchRepository searchRepository;
  final SearchItemsUseCase searchItemsUseCase;
  final GetRecentSearchesUseCase getRecentSearchesUseCase;
  final FoodDetailsRepository foodDetailsRepository;
  final GetMenuItemDetailsUseCase getMenuItemDetailsUseCase;
  final GetMenuItemIngredientsUseCase getMenuItemIngredientsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  const FoodDeliveryApp({
    super.key,
    required this.homeRepository,
    required this.getFeaturedRestaurantsUseCase,
    required this.getCategoriesUseCase,
    required this.cartRepository,
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.applyPromoCodeUseCase,
    required this.authRepository,
    required this.loginUseCase,
    required this.searchRepository,
    required this.searchItemsUseCase,
    required this.getRecentSearchesUseCase,
    required this.foodDetailsRepository,
    required this.getMenuItemDetailsUseCase,
    required this.getMenuItemIngredientsUseCase,
    required this.toggleFavoriteUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Home Bloc - Available throughout the app
        BlocProvider(
          create: (context) => HomeBloc(
            getFeaturedRestaurantsUseCase: getFeaturedRestaurantsUseCase,
            getCategoriesUseCase: getCategoriesUseCase,
            repository: homeRepository,
          )..add(const LoadHomeDataEvent()),
        ),

        // Cart Bloc - Available throughout the app
        BlocProvider(
          create: (context) => CartBloc(
            getCartUseCase: getCartUseCase,
            addToCartUseCase: addToCartUseCase,
            updateCartItemUseCase: updateCartItemUseCase,
            removeFromCartUseCase: removeFromCartUseCase,
            clearCartUseCase: clearCartUseCase,
            applyPromoCodeUseCase: applyPromoCodeUseCase,
            repository: cartRepository,
          )..add(const LoadCartEvent()),
        ),

        // Auth Bloc - Available throughout the app
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: loginUseCase,
            authRepository: authRepository,
          ),
        ),

        // Search Bloc - Available throughout the app
        BlocProvider(
          create: (context) => SearchBloc(
            searchItemsUseCase: searchItemsUseCase,
            getRecentSearchesUseCase: getRecentSearchesUseCase,
            repository: searchRepository,
          ),
        ),

        // Food Details Bloc - Available throughout the app
        BlocProvider(
          create: (context) => FoodDetailsBloc(
            getMenuItemDetailsUseCase: getMenuItemDetailsUseCase,
            getMenuItemIngredientsUseCase: getMenuItemIngredientsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            repository: foodDetailsRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Food Delivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: RouteNames.splash, // Start with splash screen
      ),
    );
  }
}
