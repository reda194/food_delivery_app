# Food Delivery App - Detailed Class Definitions

This document provides detailed class structures for key entities, models, and components across all features. Use this as a reference when implementing the actual code.

---

## 1. AUTHENTICATION FEATURE

### Domain Layer

#### UserEntity
```dart
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime createdAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.createdAt,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  @override
  List<Object?> get props => [id, name, email, phone, avatar, createdAt];
}
```

#### AuthTokenEntity
```dart
class AuthTokenEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  const AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType = 'Bearer',
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn];
}
```

### Data Layer

#### UserModel
```dart
@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatar,
    required DateTime createdAt,
    required bool isEmailVerified,
    required bool isPhoneVerified,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          avatar: avatar,
          createdAt: createdAt,
          isEmailVerified: isEmailVerified,
          isPhoneVerified: isPhoneVerified,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => this;
}
```

#### AuthResponseModel
```dart
@JsonSerializable()
class AuthResponseModel {
  final UserModel user;
  final TokenModel token;

  AuthResponseModel({
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
```

### Presentation Layer

#### AuthState
```dart
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
```

#### AuthEvent
```dart
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterEvent(this.name, this.email, this.phone, this.password);

  @override
  List<Object?> get props => [name, email, phone, password];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
```

---

## 2. RESTAURANTS FEATURE

### Domain Layer

#### RestaurantEntity
```dart
class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviewCount;
  final List<String> cuisineTypes;
  final int estimatedDeliveryTime; // in minutes
  final double deliveryFee;
  final double distance; // in km
  final bool isOpen;
  final bool isFeatured;
  final bool isFavorite;
  final String? discount; // e.g., "20% OFF"

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.cuisineTypes,
    required this.estimatedDeliveryTime,
    required this.deliveryFee,
    required this.distance,
    required this.isOpen,
    this.isFeatured = false,
    this.isFavorite = false,
    this.discount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        cuisineTypes,
        estimatedDeliveryTime,
        deliveryFee,
        distance,
        isOpen,
      ];
}
```

#### RestaurantDetailsEntity
```dart
class RestaurantDetailsEntity extends RestaurantEntity {
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final OpeningHoursEntity openingHours;
  final List<String> paymentMethods;
  final bool hasDelivery;
  final bool hasPickup;
  final double minimumOrder;

  const RestaurantDetailsEntity({
    required String id,
    required String name,
    required String image,
    required double rating,
    required int reviewCount,
    required List<String> cuisineTypes,
    required int estimatedDeliveryTime,
    required double deliveryFee,
    required double distance,
    required bool isOpen,
    bool isFeatured = false,
    bool isFavorite = false,
    String? discount,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.openingHours,
    required this.paymentMethods,
    required this.hasDelivery,
    required this.hasPickup,
    required this.minimumOrder,
  }) : super(
          id: id,
          name: name,
          image: image,
          rating: rating,
          reviewCount: reviewCount,
          cuisineTypes: cuisineTypes,
          estimatedDeliveryTime: estimatedDeliveryTime,
          deliveryFee: deliveryFee,
          distance: distance,
          isOpen: isOpen,
          isFeatured: isFeatured,
          isFavorite: isFavorite,
          discount: discount,
        );

  @override
  List<Object?> get props => [...super.props, description, address, phone];
}
```

#### OpeningHoursEntity
```dart
class OpeningHoursEntity extends Equatable {
  final Map<String, DayHoursEntity> schedule;
  final bool is24Hours;

  const OpeningHoursEntity({
    required this.schedule,
    this.is24Hours = false,
  });

  @override
  List<Object?> get props => [schedule, is24Hours];
}

class DayHoursEntity extends Equatable {
  final String day; // "Monday", "Tuesday", etc.
  final String? openTime; // "09:00"
  final String? closeTime; // "22:00"
  final bool isClosed;

  const DayHoursEntity({
    required this.day,
    this.openTime,
    this.closeTime,
    this.isClosed = false,
  });

  @override
  List<Object?> get props => [day, openTime, closeTime, isClosed];
}
```

#### ReviewEntity
```dart
class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? images;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images,
  });

  @override
  List<Object?> get props => [id, userId, rating, comment, createdAt];
}
```

---

