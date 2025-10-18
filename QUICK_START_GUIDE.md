# Food Delivery App - Quick Start Guide

## Overview
This guide provides a quick reference for developers starting to implement the Food Delivery App based on the comprehensive architecture plan.

---

## Document Index

1. **ARCHITECTURE_PLAN.md** (66KB)
   - Complete folder structure
   - All 11 features with layer breakdown
   - Full pubspec.yaml
   - Dependency injection setup
   - Routing configuration
   - State management strategy
   - Data flow diagrams

2. **IMPLEMENTATION_ROADMAP.md** (17KB)
   - Phase-by-phase implementation guide (14 phases)
   - 15-week timeline
   - Testing checkpoints
   - Team structure recommendations
   - Risk mitigation strategies

3. **CLASS_DEFINITIONS.md** (32KB)
   - Detailed entity definitions
   - Model structures
   - Bloc states and events
   - Use case patterns
   - Validators and extensions
   - Constants

4. **QUICK_START_GUIDE.md** (this file)
   - Quick reference
   - Common commands
   - Key decisions

---

## Getting Started in 5 Steps

### Step 1: Review Architecture (30 minutes)
Read these sections from ARCHITECTURE_PLAN.md:
- Section 1: Complete folder structure
- Section 3: pubspec.yaml
- Section 5: Routing structure
- Section 6: State management strategy

### Step 2: Setup Project (2 hours)
Follow Phase 0 from IMPLEMENTATION_ROADMAP.md:
```bash
# Create Flutter project
flutter create food_delivery_app
cd food_delivery_app

# Copy pubspec.yaml from ARCHITECTURE_PLAN.md
# Then run:
flutter pub get
```

Create folder structure:
```bash
mkdir -p lib/core/{constants,theme,utils,routes,network,errors,services}
mkdir -p lib/features
mkdir -p lib/shared/widgets/{buttons,inputs,cards,loading,dialogs,app_bars,navigation,common}
mkdir -p lib/config
mkdir -p assets/{images,fonts,animations}
```

### Step 3: Setup Core Infrastructure (4 hours)
Implement these core files (see ARCHITECTURE_PLAN Section 8):
- core/constants/app_colors.dart
- core/constants/app_strings.dart
- core/constants/api_constants.dart
- core/theme/app_theme.dart
- core/network/api_client.dart
- core/errors/failures.dart
- core/errors/exceptions.dart
- config/dependency_injection.dart
- config/environment_config.dart

### Step 4: Implement Authentication (1 week)
Follow Phase 1 from IMPLEMENTATION_ROADMAP.md:
- Use CLASS_DEFINITIONS.md for entity/model structures
- Implement domain layer first
- Then data layer
- Finally presentation layer

### Step 5: Continue with Roadmap
Follow phases 2-14 from IMPLEMENTATION_ROADMAP.md sequentially.

---

## Key Architecture Decisions

### Clean Architecture Layers
```
Presentation Layer (UI, Bloc, Pages, Widgets)
      ↓
Domain Layer (Entities, Repositories Interface, Use Cases)
      ↓
Data Layer (Models, Data Sources, Repository Implementation)
```

**Rule:** Dependencies flow inward. Domain layer has NO dependencies on other layers.

### State Management: Bloc Pattern
- Global Blocs: AuthBloc, CartBloc, NotificationsBloc
- Feature Blocs: Scoped to feature/screen
- Events trigger actions
- States represent UI state
- Use cases handle business logic

### Data Flow
```
User Action → Event → Bloc → Use Case → Repository → Data Source → API/Local Storage
                ↓
            New State → UI Update
```

### Local Storage Strategy
- **Hive:** Cart, Favorites, Recent Searches, Cached Data
- **SharedPreferences:** Tokens, Settings, Flags
- **Reason:** Hive for complex objects, SharedPreferences for simple key-values

### Error Handling
- Exceptions thrown at data layer
- Converted to Failures in repository
- Returned as Either<Failure, Success>
- Bloc emits error states
- UI shows error widgets

---

## Common Commands

### Development
```bash
# Run app
flutter run

# Run with flavor
flutter run --flavor dev -t lib/main_dev.dart

# Hot reload
Press 'r' in terminal

# Hot restart
Press 'R' in terminal
```

### Code Generation
```bash
# Generate code (models, DI, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/unit/features/authentication/usecases/login_usecase_test.dart

# Run with coverage
flutter test --coverage

# View coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Build
```bash
# Build APK
flutter build apk --release

