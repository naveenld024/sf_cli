# Architecture Overview

SF CLI promotes clean, scalable architecture patterns that are widely adopted in the Flutter community. This guide explains the architectural decisions and patterns used in generated code.

## Core Principles

### 1. Clean Architecture

SF CLI follows Uncle Bob's Clean Architecture principles:

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Testability**: Each layer can be tested independently
- **Maintainability**: Code is organized and easy to modify

### 2. Feature-Based Organization

Instead of organizing by technical layers, SF CLI organizes by business features:

```
lib/features/
├── authentication/
├── user_profile/
├── products/
└── orders/
```

This approach provides:
- Better code locality
- Easier team collaboration
- Clearer business domain boundaries
- Simplified testing strategies

## Architecture Layers

### Domain Layer

The domain layer contains the core business logic and is independent of external frameworks.

```
domain/
├── models/          # Data models
├── repository/      # Repository interfaces
└── services/        # Business logic services
```

**Models**: Pure Dart classes representing business entities
- No dependencies on Flutter or external packages
- Immutable data structures (using Freezed)
- JSON serialization support

**Repository**: Abstract interfaces defining data access contracts
- Define what data operations are needed
- Independent of data source implementation
- Enable easy testing with mocks

**Services**: Business logic and use cases
- Coordinate between repositories
- Implement business rules
- Handle complex operations

### Logic Layer

The logic layer manages application state using the BLoC pattern.

```
logic/
├── cubit/          # Simple state management
└── bloc/           # Complex event-driven state
```

**Cubit**: For simple state management
- Direct state mutations
- Easier to understand and implement
- Perfect for forms, toggles, simple data loading

**Bloc**: For complex state management
- Event-driven architecture
- Better for complex business logic
- Handles multiple event types
- More predictable state transitions

### Presentation Layer

The presentation layer contains UI components and user interactions.

```
screens/            # Full-screen widgets
widgets/            # Reusable UI components
```

**Screens**: Complete page implementations
- Coordinate multiple widgets
- Handle navigation
- Connect to state management

**Widgets**: Reusable UI components
- Single responsibility
- Composable and testable
- Independent of business logic

## State Management Architecture

### BLoC Pattern

SF CLI uses the BLoC (Business Logic Component) pattern for state management:

```dart
// State classes
abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// Cubit implementation
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;
  
  UserCubit(this.repository) : super(UserInitial());
  
  Future<void> loadUser(int id) async {
    emit(UserLoading());
    try {
      final user = await repository.getUser(id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

### Freezed Integration

When using the `--freezed` flag, SF CLI generates immutable state classes:

```dart
@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserInitial;
  const factory UserState.loading() = UserLoading;
  const factory UserState.loaded(User user) = UserLoaded;
  const factory UserState.error(String message) = UserError;
}
```

Benefits of Freezed:
- Immutable data structures
- Pattern matching with `when` and `maybeWhen`
- Automatic equality and hash code
- Copy with modifications
- JSON serialization support

## Data Flow

### Unidirectional Data Flow

```
UI Widget → Cubit/Bloc → Repository → Service → API
    ↑                                              ↓
    └── State Updates ←── State Changes ←── Data ←┘
```

1. **UI triggers action**: User interaction calls cubit method
2. **Cubit processes**: Business logic and state updates
3. **Repository called**: Data access through repository interface
4. **Service executes**: External API calls or data processing
5. **State updated**: New state emitted to UI
6. **UI rebuilds**: Widget tree updates based on new state

### Example Flow

```dart
// 1. UI triggers action
onPressed: () => context.read<UserCubit>().loadUser(userId)

// 2. Cubit processes
Future<void> loadUser(int id) async {
  emit(UserLoading());
  
  // 3. Repository called
  try {
    final user = await repository.getUser(id);
    
    // 5. State updated
    emit(UserLoaded(user));
  } catch (e) {
    emit(UserError(e.toString()));
  }
}

// 6. UI rebuilds
BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    return state.when(
      initial: () => Text('Press to load'),
      loading: () => CircularProgressIndicator(),
      loaded: (user) => Text(user.name),
      error: (message) => Text('Error: $message'),
    );
  },
)
```

## Dependency Injection

SF CLI promotes dependency injection for better testability:

```dart
// Repository interface
abstract class UserRepository {
  Future<User> getUser(int id);
}

// Implementation
class ApiUserRepository implements UserRepository {
  final ApiService apiService;
  
  ApiUserRepository(this.apiService);
  
  @override
  Future<User> getUser(int id) async {
    final response = await apiService.get('/users/$id');
    return User.fromJson(response.data);
  }
}

// Cubit with dependency
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;
  
  UserCubit(this.repository) : super(UserInitial());
}
```

## Testing Architecture

The generated architecture is designed for easy testing:

### Unit Testing

```dart
// Test cubit with mock repository
void main() {
  late UserCubit cubit;
  late MockUserRepository mockRepository;
  
  setUp(() {
    mockRepository = MockUserRepository();
    cubit = UserCubit(mockRepository);
  });
  
  test('should emit loaded state when user is fetched', () async {
    // Arrange
    final user = User(id: 1, name: 'John');
    when(() => mockRepository.getUser(1))
        .thenAnswer((_) async => user);
    
    // Act
    cubit.loadUser(1);
    
    // Assert
    await expectLater(
      cubit.stream,
      emitsInOrder([UserLoading(), UserLoaded(user)]),
    );
  });
}
```

### Widget Testing

```dart
testWidgets('should display user name when loaded', (tester) async {
  // Arrange
  final cubit = MockUserCubit();
  when(() => cubit.state).thenReturn(UserLoaded(User(name: 'John')));
  
  // Act
  await tester.pumpWidget(
    BlocProvider.value(
      value: cubit,
      child: UserScreen(),
    ),
  );
  
  // Assert
  expect(find.text('John'), findsOneWidget);
});
```

## Best Practices

### 1. Keep Layers Separate

- Domain layer should not depend on Flutter
- Logic layer should not contain UI code
- Presentation layer should not contain business logic

### 2. Use Interfaces

- Define repository interfaces in domain layer
- Implement interfaces in infrastructure layer
- Enable easy mocking for tests

### 3. Immutable State

- Always use immutable state classes
- Use Freezed for automatic immutability
- Avoid mutable state in BLoC/Cubit

### 4. Single Responsibility

- Each class should have one reason to change
- Keep methods focused and small
- Separate concerns clearly

### 5. Error Handling

- Handle errors at appropriate layers
- Use typed error states
- Provide meaningful error messages

## Advanced Patterns

### Repository Pattern

```dart
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(int id);
}
```

### Service Layer

```dart
class UserService {
  final UserRepository repository;
  final CacheService cache;
  final AnalyticsService analytics;
  
  UserService(this.repository, this.cache, this.analytics);
  
  Future<User> getUser(int id) async {
    // Check cache first
    final cached = await cache.getUser(id);
    if (cached != null) return cached;
    
    // Fetch from repository
    final user = await repository.getUser(id);
    
    // Cache result
    await cache.setUser(user);
    
    // Track analytics
    analytics.track('user_loaded', {'user_id': id});
    
    return user;
  }
}
```

## Next Steps

- [Clean Architecture Details](architecture/clean-architecture.md)
- [BLoC Pattern Deep Dive](architecture/bloc-pattern.md)
- [Freezed Integration Guide](architecture/freezed.md)