## 3. MENU FEATURE

### Domain Layer

#### MenuCategoryEntity
```dart
class MenuCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String restaurantId;
  final int displayOrder;

  const MenuCategoryEntity({
    required this.id,
    required this.name,
    required this.restaurantId,
    required this.displayOrder,
  });

  @override
  List<Object?> get props => [id, name, restaurantId, displayOrder];
}
```

#### FoodItemEntity
```dart
class FoodItemEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String categoryId;
  final String restaurantId;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isSpicy;
  final bool isFavorite;
  final double? discountPrice;
  final int? discountPercentage;
  final List<AddonEntity> availableAddons;
  final List<CustomizationEntity> customizations;
  final String? allergyInfo;
  final int? calories;
  final int preparationTime; // in minutes

  const FoodItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.categoryId,
    required this.restaurantId,
    this.isAvailable = true,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isSpicy = false,
    this.isFavorite = false,
    this.discountPrice,
    this.discountPercentage,
    this.availableAddons = const [],
    this.customizations = const [],
    this.allergyInfo,
    this.calories,
    this.preparationTime = 15,
  });

  double get finalPrice => discountPrice ?? price;

  @override
  List<Object?> get props => [id, name, price, categoryId, isAvailable];
}
```

#### AddonEntity
```dart
class AddonEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isAvailable;

  const AddonEntity({
    required this.id,
    required this.name,
    required this.price,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, name, price];
}
```

#### CustomizationEntity
```dart
class CustomizationEntity extends Equatable {
  final String id;
  final String name;
  final bool isRequired;
  final int minSelection;
  final int maxSelection;
  final List<CustomizationOptionEntity> options;

  const CustomizationEntity({
    required this.id,
    required this.name,
    this.isRequired = false,
    this.minSelection = 0,
    this.maxSelection = 1,
    required this.options,
  });

  @override
  List<Object?> get props => [id, name, isRequired, minSelection, maxSelection];
}

class CustomizationOptionEntity extends Equatable {
  final String id;
  final String name;
  final double additionalPrice;

  const CustomizationOptionEntity({
    required this.id,
    required this.name,
    this.additionalPrice = 0.0,
  });

  @override
  List<Object?> get props => [id, name, additionalPrice];
}
```

---

## 4. CART FEATURE

### Domain Layer

#### CartEntity
```dart
class CartEntity extends Equatable {
  final String? restaurantId;
  final String? restaurantName;
  final List<CartItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String? promoCode;

  const CartEntity({
    this.restaurantId,
    this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    this.promoCode,
  });

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [
        restaurantId,
        items,
        subtotal,
        deliveryFee,
        tax,
        discount,
        total,
      ];
}
```

#### CartItemEntity
```dart
class CartItemEntity extends Equatable {
  final String id; // unique cart item ID
  final FoodItemEntity foodItem;
  final int quantity;
  final List<AddonEntity> selectedAddons;
  final Map<String, CustomizationOptionEntity> selectedCustomizations;
  final String? specialInstructions;
  final double itemTotal;

  const CartItemEntity({
    required this.id,
    required this.foodItem,
    required this.quantity,
    this.selectedAddons = const [],
    this.selectedCustomizations = const {},
    this.specialInstructions,
    required this.itemTotal,
  });

  @override
  List<Object?> get props => [
        id,
        foodItem.id,
        quantity,
        selectedAddons,
        selectedCustomizations,
      ];
}
```

#### PriceBreakdownEntity
```dart
class PriceBreakdownEntity extends Equatable {
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double tax;
  final double discount;
  final double tip;
  final double total;

  const PriceBreakdownEntity({
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tax,
    required this.discount,
    this.tip = 0.0,
    required this.total,
  });

  @override
  List<Object?> get props => [
        subtotal,
        deliveryFee,
        serviceFee,
        tax,
        discount,
        tip,
        total,
      ];
}
```

---

## 5. CHECKOUT FEATURE

### Domain Layer

#### DeliveryAddressEntity
```dart
class DeliveryAddressEntity extends Equatable {
  final String id;
  final String label; // "Home", "Work", "Other"
  final String fullAddress;
  final String? apartment; // Apt, Suite, Floor
  final String? landmark;
  final double latitude;
  final double longitude;
  final String? instructions; // Delivery instructions
  final bool isDefault;

  const DeliveryAddressEntity({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.apartment,
    this.landmark,
    required this.latitude,
    required this.longitude,
    this.instructions,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, label, fullAddress, latitude, longitude];
}
```

