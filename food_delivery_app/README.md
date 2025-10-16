# Food Delivery App - Flutter + Bloc + Clean Architecture

A complete, production-ready food delivery application built with Flutter, implementing Clean Architecture and Bloc state management pattern.

## Overview

This project demonstrates a full-stack food delivery application with:
- **Clean Architecture** (Domain, Data, Presentation layers)
- **Bloc Pattern** for state management
- **Material Design 3** with custom theming
- **Comprehensive Design System** (colors, typography, spacing)
- **Reusable Widget Library**
- **API Integration** with Dio
- **Local Storage** with Hive & SharedPreferences
- **Complete Authentication Flow**

## Project Structure

```
food_delivery_app/
├── lib/
│   ├── core/                          # Core functionality shared across features
│   │   ├── constants/                 # App-wide constants
│   │   │   ├── app_colors.dart       # Color palette (primary, secondary, semantic)
│   │   │   ├── app_text_styles.dart  # Typography system (Poppins, Roboto)
│   │   │   ├── app_dimensions.dart   # Spacing, sizing (8px grid system)
│   │   │   └── api_constants.dart    # API endpoints and configuration
│   │   ├── theme/
│   │   │   └── app_theme.dart        # Material Design 3 theme configuration
│   │   ├── network/
│   │   │   ├── api_client.dart       # Dio HTTP client wrapper
│   │   │   └── dio_interceptor.dart  # Request/response interceptor
│   │   ├── errors/
│   │   │   └── failures.dart         # Error handling classes
│   │   ├── routes/                    # App navigation
│   │   ├── utils/                     # Utility functions
│   │   └── services/                  # App-wide services
│   │
│   ├── features/                      # Feature-based modules
│   │   └── authentication/            # Authentication feature
│   │       ├── data/                  # Data layer
│   │       │   ├── models/
│   │       │   │   ├── user_model.dart      # JSON serializable model
│   │       │   │   └── user_model.g.dart    # Generated JSON code
│   │       │   ├── datasources/       # Remote & local data sources
│   │       │   └── repositories/      # Repository implementations
│   │       ├── domain/                # Domain layer (business logic)
│   │       │   ├── entities/
│   │       │   │   └── user_entity.dart     # Core business object
│   │       │   ├── repositories/
│   │       │   │   └── auth_repository.dart # Repository interface
│   │       │   └── usecases/
│   │       │       └── login_usecase.dart   # Business logic use case
│   │       └── presentation/          # Presentation layer (UI)
│   │           ├── bloc/
│   │           │   ├── auth_bloc.dart       # State management
│   │           │   ├── auth_event.dart      # Events
│   │           │   └── auth_state.dart      # States
│   │           ├── pages/
│   │           │   └── login_screen.dart    # Login UI
│   │           └── widgets/           # Feature-specific widgets
│   │
│   ├── shared/                        # Shared UI components
│   │   └── widgets/
│   │       ├── buttons/
│   │       │   └── primary_button.dart      # Reusable button
│   │       └── inputs/
│   │           └── custom_text_field.dart   # Reusable text field
│   │
│   ├── config/                        # App configuration
│   └── main.dart                      # App entry point
│
├── assets/                            # Static assets
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── test/                              # Tests
│   ├── unit/
│   ├── widget/
│   └── integration/
│
└── pubspec.yaml                       # Dependencies
```

## Design System

### Colors
- **Primary**: Vibrant Orange (#FF6B35) - Main brand color
- **Secondary**: Deep Teal (#00B894) - Accent color
- **Semantic Colors**: Success, Warning, Error, Info
- **Neutral Colors**: Background, Surface, Text variations
- **Food Delivery Specific**: Order status colors, category colors, ratings

### Typography
- **Primary Font**: Poppins (titles, headings, labels)
- **Secondary Font**: Roboto (body text, descriptions)
- **Type Scale**: Display, Headline, Title, Body, Label sizes
- **Custom Styles**: Restaurant names, prices, ratings, delivery time

### Spacing
- **8px Grid System**: All spacing follows 8px increments
- **Semantic Spacing**: Screen padding, section spacing, card padding
- **Component Sizes**: Buttons, inputs, cards, icons with consistent dimensions

## Architecture

### Clean Architecture Layers

#### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (e.g., `UserEntity`)
- **Repositories**: Interfaces defining data operations
- **Use Cases**: Single-responsibility business logic units

**Example: Login Use Case**
```dart
final result = await loginUseCase(LoginParams(
  email: 'user@example.com',
  password: 'password123',
));
```

#### 2. Data Layer (Data Management)
- **Models**: JSON-serializable data objects extending entities
- **Data Sources**: Remote (API) and Local (Cache) data sources
- **Repository Implementations**: Concrete implementations of domain repositories

**Example: User Model**
```dart
@JsonSerializable()
class UserModel extends UserEntity {
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### 3. Presentation Layer (UI)
- **Bloc**: State management with events and states
- **Pages**: Full-screen UI components
- **Widgets**: Reusable UI components

**Example: Auth Bloc**
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  on<LoginEvent>(_onLogin);
  on<LogoutEvent>(_onLogout);
}
```

## State Management with Bloc

### Event → Bloc → State Flow

1. **User Action**: Button press triggers event
```dart
context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
```

2. **Bloc Processes Event**: Calls use case, handles result
```dart
final result = await loginUseCase(params);
result.fold(
  (failure) => emit(AuthError(failure.message)),
  (user) => emit(Authenticated(user)),
);
```

3. **UI Reacts to State**: BlocListener/BlocBuilder update UI
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is Authenticated) Navigator.pushNamed('/home');
    if (state is AuthError) showErrorSnackBar(state.message);
  },
);
```

## Key Features Implemented

### 1. Design System ✓
- Complete color palette
- Typography scale
- Spacing system
- Component dimensions

### 2. Theme Configuration ✓
- Material Design 3 theme
- Light theme (dark theme structure ready)
- Consistent component styling

### 3. Core Infrastructure ✓
- API client with Dio
- HTTP interceptor for auth
- Error handling
- Network layer setup

### 4. Shared Widgets ✓
- PrimaryButton with loading/disabled states
- CustomTextField with validation

### 5. Authentication Feature ✓
- Complete Clean Architecture implementation
- Bloc state management
- Login screen UI
- Domain layer with entities, repositories, use cases
- Data layer with models
- Presentation layer with Bloc and UI

## Getting Started

### Prerequisites
- Flutter SDK 3.3+ installed
- Dart 3.3+
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. Navigate to project directory:
```bash
cd food_delivery_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for JSON serialization):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Dependencies