# Build AAB (for Play Store)
flutter build appbundle --release

# Build iOS
flutter build ios --release
```

### Clean & Reset
```bash
# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Reset everything
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Project Structure Quick Reference

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core functionality
│   ├── constants/                     # App-wide constants
│   ├── theme/                         # Theming
│   ├── utils/                         # Utilities
│   ├── routes/                        # Routing
│   ├── network/                       # API client
│   ├── errors/                        # Error handling
│   └── services/                      # Core services
├── features/                          # Feature modules
│   └── [feature_name]/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
├── shared/                            # Shared widgets
│   └── widgets/
└── config/                            # Configuration
    ├── dependency_injection.dart
    ├── environment_config.dart
    └── hive_config.dart
```

---

## Feature Implementation Checklist

When implementing a new feature, follow this checklist:

### 1. Domain Layer
- [ ] Define entities (pure Dart classes)
- [ ] Create repository interface (abstract class)
- [ ] Implement use cases (one per action)
- [ ] Add tests for use cases

### 2. Data Layer
- [ ] Create models extending entities
- [ ] Add JSON serialization (@JsonSerializable)
- [ ] Implement local data source (if needed)
- [ ] Implement remote data source
- [ ] Implement repository (implements domain interface)
- [ ] Add tests for repository

### 3. Presentation Layer
- [ ] Define events (user actions)
- [ ] Define states (UI states)
- [ ] Implement Bloc (event handlers)
- [ ] Create pages/screens
- [ ] Create widgets
- [ ] Add tests for Bloc
- [ ] Add widget tests

### 4. Integration
- [ ] Register in dependency injection
- [ ] Add routes
- [ ] Connect to other features
- [ ] Test end-to-end flow

### 5. Polish
- [ ] Add loading states
- [ ] Add error handling
- [ ] Add empty states
- [ ] Add animations
- [ ] Optimize performance
- [ ] Add documentation

---

## Dependency Injection Pattern

### Register in DI (using injectable)

```dart
// Data Source
@lazySingleton
class AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSource(this.apiClient);
}

// Repository
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource, this.networkInfo);
}

// Use Case
@lazySingleton
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);
}

// Bloc
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  AuthBloc(this.loginUseCase) : super(AuthInitial());
}
```

### Access in UI

```dart
// Get from DI container
final authBloc = getIt<AuthBloc>();

// Or use BlocProvider
BlocProvider(
  create: (context) => getIt<AuthBloc>(),
  child: LoginScreen(),
)
```

---

## Bloc Implementation Pattern

### 1. Define Events
```dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
}

class LoadData extends FeatureEvent {
  @override
  List<Object?> get props => [];
}
```

### 2. Define States
```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final Data data;
  const FeatureLoaded(this.data);
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
}
```

### 3. Implement Bloc
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final UseCase useCase;

  FeatureBloc(this.useCase) : super(FeatureInitial()) {
    on<LoadData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadData event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    final result = await useCase(NoParams());
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureLoaded(data)),
    );
  }
}
```

### 4. Use in UI
```dart
BlocBuilder<FeatureBloc, FeatureState>(
  builder: (context, state) {
    if (state is FeatureLoading) {
      return LoadingIndicator();
    } else if (state is FeatureLoaded) {
      return DataWidget(state.data);
    } else if (state is FeatureError) {
      return ErrorWidget(state.message);
    }
    return SizedBox();
  },
)
```

---

## API Integration Pattern

### 1. Define Endpoint
```dart
// core/network/api_endpoints.dart
class ApiEndpoints {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const restaurants = '/restaurants';
}
```

### 2. Create Remote Data Source
```dart
@lazySingleton
class RestaurantsRemoteDataSource {
  final ApiClient apiClient;

  RestaurantsRemoteDataSource(this.apiClient);

  Future<List<RestaurantModel>> getRestaurants() async {
    final response = await apiClient.get(ApiEndpoints.restaurants);
    return (response.data['data'] as List)
        .map((json) => RestaurantModel.fromJson(json))
        .toList();
  }
}
```