#### PaymentMethodEntity
```dart
class PaymentMethodEntity extends Equatable {
  final String id;
  final PaymentMethodType type;
  final String? cardLast4;
  final String? cardBrand; // "Visa", "Mastercard", etc.
  final String? expiryDate; // "12/25"
  final bool isDefault;

  const PaymentMethodEntity({
    required this.id,
    required this.type,
    this.cardLast4,
    this.cardBrand,
    this.expiryDate,
    this.isDefault = false,
  });

  String get displayName {
    switch (type) {
      case PaymentMethodType.card:
        return '$cardBrand •••• $cardLast4';
      case PaymentMethodType.cash:
        return 'Cash on Delivery';
      case PaymentMethodType.wallet:
        return 'Digital Wallet';
    }
  }

  @override
  List<Object?> get props => [id, type, cardLast4, cardBrand];
}

enum PaymentMethodType {
  card,
  cash,
  wallet,
}
```

#### DeliveryTimeEntity
```dart
class DeliveryTimeEntity extends Equatable {
  final DeliveryTimeType type;
  final DateTime? scheduledTime;
  final int estimatedMinutes;

  const DeliveryTimeEntity({
    required this.type,
    this.scheduledTime,
    required this.estimatedMinutes,
  });

  String get displayText {
    if (type == DeliveryTimeType.asap) {
      return 'ASAP ($estimatedMinutes min)';
    } else {
      return 'Scheduled: ${scheduledTime!.toString()}';
    }
  }

  @override
  List<Object?> get props => [type, scheduledTime];
}

enum DeliveryTimeType {
  asap,
  scheduled,
}
```

---

## 6. ORDERS FEATURE

### Domain Layer

#### OrderEntity
```dart
class OrderEntity extends Equatable {
  final String id;
  final String orderNumber;
  final RestaurantEntity restaurant;
  final List<OrderItemEntity> items;
  final OrderStatus status;
  final PriceBreakdownEntity priceBreakdown;
  final DeliveryAddressEntity deliveryAddress;
  final PaymentMethodEntity paymentMethod;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final DateTime? deliveredAt;
  final String? cancellationReason;
  final List<OrderStatusUpdateEntity> statusHistory;
  final DeliveryTrackingEntity? tracking;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.restaurant,
    required this.items,
    required this.status,
    required this.priceBreakdown,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.createdAt,
    this.estimatedDeliveryTime,
    this.deliveredAt,
    this.cancellationReason,
    required this.statusHistory,
    this.tracking,
  });

  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;
  bool get canTrack =>
      status == OrderStatus.preparing ||
      status == OrderStatus.onTheWay ||
      status == OrderStatus.nearYou;
  bool get canReorder => status == OrderStatus.delivered;

  @override
  List<Object?> get props => [id, orderNumber, status, createdAt];
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  onTheWay,
  nearYou,
  delivered,
  cancelled,
  failed,
}
```

#### OrderItemEntity
```dart
class OrderItemEntity extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final List<String> addons;
  final Map<String, String> customizations;
  final String? specialInstructions;

  const OrderItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.addons = const [],
    this.customizations = const {},
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [id, name, quantity, price];
}
```

#### OrderStatusUpdateEntity
```dart
class OrderStatusUpdateEntity extends Equatable {
  final OrderStatus status;
  final DateTime timestamp;
  final String? message;

  const OrderStatusUpdateEntity({
    required this.status,
    required this.timestamp,
    this.message,
  });

  @override
  List<Object?> get props => [status, timestamp];
}
```

#### DeliveryTrackingEntity
```dart
class DeliveryTrackingEntity extends Equatable {
  final String driverName;
  final String? driverPhone;
  final String? driverAvatar;
  final double? driverRating;
  final String? vehicleType;
  final String? vehicleNumber;
  final double driverLatitude;
  final double driverLongitude;
  final int estimatedMinutes;
  final double distanceToCustomer; // in km

  const DeliveryTrackingEntity({
    required this.driverName,
    this.driverPhone,
    this.driverAvatar,
    this.driverRating,
    this.vehicleType,
    this.vehicleNumber,
    required this.driverLatitude,
    required this.driverLongitude,
    required this.estimatedMinutes,
    required this.distanceToCustomer,
  });

  @override
  List<Object?> get props => [
        driverName,
        driverLatitude,
        driverLongitude,
        estimatedMinutes,
      ];
}
```

