# Food Delivery App - Integration & Development Guide

## Complete Step-by-Step Guide to Using and Extending the Application

---

## Table of Contents
1. [Quick Start](#quick-start)
2. [Design System Usage](#design-system-usage)
3. [Adding New Features](#adding-new-features)
4. [Creating New Screens](#creating-new-screens)
5. [API Integration](#api-integration)
6. [State Management with Bloc](#state-management-with-bloc)
7. [Custom Widgets](#custom-widgets)
8. [Testing](#testing)
9. [Figma to Code Workflow](#figma-to-code-workflow)
10. [Troubleshooting](#troubleshooting)

---

## Quick Start

### 1. Setup Project

```bash
# Navigate to project
cd food_delivery_app

# Install dependencies
flutter pub get

# Generate required code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

### 2. Project Overview

The app follows **Clean Architecture** with **Bloc** state management:

- **lib/core**: Shared functionality (theme, network, constants)
- **lib/features**: Feature modules (auth, home, cart, etc.)
- **lib/shared**: Reusable UI components
- **lib/config**: App configuration

---

## Design System Usage

### Colors

```dart
import 'package:food_delivery_app/core/constants/app_colors.dart';

// Use predefined colors
Container(
  color: AppColors.primary,        // Orange brand color
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)

// Semantic colors
Container(color: AppColors.success)  // For success states
Container(color: AppColors.error)    // For error states
Container(color: AppColors.warning)  // For warnings

// Order status colors
Container(color: AppColors.orderPending)
Container(color: AppColors.orderDelivered)
```

### Typography

```dart
import 'package:food_delivery_app/core/constants/app_text_styles.dart';

// Use predefined text styles
Text('Welcome', style: AppTextStyles.headlineLarge)
Text('Description', style: AppTextStyles.bodyMedium)
Text('Button', style: AppTextStyles.labelLarge)

// Custom food delivery styles
Text('$19.99', style: AppTextStyles.priceMedium)
Text('4.5', style: AppTextStyles.rating)
Text('Burger King', style: AppTextStyles.restaurantName)
```

### Spacing & Dimensions

```dart
import 'package:food_delivery_app/core/constants/app_dimensions.dart';

// Spacing
Padding(padding: EdgeInsets.all(AppDimensions.space16))
SizedBox(height: AppDimensions.space24)

// Border radius
BorderRadius.circular(AppDimensions.cardRadius)

// Button height
SizedBox(height: AppDimensions.buttonHeightMedium)
```

---

## Adding New Features

### Step-by-Step: Create a "Restaurant" Feature

#### 1. Create Folder Structure

```bash
mkdir -p lib/features/restaurants/{data/{models,datasources,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

#### 2. Create Entity (Domain Layer)

**File**: `lib/features/restaurants/domain/entities/restaurant_entity.dart`

```dart
import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int deliveryTime; // minutes
  final List<String> cuisines;
  final double deliveryFee;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.cuisines,
    required this.deliveryFee,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, rating, deliveryTime, cuisines, deliveryFee];
}
```

#### 3. Create Repository Interface (Domain Layer)

**File**: `lib/features/restaurants/domain/repositories/restaurant_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants();
  Future<Either<Failure, RestaurantEntity>> getRestaurantDetails(String id);
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants(String query);
}
```

#### 4. Create Use Case (Domain Layer)

**File**: `lib/features/restaurants/domain/usecases/get_restaurants_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantRepository repository;

  GetRestaurantsUseCase(this.repository);

  Future<Either<Failure, List<RestaurantEntity>>> call() async {
    return await repository.getRestaurants();
  }
}
```

#### 5. Create Model (Data Layer)

**File**: `lib/features/restaurants/data/models/restaurant_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/restaurant_entity.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.deliveryTime,
    required super.cuisines,
    required super.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
```

Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 6. Create Data Source (Data Layer)

**File**: `lib/features/restaurants/data/datasources/restaurant_remote_datasource.dart`

```dart
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants();
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final ApiClient apiClient;

  RestaurantRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<RestaurantModel>> getRestaurants() async {
    final response = await apiClient.get(ApiConstants.restaurants);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['restaurants'];
      return data.map((json) => RestaurantModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
}
```

#### 7. Implement Repository (Data Layer)

**File**: `lib/features/restaurants/data/repositories/restaurant_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getRestaurants();
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RestaurantEntity>> getRestaurantDetails(String id) async {
    // Implement
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants(String query) async {
    // Implement
    throw UnimplementedError();
  }
}
```

#### 8. Create Bloc (Presentation Layer)

**Events**: `lib/features/restaurants/presentation/bloc/restaurant_event.dart`

```dart
import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRestaurantsEvent extends RestaurantEvent {}

class SearchRestaurantsEvent extends RestaurantEvent {
  final String query;
  SearchRestaurantsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
```

**States**: `lib/features/restaurants/presentation/bloc/restaurant_state.dart`

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant_entity.dart';

abstract class RestaurantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<RestaurantEntity> restaurants;
  RestaurantLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants];
}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}
```

**Bloc**: `lib/features/restaurants/presentation/bloc/restaurant_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_restaurants_usecase.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantsUseCase getRestaurantsUseCase;

  RestaurantBloc({required this.getRestaurantsUseCase})
      : super(RestaurantInitial()) {
    on<LoadRestaurantsEvent>(_onLoadRestaurants);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());

    final result = await getRestaurantsUseCase();

    result.fold(
      (failure) => emit(RestaurantError(failure.message)),
      (restaurants) => emit(RestaurantLoaded(restaurants)),
    );
  }
}
```

#### 9. Create UI Screen (Presentation Layer)

**File**: `lib/features/restaurants/presentation/pages/restaurants_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/restaurant_bloc.dart';
import '../bloc/restaurant_event.dart';
import '../bloc/restaurant_state.dart';
import '../widgets/restaurant_card.dart';

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantError) {
            return Center(child: Text(state.message));
          }

          if (state is RestaurantLoaded) {
            return ListView.builder(
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = state.restaurants[index];
                return RestaurantCard(restaurant: restaurant);
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<RestaurantBloc>().add(LoadRestaurantsEvent());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

---

## Creating New Screens

### Using Design System

```dart
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/constants/app_colors.dart';
import 'package:food_delivery_app/core/constants/app_dimensions.dart';
import 'package:food_delivery_app/core/constants/app_text_styles.dart';
import 'package:food_delivery_app/shared/widgets/buttons/primary_button.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Example', style: AppTextStyles.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heading
            Text('Welcome', style: AppTextStyles.headlineLarge),

            SizedBox(height: AppDimensions.space16),

            // Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.cardPadding),
                child: Text('Content', style: AppTextStyles.bodyMedium),
              ),
            ),

            SizedBox(height: AppDimensions.space24),

            // Button
            PrimaryButton(
              text: 'Continue',
              onPressed: () {
                // Handle button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## API Integration

### Add New Endpoint

1. **Add to API Constants**:
```dart
// lib/core/constants/api_constants.dart
static const String restaurants = '/restaurants';
static const String restaurantDetails = '/restaurants/:id';
```

2. **Use in Data Source**:
```dart
final response = await apiClient.get(ApiConstants.restaurants);
```

3. **With Path Parameters**:
```dart
final path = ApiConstants.replacePathParameter(
  ApiConstants.restaurantDetails,
  'id',
  restaurantId,
);
final response = await apiClient.get(path);
```

---

## Custom Widgets

### Create Restaurant Card Widget

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../domain/entities/restaurant_entity.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.cardRadius),
              ),
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                height: AppDimensions.restaurantCardImageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.shimmerBase,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(AppDimensions.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant name
                  Text(
                    restaurant.name,
                    style: AppTextStyles.restaurantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: AppDimensions.space4),

                  // Cuisines
                  Text(
                    restaurant.cuisines.join(' • '),
                    style: AppTextStyles.cuisineType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: AppDimensions.space8),

                  // Rating, delivery time, fee
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: AppDimensions.iconXS,
                        color: AppColors.rating,
                      ),
                      SizedBox(width: AppDimensions.space4),
                      Text(
                        restaurant.rating.toString(),
                        style: AppTextStyles.rating,
                      ),
                      SizedBox(width: AppDimensions.space12),
                      Icon(
                        Icons.access_time,
                        size: AppDimensions.iconXS,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppDimensions.space4),
                      Text(
                        '${restaurant.deliveryTime} min',
                        style: AppTextStyles.deliveryTime,
                      ),
                      const Spacer(),
                      Text(
                        '\$${restaurant.deliveryFee.toStringAsFixed(2)} delivery',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Figma to Code Workflow

### Extracting Design Tokens from Figma

1. **Colors**:
   - Open Figma file
   - Note all color values
   - Add to `app_colors.dart`

2. **Typography**:
   - Note font families, sizes, weights
   - Add to `app_text_styles.dart`

3. **Spacing**:
   - Measure padding, margins
   - Add to `app_dimensions.dart`

4. **Components**:
   - Identify reusable components
   - Create Flutter widgets

### Creating Screens from Figma

1. **Analyze Layout**: Identify major sections
2. **Break Down Components**: List widgets needed
3. **Create Widget Tree**: Plan Flutter structure
4. **Implement**: Write code using design system
5. **Test**: Compare with Figma design

---

## Testing

### Unit Test Example

```dart
// test/features/authentication/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = LoginUseCase(mockRepo);
  });

  test('should return UserEntity when login succeeds', () async {
    // Arrange
    when(mockRepo.login(email: any, password: any))
        .thenAnswer((_) async => Right(tUserEntity));

    // Act
    final result = await useCase(LoginParams(email: 'test@test.com', password: 'password'));

    // Assert
    expect(result, Right(tUserEntity));
    verify(mockRepo.login(email: 'test@test.com', password: 'password'));
  });
}
```

---

## Troubleshooting

### Common Issues

#### 1. Code Generation Fails
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2. Dependency Conflicts
```bash
flutter clean
flutter pub get
```

#### 3. iOS Build Issues
```bash
cd ios
pod install
cd ..
```

---

## Summary

This integration guide provides everything you need to:
- Use the existing design system
- Add new features following Clean Architecture
- Create new screens and widgets
- Integrate APIs
- Manage state with Bloc
- Test your code

For more details, see the main README.md file.