### 3. Use in Repository
```dart
@LazySingleton(as: RestaurantsRepository)
class RestaurantsRepositoryImpl implements RestaurantsRepository {
  final RestaurantsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RestaurantsRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final restaurants = await remoteDataSource.getRestaurants();
      return Right(restaurants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

---

## Testing Patterns

### Unit Test (Use Case)
```dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('should return user when login is successful', () async {
    // Arrange
    final user = UserEntity(id: '1', name: 'John', email: 'john@example.com');
    when(mockRepository.login(any, any)).thenAnswer((_) async => Right(user));

    // Act
    final result = await useCase(LoginParams(email: 'test@test.com', password: 'password'));

    // Assert
    expect(result, Right(user));
    verify(mockRepository.login('test@test.com', 'password'));
  });
}
```

### Bloc Test
```dart
void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authBloc = AuthBloc(mockLoginUseCase);
  });

  blocTest<AuthBloc, AuthState>(
    'emits [Loading, Authenticated] when login is successful',
    build: () {
      when(mockLoginUseCase(any)).thenAnswer((_) async => Right(user));
      return authBloc;
    },
    act: (bloc) => bloc.add(LoginEvent('test@test.com', 'password')),
    expect: () => [
      AuthLoading(),
      Authenticated(user),
    ],
  );
}
```

### Widget Test
```dart
void main() {
  testWidgets('LoginScreen should display email and password fields', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });
}
```

---

## Common Issues & Solutions

### Issue: Build runner fails
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: DI not working
**Solution:**
- Check if @injectable/@lazySingleton annotations are added
- Run build_runner to generate code
- Import the generated file: `import 'dependency_injection.config.dart';`
- Call `getIt.init()` in main.dart

### Issue: Hive type not found
**Solution:**
- Add @HiveType annotation to model
- Run build_runner to generate adapter
- Register adapter in main.dart: `Hive.registerAdapter(ModelAdapter());`

### Issue: JSON serialization error
**Solution:**
- Add @JsonSerializable() annotation
- Run build_runner
- Import generated file: `part 'model.g.dart';`

### Issue: Route not found
**Solution:**
- Check route is defined in app_router.dart
- Check route name matches in route_names.dart
- Use context.go() or context.push() with correct route

---

## Performance Best Practices

1. **Use const constructors** wherever possible
2. **Implement ListView.builder** for long lists
3. **Use cached_network_image** for images
4. **Avoid rebuilding entire tree** - use BlocSelector
5. **Implement pagination** for API calls
6. **Cache data locally** with Hive
7. **Use Equatable** for efficient comparisons
8. **Dispose controllers** properly
9. **Use DevTools** to profile performance
10. **Lazy load** features when needed

---

## Git Workflow

### Branch Strategy
```
main (production)
├── develop (development)
    ├── feature/authentication
    ├── feature/restaurants
    ├── feature/cart
    └── bugfix/fix-login-issue
```

### Commit Messages
```
feat: add authentication feature
fix: resolve login validation issue
refactor: improve restaurant card widget
test: add unit tests for cart use cases
docs: update architecture documentation
style: format code according to style guide
```

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Refactoring
- [ ] Documentation

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings
```

---

## Resources

### Official Documentation
- Flutter: https://docs.flutter.dev/
- Dart: https://dart.dev/guides
- Bloc: https://bloclibrary.dev/
- go_router: https://pub.dev/packages/go_router
- Hive: https://docs.hivedb.dev/

### Community Resources
- Flutter Community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- r/FlutterDev: https://www.reddit.com/r/FlutterDev/

### Design Resources
- Material Design 3: https://m3.material.io/
- Flutter UI Kits: https://flutterawesome.com/
- Icons: https://fonts.google.com/icons

---

## Next Steps

1. **Review all documentation files** (2-3 hours)
2. **Set up development environment** (1 hour)
3. **Create project and folder structure** (1 hour)
4. **Implement core infrastructure** (4 hours)
5. **Start with Authentication feature** (1 week)
6. **Follow the implementation roadmap** (3-4 months)

---

## Support & Maintenance

### Before Implementation
- [ ] Review all architecture documents
- [ ] Understand Clean Architecture principles
- [ ] Understand Bloc pattern
- [ ] Set up development environment

### During Implementation
- [ ] Follow implementation roadmap
- [ ] Write tests alongside code
- [ ] Document complex logic
- [ ] Review code regularly

### After Launch
- [ ] Monitor analytics
- [ ] Track crashes
- [ ] Collect user feedback
- [ ] Plan iterations

---

## Contact & Updates

For questions or updates to this architecture:
- Review documents in this directory
- Check Flutter official docs
- Consult Clean Architecture resources
- Follow Bloc library documentation

---

**Last Updated:** October 2025
**Version:** 1.0
**Status:** Ready for Implementation

**Good luck with your Food Delivery App development!**