---

## 7. SEARCH FEATURE

### Domain Layer

#### SearchResultEntity
```dart
class SearchResultEntity extends Equatable {
  final List<RestaurantEntity> restaurants;
  final List<FoodItemEntity> foodItems;
  final int totalResults;

  const SearchResultEntity({
    required this.restaurants,
    required this.foodItems,
    required this.totalResults,
  });

  bool get isEmpty => restaurants.isEmpty && foodItems.isEmpty;

  @override
  List<Object?> get props => [restaurants, foodItems, totalResults];
}
```

#### SearchFilterEntity
```dart
class SearchFilterEntity extends Equatable {
  final PriceRange? priceRange;
  final double? minRating;
  final List<String>? cuisineTypes;
  final int? maxDeliveryTime;
  final bool? freeDelivery;
  final List<DietaryFilter>? dietaryFilters;
  final SortBy sortBy;

  const SearchFilterEntity({
    this.priceRange,
    this.minRating,
    this.cuisineTypes,
    this.maxDeliveryTime,
    this.freeDelivery,
    this.dietaryFilters,
    this.sortBy = SortBy.relevance,
  });

  @override
  List<Object?> get props => [
        priceRange,
        minRating,
        cuisineTypes,
        maxDeliveryTime,
        freeDelivery,
        dietaryFilters,
        sortBy,
      ];
}

enum PriceRange {
  budget, // $
  moderate, // $$
  expensive, // $$$
  luxury, // $$$$
}

enum DietaryFilter {
  vegetarian,
  vegan,
  glutenFree,
  halal,
  kosher,
}

enum SortBy {
  relevance,
  rating,
  deliveryTime,
  distance,
  priceLowToHigh,
  priceHighToLow,
}
```

#### RecentSearchEntity
```dart
class RecentSearchEntity extends Equatable {
  final String id;
  final String query;
  final DateTime timestamp;

  const RecentSearchEntity({
    required this.id,
    required this.query,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, query, timestamp];
}
```

---

## 8. FAVORITES FEATURE

### Domain Layer

#### FavoriteEntity
```dart
class FavoriteEntity extends Equatable {
  final String id;
  final FavoriteType type;
  final String itemId;
  final dynamic itemData; // RestaurantEntity or FoodItemEntity
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.type,
    required this.itemId,
    required this.itemData,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, itemId, createdAt];
}

enum FavoriteType {
  restaurant,
  foodItem,
}
```

---

## 9. PROFILE FEATURE

### Domain Layer

#### ProfileEntity
```dart
class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final DateTime? dateOfBirth;
  final String? gender;
  final int totalOrders;
  final double totalSpent;
  final int loyaltyPoints;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.dateOfBirth,
    this.gender,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.loyaltyPoints = 0,
  });

  @override
  List<Object?> get props => [id, name, email, phone];
}
```

#### SettingsEntity
```dart
class SettingsEntity extends Equatable {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool orderUpdates;
  final bool promotions;
  final String language;
  final String theme; // "light", "dark", "system"

  const SettingsEntity({
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.orderUpdates = true,
    this.promotions = true,
    this.language = 'en',
    this.theme = 'system',
  });

  @override
  List<Object?> get props => [
        notificationsEnabled,
        emailNotifications,
        pushNotifications,
        language,
        theme,
      ];
}
```

---

## 10. NOTIFICATIONS FEATURE

### Domain Layer

#### NotificationEntity
```dart
class NotificationEntity extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.data,
    this.imageUrl,
    this.actionUrl,
  });

  @override
  List<Object?> get props => [id, type, title, timestamp, isRead];
}

enum NotificationType {
  orderUpdate,
  promotion,
  general,
  payment,
  review,
  chat,
}
```

---

## 11. USE CASE BASE CLASS

All use cases should extend from this base class:

```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
```

