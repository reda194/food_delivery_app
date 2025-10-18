# Food Delivery App - Visual Architecture Diagrams

This document provides visual representations of the application architecture, data flows, and component relationships.

---

## 1. CLEAN ARCHITECTURE LAYERS

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                            │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐   │
│  │   Pages    │  │   Widgets  │  │    Bloc    │  │   States   │   │
│  │  (Screens) │  │  (UI Comp) │  │  (Logic)   │  │  (Events)  │   │
│  └────────────┘  └────────────┘  └────────────┘  └────────────┘   │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                                 │
│                   [Pure Business Logic - No Dependencies]            │
│  ┌────────────┐  ┌────────────┐  ┌────────────────────────────┐   │
│  │  Entities  │  │ Repository │  │        Use Cases           │   │
│  │  (Models)  │  │ Interfaces │  │  (Business Operations)     │   │
│  └────────────┘  └────────────┘  └────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                                  │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────────────────┐   │
│  │   Models   │  │ Data Sources │  │     Repositories         │   │
│  │  (DTOs)    │  │ (Remote/Local│  │   (Implementation)       │   │
│  └────────────┘  └──────────────┘  └──────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              External Data Sources                           │  │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌──────────────┐  │  │
│  │  │   API   │  │  Hive   │  │ SharedP │  │   Firebase   │  │  │
│  │  │ (REST)  │  │  (DB)   │  │  (Prefs)│  │   (Cloud)    │  │  │
│  │  └─────────┘  └─────────┘  └─────────┘  └──────────────┘  │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. BLOC DATA FLOW

```
┌──────────────┐
│     User     │
│   Interaction│
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────────────────────────────────────────┐
│                          UI LAYER                                     │
│                                                                       │
│   ┌────────────┐       Event        ┌────────────────────┐          │
│   │   Widget   │ ────────────────► │       Bloc         │          │
│   │  (Screen)  │                    │   (State Manager)  │          │
│   │            │ ◄──────────────── │                    │          │
│   └────────────┘       State        └──────────┬─────────┘          │
│                                                 │                     │
└─────────────────────────────────────────────────┼─────────────────────┘
                                                  │
                                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      BUSINESS LOGIC LAYER                            │
│                                                                      │
│                        ┌──────────────┐                             │
│                        │   Use Case   │                             │
│                        │  (Business   │                             │
│                        │    Logic)    │                             │
│                        └──────┬───────┘                             │
│                               │                                      │
└───────────────────────────────┼──────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                                  │
│                                                                      │
│                   ┌──────────────────┐                              │
│                   │   Repository     │                              │
│                   │ (Implementation) │                              │
│                   └────────┬─────────┘                              │
│                            │                                         │
│              ┌─────────────┴────────────┐                           │
│              ▼                          ▼                            │
│   ┌──────────────────┐      ┌──────────────────┐                   │
│   │ Remote Data      │      │ Local Data       │                   │
│   │ Source (API)     │      │ Source (Hive)    │                   │
│   └────────┬─────────┘      └────────┬─────────┘                   │
│            │                         │                              │
└────────────┼─────────────────────────┼──────────────────────────────┘
             │                         │
             ▼                         ▼
    ┌────────────┐            ┌────────────┐
    │   Server   │            │   Local    │
    │  Database  │            │  Storage   │
    └────────────┘            └────────────┘
```

---

## 3. FEATURE MODULE STRUCTURE (Example: Restaurants)

```
restaurants/
│
├── data/
│   ├── models/
│   │   ├── restaurant_model.dart ───────────┐
│   │   ├── restaurant_details_model.dart    │ Extends →
│   │   ├── opening_hours_model.dart         │
│   │   └── review_model.dart                │
│   │                                         │
│   ├── datasources/                          │
│   │   ├── restaurants_local_datasource.dart│
│   │   └── restaurants_remote_datasource.dart
│   │                                         │
│   └── repositories/                         │
│       └── restaurants_repository_impl.dart ─┼─ Implements
│                                             │
├── domain/                                   │
│   ├── entities/                             │
│   │   ├── restaurant_entity.dart ◄──────────┘
│   │   ├── restaurant_details_entity.dart
│   │   ├── opening_hours_entity.dart
│   │   └── review_entity.dart
│   │
│   ├── repositories/
│   │   └── restaurants_repository.dart ◄──── Interface
│   │
│   └── usecases/
│       ├── get_restaurants_usecase.dart ─────┐
│       ├── get_restaurant_details_usecase.dart│
│       ├── filter_restaurants_usecase.dart    │ Uses Repository
│       ├── get_restaurant_reviews_usecase.dart│
│       └── add_review_usecase.dart ───────────┘
│
└── presentation/
    ├── bloc/
    │   ├── restaurants_bloc.dart ────────────┐
    │   ├── restaurants_event.dart            │
    │   ├── restaurants_state.dart            │ Uses Use Cases
    │   ├── restaurant_details_bloc.dart      │
    │   ├── restaurant_details_event.dart     │
    │   └── restaurant_details_state.dart ────┘
    │
    ├── pages/
    │   ├── restaurants_list_screen.dart
    │   ├── restaurant_details_screen.dart
    │   └── restaurant_reviews_screen.dart
    │
    └── widgets/
        ├── restaurant_card.dart
        ├── restaurant_header.dart
        ├── restaurant_info_section.dart
        ├── opening_hours_widget.dart
        ├── review_card.dart
        ├── rating_stars.dart
        └── filter_bottom_sheet.dart
```

---

## 4. DEPENDENCY INJECTION FLOW

```
┌─────────────────────────────────────────────────────────────────────┐
│                           main.dart                                  │
│                                                                      │
│   await configureDependencies();  ◄── Initialize DI Container       │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  dependency_injection.dart                           │
│                                                                      │
│   final getIt = GetIt.instance;                                     │
│                                                                      │
│   @InjectableInit()                                                 │
│   void configureDependencies() => getIt.init();                     │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│            dependency_injection.config.dart (Generated)              │
│                                                                      │
│   Registers all @injectable, @lazySingleton, @singleton classes     │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Dependency Graph                                 │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    Core Services                             │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │   │
│  │  │ApiClient │  │NetworkInfo│  │ Storage  │  │ Location │   │   │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                             ▲                                        │
│                             │ Injected into                          │
│  ┌─────────────────────────┴───────────────────────────────────┐   │
│  │                    Data Sources                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │   │
│  │  │   Remote DS  │  │   Local DS   │  │   Cache DS   │     │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                             ▲                                        │
│                             │ Injected into                          │
│  ┌─────────────────────────┴───────────────────────────────────┐   │
│  │                    Repositories                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │   │
│  │  │   Auth Repo  │  │ Restaurant R │  │   Cart Repo  │     │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                             ▲                                        │
│                             │ Injected into                          │
│  ┌─────────────────────────┴───────────────────────────────────┐   │
│  │                      Use Cases                               │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │   │
│  │  │  Login UC    │  │ Get Restau UC│  │  Add Cart UC │     │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                             ▲                                        │
│                             │ Injected into                          │
│  ┌─────────────────────────┴───────────────────────────────────┐   │
│  │                         Blocs                                │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │   │
│  │  │  Auth Bloc   │  │Restaurant Bl │  │  Cart Bloc   │     │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                             ▲                                        │
│                             │ Provided to                            │
│                             │                                        │
└─────────────────────────────┼────────────────────────────────────────┘
                              │
                              ▼
                     ┌────────────────┐
                     │   UI Widgets   │
                     │   (Screens)    │
                     └────────────────┘
```

---

## 5. AUTHENTICATION FLOW DIAGRAM

```
┌──────────────┐
│     User     │
│ Enters Login │
│ Credentials  │
└──────┬───────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     LoginScreen                                      │
│                                                                      │
│  Form Validation → Valid → Dispatch LoginEvent(email, password)    │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        AuthBloc                                      │
│                                                                      │
│  Event: LoginEvent                                                  │
│    │                                                                 │
│    ├─ emit(AuthLoading)                                            │
│    │                                                                 │
│    └─ Call LoginUseCase(email, password)                           │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      LoginUseCase                                    │
│                                                                      │
│  Call repository.login(email, password)                             │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  AuthRepositoryImpl                                  │
│                                                                      │
│  1. Check network connection (NetworkInfo)                          │
│  2. If connected:                                                   │
│     ├─ Call remoteDataSource.login()                               │
│     └─ Save tokens to localDataSource                              │
│  3. Return Either<Failure, UserEntity>                             │
│                                                                      │
└──────────────┬────────────────────────────┬─────────────────────────┘
               │                            │
               ▼                            ▼
┌──────────────────────────┐    ┌──────────────────────────┐
│AuthRemoteDataSource      │    │AuthLocalDataSource       │
│                          │    │                          │
│POST /auth/login          │    │saveToken(token)          │
│  ↓                       │    │saveUser(user)            │
│Response:                 │    │                          │
│ - user                   │    │Uses:                     │
│ - accessToken            │    │ - SharedPreferences      │
│ - refreshToken           │    │                          │
└──────────────────────────┘    └──────────────────────────┘
               │
               │ Success
               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  AuthRepositoryImpl                                  │
│                                                                      │
│  Convert AuthResponseModel to UserEntity                            │
│  Return Right(userEntity)                                           │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        AuthBloc                                      │
│                                                                      │
│  result.fold(                                                       │
│    (failure) => emit(AuthError(failure.message)),                  │
│    (user) => emit(Authenticated(user))                             │
│  )                                                                  │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     LoginScreen                                      │
│                                                                      │
│  BlocListener:                                                      │
│    if (state is Authenticated) {                                   │
│      → Navigate to HomeScreen                                      │
│      → Show success message                                        │
│    }                                                                │
│    if (state is AuthError) {                                       │
│      → Show error dialog                                           │
│    }                                                                │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 6. ORDER PLACEMENT FLOW

```
┌──────────────┐
│     User     │
│ Taps "Place  │
│    Order"    │
└──────┬───────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    CheckoutScreen                                    │
│                                                                      │
│  Validate: ✓ Address Selected  ✓ Payment Method  ✓ Cart Not Empty │
│  Dispatch PlaceOrderEvent(checkoutData)                            │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      CheckoutBloc                                    │
│                                                                      │
│  emit(CheckoutLoading)                                              │
│  Call PlaceOrderUseCase(orderRequest)                              │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    PlaceOrderUseCase                                 │
│                                                                      │
│  Validate order data                                                │
│  Call repository.placeOrder(orderRequest)                          │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                CheckoutRepositoryImpl                                │
│                                                                      │
│  1. Check network (NetworkInfo)                                     │
│  2. Call remoteDataSource.placeOrder()                             │
│  3. If success:                                                     │
│     ├─ Save order to localDataSource                               │
│     ├─ Clear cart (CartRepository)                                 │
│     └─ Return Right(orderEntity)                                   │
│                                                                      │
└──────────────┬────────────────────────────┬─────────────────────────┘
               │                            │
               ▼                            ▼
┌──────────────────────────┐    ┌──────────────────────────┐
│CheckoutRemoteDataSource  │    │CheckoutLocalDataSource   │
│                          │    │                          │
│POST /orders              │    │saveOrder(order)          │
│  ↓                       │    │Uses: Hive                │
│Body:                     │    │                          │
│ - cartItems              │    │                          │
│ - address                │    │                          │
│ - paymentMethod          │    │                          │
│ - deliveryTime           │    │                          │
│  ↓                       │    │                          │
│Response:                 │    │                          │
│ - orderId                │    │                          │
│ - orderNumber            │    │                          │
│ - status                 │    │                          │
│ - estimatedDeliveryTime  │    │                          │
└──────────────────────────┘    └──────────────────────────┘
               │ Success
               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      CheckoutBloc                                    │
│                                                                      │
│  emit(OrderPlacedSuccess(order))                                   │
│  Trigger CartBloc.add(ClearCartEvent())                            │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    CheckoutScreen                                    │
│                                                                      │
│  BlocListener:                                                      │
│    if (state is OrderPlacedSuccess) {                              │
│      → Show success dialog                                         │
│      → Navigate to OrderTrackingScreen(orderId)                    │
│      → Send analytics event                                        │
│    }                                                                │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. REAL-TIME ORDER TRACKING FLOW

```
┌──────────────┐
│     User     │
│ Opens Order  │
│   Tracking   │
└──────┬───────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────────────┐
│               OrderTrackingScreen                                    │
│                                                                      │
│  Dispatch StartTrackingEvent(orderId)                               │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  OrderTrackingBloc                                   │
│                                                                      │
│  Call TrackOrderUseCase(orderId)                                    │
│  Subscribe to order updates stream                                  │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    TrackOrderUseCase                                 │
│                                                                      │
│  Call repository.trackOrder(orderId)                                │
│  Return Stream<DeliveryTrackingEntity>                             │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  OrdersRepositoryImpl                                │
│                                                                      │
│  Call remoteDataSource.subscribeToOrderUpdates(orderId)            │
│  Transform updates to entities                                      │
│  Emit stream of tracking updates                                    │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│               OrdersRemoteDataSource                                 │
│                                                                      │
│  WebSocket Connection:                                              │
│    ws://api.example.com/orders/{orderId}/track                     │
│                                                                      │
│  Receives updates:                                                  │
│    {                                                                │
│      "status": "on_the_way",                                       │
│      "driver": {                                                    │
│        "name": "John Doe",                                         │
│        "phone": "+1234567890",                                     │
│        "location": { "lat": 37.7749, "lng": -122.4194 }          │
│      },                                                             │
│      "estimatedTime": 15,                                          │
│      "timestamp": "2025-10-11T22:30:00Z"                          │
│    }                                                                │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             │ Stream of Updates
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  OrderTrackingBloc                                   │
│                                                                      │
│  For each update:                                                   │
│    emit(TrackingUpdated(trackingData))                             │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             │ Multiple Updates
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│               OrderTrackingScreen                                    │
│                                                                      │
│  BlocBuilder:                                                       │
│    ┌──────────────────────────────────────────────────────────┐   │
│    │  Google Map                                               │   │
│    │    - Restaurant marker                                    │   │
│    │    - Driver marker (updated in real-time)                │   │
│    │    - User location marker                                 │   │
│    │    - Route polyline                                       │   │
│    └──────────────────────────────────────────────────────────┘   │
│                                                                      │
│    ┌──────────────────────────────────────────────────────────┐   │
│    │  Status Timeline                                          │   │
│    │    ✓ Order Placed                                        │   │
│    │    ✓ Preparing                                           │   │
│    │    ✓ Ready                                               │   │
│    │    → On the Way  (Current)                              │   │
│    │    ○ Delivered                                           │   │
│    └──────────────────────────────────────────────────────────┘   │
│                                                                      │
│    ┌──────────────────────────────────────────────────────────┐   │
│    │  Driver Info                                              │   │
│    │    👤 John Doe                                           │   │
│    │    ⭐ 4.8                                                │   │
│    │    📞 Call  💬 Message                                   │   │
│    │    🕐 Estimated: 15 min                                  │   │
│    └──────────────────────────────────────────────────────────┘   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 8. CART MANAGEMENT FLOW

```
┌──────────────────────────────────────────────────────────────────────┐
│                          Cart State                                   │
│                    (Global Bloc Instance)                             │
└───────────────────────┬──────────────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ FoodDetails  │ │  RestaurantS │ │ HomeScreen   │
│   Screen     │ │  creen       │ │              │
│              │ │              │ │              │
│ [Add to Cart]│ │ [Add Item]   │ │ [Cart Badge] │
└──────┬───────┘ └──────┬───────┘ └──────┬───────┘
       │                │                │
       │ AddToCartEvent │                │
       └────────────────┼────────────────┘
                        │
                        ▼
        ┌───────────────────────────────┐
        │         CartBloc              │
        │                               │
        │  Events:                      │
        │  • AddToCart(item)            │
        │  • RemoveFromCart(itemId)     │
        │  • UpdateQuantity(itemId, qty)│
        │  • ClearCart()                │
        │  • ApplyPromoCode(code)       │
        │                               │
        │  States:                      │
        │  • CartUpdated(cart)          │
        │  • CartLoading                │
        │  • CartError(message)         │
        └───────────┬───────────────────┘
                    │
                    ▼
        ┌───────────────────────────────┐
        │      CartRepository           │
        │                               │
        │  • addToCart()                │
        │  • removeFromCart()           │
        │  • updateQuantity()           │
        │  • clearCart()                │
        │  • calculateTotal()           │
        └───────────┬───────────────────┘
                    │
                    ▼
        ┌───────────────────────────────┐
        │  CartLocalDataSource          │
        │  (Hive Storage)               │
        │                               │
        │  Box: 'cart'                  │
        │  Key: 'current_cart'          │
        │                               │
        │  Data Structure:              │
        │  {                            │
        │    restaurantId: "123",       │
        │    restaurantName: "Pizza Hut"│
        │    items: [                   │
        │      {                        │
        │        id: "cart_item_1",     │
        │        foodItemId: "food_1",  │
        │        quantity: 2,           │
        │        addons: [...],         │
        │        customizations: {...}, │
        │        price: 19.99           │
        │      }                        │
        │    ],                         │
        │    subtotal: 39.98,           │
        │    deliveryFee: 5.00,         │
        │    tax: 4.50,                 │
        │    total: 49.48               │
        │  }                            │
        └───────────────────────────────┘
```

---

## 9. NAVIGATION STRUCTURE

```
┌─────────────────────────────────────────────────────────────────────┐
│                          App Root                                    │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
            ┌────────────────────────────────┐
            │      AuthenticationCheck       │
            │   (Route Guard in go_router)   │
            └────────┬───────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    Not Authenticated      Authenticated
         │                       │
         ▼                       ▼
┌────────────────────┐   ┌─────────────────────────────┐
│  Onboarding/Login  │   │    Main App Navigation      │
│                    │   │   (Bottom Navigation)       │
│  • SplashScreen    │   │                             │
│  • OnboardingScreen│   │  ┌─────────────────────┐   │
│  • LoginScreen     │   │  │    HomeScreen       │   │
│  • RegisterScreen  │   │  │  (Tab 0 - Default)  │   │
│  • ForgotPassword  │   │  └─────────────────────┘   │
│                    │   │                             │
└────────────────────┘   │  ┌─────────────────────┐   │
                         │  │   SearchScreen      │   │
                         │  │     (Tab 1)         │   │
                         │  └─────────────────────┘   │
                         │                             │
                         │  ┌─────────────────────┐   │
                         │  │   OrdersScreen      │   │
                         │  │     (Tab 2)         │   │
                         │  └─────────────────────┘   │
                         │                             │
                         │  ┌─────────────────────┐   │
                         │  │  FavoritesScreen    │   │
                         │  │     (Tab 3)         │   │
                         │  └─────────────────────┘   │
                         │                             │
                         │  ┌─────────────────────┐   │
                         │  │   ProfileScreen     │   │
                         │  │     (Tab 4)         │   │
                         │  └─────────────────────┘   │
                         └─────────────┬───────────────┘
                                       │
                       ┌───────────────┴───────────────┐
                       │                               │
                       ▼                               ▼
            ┌──────────────────────┐      ┌──────────────────────┐
            │  Feature Screens     │      │  Modal Screens       │
            │  (Full Screen Push)  │      │  (Overlays)          │
            │                      │      │                      │
            │ • RestaurantDetails  │      │ • CartScreen         │
            │ • MenuScreen         │      │ • CheckoutScreen     │
            │ • FoodItemDetails    │      │ • FilterBottomSheet  │
            │ • OrderDetails       │      │ • AddressSelector    │
            │ • OrderTracking      │      │ • PaymentMethods     │
            │ • RestaurantReviews  │      │                      │
            │ • EditProfile        │      │                      │
            │ • Settings           │      │                      │
            │ • Notifications      │      │                      │
            └──────────────────────┘      └──────────────────────┘
```

---

## 10. DATABASE SCHEMA (Hive Boxes)

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Hive Local Storage                           │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  Box: 'cart'                                                         │
│  ────────────────────────────────────────────────────────────────   │
│  Key: 'current_cart'                                                 │
│  Value: CartModel                                                    │
│    - restaurantId                                                    │
│    - items: List<CartItemModel>                                      │
│    - totals                                                          │
│                                                                       │
│  Type Adapter: CartModelAdapter (typeId: 0)                         │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  Box: 'favorites'                                                    │
│  ────────────────────────────────────────────────────────────────   │
│  Key: itemId (String)                                                │
│  Value: FavoriteModel                                                │
│    - id                                                              │
│    - type (restaurant/food)                                          │
│    - itemId                                                          │
│    - itemData (Map)                                                  │
│    - createdAt                                                       │
│    - syncStatus                                                      │
│                                                                       │
│  Type Adapter: FavoriteModelAdapter (typeId: 1)                     │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  Box: 'recent_searches'                                              │
│  ────────────────────────────────────────────────────────────────   │
│  Key: timestamp (String)                                             │
│  Value: RecentSearchModel                                            │
│    - query                                                           │
│    - timestamp                                                       │
│                                                                       │
│  Type Adapter: RecentSearchModelAdapter (typeId: 2)                 │
│  Limit: Keep only last 20 searches                                  │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  Box: 'cached_restaurants'                                           │
│  ────────────────────────────────────────────────────────────────   │
│  Key: restaurantId (String)                                          │
│  Value: RestaurantModel                                              │
│    - All restaurant data                                             │
│    - cacheTimestamp                                                  │
│                                                                       │
│  Cache Duration: 30 minutes                                          │
│  Type Adapter: RestaurantModelAdapter (typeId: 3)                   │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  Box: 'orders_cache'                                                 │
│  ────────────────────────────────────────────────────────────────   │
│  Key: orderId (String)                                               │
│  Value: OrderModel                                                   │
│    - Order details for offline viewing                               │
│                                                                       │
│  Type Adapter: OrderModelAdapter (typeId: 4)                        │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  SharedPreferences Storage                                           │
│  ────────────────────────────────────────────────────────────────   │
│  Keys:                                                               │
│    - 'access_token' (String)                                         │
│    - 'refresh_token' (String)                                        │
│    - 'user_id' (String)                                              │
│    - 'onboarding_completed' (bool)                                   │
│    - 'theme_mode' (String): light/dark/system                        │
│    - 'language_code' (String)                                        │
│    - 'notifications_enabled' (bool)                                  │
│    - 'location_permission_granted' (bool)                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 11. ERROR HANDLING FLOW

```
┌─────────────────────────────────────────────────────────────────────┐
│                      Exception Occurs                                │
│                                                                      │
│  Possible Sources:                                                  │
│  • Network Error (No internet, timeout)                             │
│  • Server Error (500, 404, 403)                                     │
│  • Cache Error (Data not found locally)                             │
│  • Validation Error (Invalid input)                                 │
│  • Unknown Error (Unexpected exceptions)                            │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      Data Source Layer                               │
│                                                                      │
│  Try {                                                              │
│    // API call or local operation                                  │
│  } catch (e) {                                                      │
│    if (e is DioError) {                                            │
│      if (e.type == DioErrorType.connectionTimeout)                 │
│        throw NetworkException('Connection timeout');               │
│      if (e.response?.statusCode == 401)                            │
│        throw UnauthorizedException('Session expired');             │
│      if (e.response?.statusCode >= 500)                            │
│        throw ServerException('Server error');                      │
│    } else if (e is HiveError) {                                    │
│      throw CacheException('Local storage error');                  │
│    } else {                                                         │
│      throw UnknownException(e.toString());                         │
│    }                                                                │
│  }                                                                  │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             │ Exception thrown
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    Repository Layer                                  │
│                                                                      │
│  Try {                                                              │
│    final result = await dataSource.getData();                      │
│    return Right(result);                                           │
│  } on ServerException catch (e) {                                  │
│    return Left(ServerFailure(e.message));                          │
│  } on NetworkException catch (e) {                                 │
│    return Left(NetworkFailure(e.message));                         │
│  } on CacheException catch (e) {                                   │
│    return Left(CacheFailure(e.message));                           │
│  } on UnauthorizedException catch (e) {                            │
│    return Left(AuthFailure(e.message));                            │
│  } catch (e) {                                                      │
│    return Left(UnknownFailure(e.toString()));                      │
│  }                                                                  │
│                                                                      │
│  Returns: Either<Failure, Success>                                 │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             │ Either returned
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       Use Case Layer                                 │
│                                                                      │
│  final result = await repository.getData();                         │
│  return result; // Pass through Either                              │
│                                                                      │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         Bloc Layer                                   │
│                                                                      │
│  final result = await useCase(params);                              │
│                                                                      │
│  result.fold(                                                       │
│    (failure) {                                                      │
│      if (failure is NetworkFailure) {                              │
│        emit(ErrorState('No internet connection'));                 │
│      } else if (failure is ServerFailure) {                        │
│        emit(ErrorState('Server error. Please try again'));         │
│      } else if (failure is AuthFailure) {                          │
│        emit(ErrorState('Session expired. Please login'));          │
│        // Trigger logout                                           │
│      } else {                                                       │
│        emit(ErrorState(failure.message));                          │
│      }                                                              │
│    },                                                               │
│    (success) {                                                      │
│      emit(LoadedState(success));                                   │
│    }                                                                │
│  );                                                                 │
└────────────────────────────┬─────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         UI Layer                                     │
│                                                                      │
│  BlocBuilder<FeatureBloc, FeatureState>(                           │
│    builder: (context, state) {                                     │
│      if (state is ErrorState) {                                    │
│        return ErrorWidget(                                         │
│          message: state.message,                                   │
│          onRetry: () => bloc.add(RetryEvent()),                   │
│        );                                                           │
│      }                                                              │
│      // ... other states                                           │
│    }                                                                │
│  )                                                                  │
│                                                                      │
│  OR use BlocListener for side effects:                             │
│                                                                      │
│  BlocListener<FeatureBloc, FeatureState>(                          │
│    listener: (context, state) {                                    │
│      if (state is ErrorState) {                                    │
│        ScaffoldMessenger.of(context).showSnackBar(                 │
│          SnackBar(content: Text(state.message))                    │
│        );                                                           │
│                                                                      │
│        if (state.message.contains('Session expired')) {            │
│          context.go('/login');                                     │
│        }                                                            │
│      }                                                              │
│    },                                                               │
│    child: // UI widgets                                            │
│  )                                                                  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Summary

These diagrams provide visual representations of:

1. **Clean Architecture layers** and their relationships
2. **Bloc data flow** from UI to data sources
3. **Feature module structure** with all layers
4. **Dependency injection** hierarchy
5. **Authentication flow** end-to-end
6. **Order placement flow** with all steps
7. **Real-time tracking** with WebSocket
8. **Cart management** with global state
9. **Navigation structure** and routing
10. **Database schema** for Hive and SharedPreferences
11. **Error handling** across all layers

Use these diagrams as reference when implementing the architecture. They show the relationships between components and the flow of data through the application.

---

**Note:** These are conceptual diagrams represented in ASCII art. For production documentation, consider creating actual diagrams using tools like:
- draw.io (diagrams.net)
- Lucidchart
- PlantUML
- Mermaid
- Figma