### State Management
- `flutter_bloc: ^8.1.4` - Bloc pattern implementation
- `equatable: ^2.0.5` - Value equality

### Dependency Injection
- `get_it: ^7.6.7` - Service locator
- `injectable: ^2.3.2` - DI code generation

### Networking
- `dio: ^5.4.1` - HTTP client
- `retrofit: ^4.1.0` - Type-safe API client
- `json_annotation: ^4.8.1` - JSON serialization

### Local Storage
- `shared_preferences: ^2.2.2` - Key-value storage
- `hive: ^2.2.3` - NoSQL database
- `hive_flutter: ^1.1.0` - Hive Flutter integration

### UI
- `cached_network_image: ^3.3.1` - Image caching
- `shimmer: ^3.0.0` - Loading shimmer effect
- `flutter_svg: ^2.0.10` - SVG support

### Utilities
- `dartz: ^0.10.1` - Functional programming (Either, Option)
- `internet_connection_checker: ^1.0.0+1` - Network connectivity

## Next Steps to Complete

### Features to Implement
1. **Home Screen**: Restaurant listings, categories, search
2. **Restaurant Details**: Menu items, ratings, reviews
3. **Cart**: Add to cart, quantity management, checkout
4. **Orders**: Order tracking, history
5. **Profile**: User settings, addresses, payment methods
6. **Search**: Global search with filters
7. **Favorites**: Save favorite restaurants/items

### Additional Components
1. **Restaurant Card Widget**
2. **Food Item Card Widget**
3. **Bottom Navigation Bar**
4. **Search Bar**
5. **Filter Chips**
6. **Rating Widget**
7. **Order Status Timeline**

### Backend Integration
1. Connect to actual API endpoints
2. Implement repository data sources
3. Add token refresh logic
4. Handle offline mode

### Testing
1. Unit tests for use cases
2. Widget tests for UI components
3. Integration tests for user flows
4. Bloc tests for state management

## Code Generation Commands

```bash
# Generate JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs

# Generate dependency injection code
flutter pub run build_runner build
```

## Best Practices Followed

1. **Clean Architecture**: Clear separation of concerns
2. **SOLID Principles**: Single responsibility, dependency inversion
3. **Immutability**: Using const, final, Equatable
4. **Type Safety**: Proper typing throughout
5. **Error Handling**: Either type for success/failure
6. **Code Organization**: Feature-based structure
7. **Reusability**: Shared widgets and utilities
8. **Consistency**: Design system for uniform UI
9. **Testability**: Loosely coupled, mockable dependencies
10. **Scalability**: Easy to add new features

## Design Patterns Used

1. **Repository Pattern**: Data access abstraction
2. **Use Case Pattern**: Business logic encapsulation
3. **Bloc Pattern**: State management
4. **Singleton Pattern**: API client, service locator
5. **Factory Pattern**: Model creation
6. **Observer Pattern**: Bloc streams

## API Integration Guide

### Setting Up API Client

The API client is already configured in `lib/core/network/api_client.dart`.

To use it:

```dart
final apiClient = ApiClient();

// GET request
final response = await apiClient.get('/restaurants');

// POST request
final response = await apiClient.post('/auth/login', data: {
  'email': 'user@example.com',
  'password': 'password123',
});
```

### Adding New Endpoints

1. Add endpoint constant in `api_constants.dart`
2. Create data source method
3. Implement in repository
4. Call from use case

## Contributing

This is a demonstration project showing best practices for Flutter development with Clean Architecture and Bloc.

## License

This project is created for educational purposes.

---

**Generated with Flutter 3.19+ | Dart 3.3+**
**Architecture: Clean Architecture + Bloc Pattern**
**UI: Material Design 3 with Custom Theme**