**Example Use Case:**

```dart
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
```

---

## 12. REPOSITORY BASE PATTERN

```dart
abstract class BaseRepository<T> {
  Future<Either<Failure, T>> execute(
    Future<T> Function() remoteCall, {
    Future<T> Function()? localCall,
  }) async {
    try {
      // Check network connectivity
      final hasConnection = await networkInfo.isConnected;

      if (!hasConnection && localCall != null) {
        final localData = await localCall();
        return Right(localData);
      }

      // Execute remote call
      final result = await remoteCall();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

---

## 13. HIVE TYPE ADAPTERS

### CartItemAdapter
```dart
@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String foodItemId;

  @HiveField(2)
  String foodItemName;

  @HiveField(3)
  double price;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  List<String> addons;

  @HiveField(6)
  Map<String, String> customizations;

  CartItemModel({
    required this.id,
    required this.foodItemId,
    required this.foodItemName,
    required this.price,
    required this.quantity,
    this.addons = const [],
    this.customizations = const {},
  });
}
```

### FavoriteAdapter
```dart
@HiveType(typeId: 1)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type; // "restaurant" or "food"

  @HiveField(2)
  String itemId;

  @HiveField(3)
  Map<String, dynamic> itemData;

  @HiveField(4)
  DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.type,
    required this.itemId,
    required this.itemData,
    required this.createdAt,
  });
}
```

---

## 14. API RESPONSE WRAPPERS

### Success Response
```dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
```

### Paginated Response
```dart
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasMore;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasMore,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
}
```

---

## 15. VALIDATION CLASSES

```dart
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
```

---

## 16. EXTENSION CLASSES

```dart
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isToday() {
    final now = DateTime.now();
    return isSameDay(now);
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }
}

extension DoubleExtensions on double {
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  String toDistanceString() {
    if (this < 1) {
      return '${(this * 1000).toInt()} m';
    }
    return '${toStringAsFixed(1)} km';
  }
}
```

---

## 17. CONSTANTS STRUCTURE

### AppColors
```dart
class AppColors {
  static const primary = Color(0xFFFF5733);
  static const primaryDark = Color(0xFFE64A2E);
  static const primaryLight = Color(0xFFFF7A5C);

  static const secondary = Color(0xFF2ECC71);
  static const secondaryDark = Color(0xFF27AE60);
  static const secondaryLight = Color(0xFF58D68D);

  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFE74C3C);
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF39C12);
  static const info = Color(0xFF3498DB);

  static const textPrimary = Color(0xFF2C3E50);
  static const textSecondary = Color(0xFF7F8C8D);
  static const textDisabled = Color(0xFFBDC3C7);

  static const divider = Color(0xFFECF0F1);
  static const border = Color(0xFFD5DBDB);
}
```

### AppDimensions
```dart
class AppDimensions {
  // Padding
  static const paddingXS = 4.0;
  static const paddingSM = 8.0;
  static const paddingMD = 16.0;
  static const paddingLG = 24.0;
  static const paddingXL = 32.0;

  // Margin
  static const marginXS = 4.0;
  static const marginSM = 8.0;
  static const marginMD = 16.0;
  static const marginLG = 24.0;
  static const marginXL = 32.0;

  // Border Radius
  static const radiusXS = 4.0;
  static const radiusSM = 8.0;
  static const radiusMD = 12.0;
  static const radiusLG = 16.0;
  static const radiusXL = 24.0;

  // Icon Sizes
  static const iconXS = 16.0;
  static const iconSM = 20.0;
  static const iconMD = 24.0;
  static const iconLG = 32.0;
  static const iconXL = 48.0;

  // Button Heights
  static const buttonHeightSM = 36.0;
  static const buttonHeightMD = 48.0;
  static const buttonHeightLG = 56.0;

  // App Bar
  static const appBarHeight = 56.0;
  static const bottomNavBarHeight = 64.0;
}
```

---

This document provides the complete class structure for all major entities, models, and components. Use these definitions as templates when implementing the actual code. Remember to:

1. Add JSON serialization annotations for all models
2. Add Hive type adapters where needed
3. Implement proper equality comparison with Equatable
4. Follow null-safety best practices
5. Add comprehensive documentation comments
6. Write tests for all domain entities

