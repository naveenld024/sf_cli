# Basic Usage Examples

This page provides simple, practical examples to get you started with SF CLI quickly.

## Project Setup

### Creating a New Flutter Project with SF CLI

```bash
# Create a new Flutter project
flutter create my_awesome_app
cd my_awesome_app

# Initialize SF CLI structure
sf_cli init

# Your project now has a clean architecture structure!
```

**Result:** Your project will have the following structure:

```
lib/
├── features/
│   ├── auth/
│   └── splash/
├── shared/
│   ├── api/
│   ├── constants/
│   ├── themes/
│   └── utils/
└── main.dart
```

## Feature Generation

### Simple Feature

Generate a basic user profile feature:

```bash
sf_cli features --name user_profile
```

**What you get:**
- Complete feature folder structure
- Model, repository, and service files
- Cubit for state management
- Screen and widget templates
- Configuration file for customization

### Feature with Freezed (Recommended)

```bash
sf_cli features --name user_profile --freezed
```

**Benefits of using `--freezed`:**
- Immutable data classes
- Pattern matching with `when`/`maybeWhen`
- Automatic equality and hash code
- JSON serialization support

## Model Generation

### From JSON File

Create a `user.json` file:

```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30,
  "isActive": true,
  "profile": {
    "bio": "Flutter developer",
    "avatar": "https://example.com/avatar.jpg"
  },
  "skills": ["Flutter", "Dart", "Firebase"]
}
```

Generate the model:

```bash
sf_cli model --file user.json
```

**Generated model includes:**
- Proper Dart types
- Null safety support
- JSON serialization methods
- Nested object handling
- List/array support

## State Management

### Simple Cubit

For straightforward state management:

```bash
sf_cli cubit --name counter --freezed
```

**Use cases:**
- Form validation
- Simple data loading
- Toggle states
- Basic user interactions

### Complex Bloc

For event-driven state management:

```bash
sf_cli bloc --name authentication --freezed
```

**Use cases:**
- User authentication flows
- Complex business logic
- Multiple event types
- Advanced state transitions

## Build Process

### Running Code Generation

After creating freezed models or state management:

```bash
sf_cli runner
```

This runs `dart run build_runner build --delete-conflicting-outputs` with optimized settings.

## Common Workflows

### Workflow 1: API Integration

```bash
# 1. Create model from API response
echo '{
  "id": 1,
  "title": "Sample Post",
  "body": "This is a sample post",
  "userId": 1
}' > post.json

# 2. Generate model
sf_cli model --file post.json

# 3. Generate feature
sf_cli features --name posts --freezed

# 4. Generate state management
sf_cli cubit --name post_list --freezed

# 5. Run build runner
sf_cli runner
```

### Workflow 2: Form Handling

```bash
# 1. Create form data model
echo '{
  "name": "",
  "email": "",
  "phone": "",
  "message": ""
}' > contact_form.json

# 2. Generate model
sf_cli model --file contact_form.json

# 3. Generate feature
sf_cli features --name contact --freezed

# 4. Generate form cubit
sf_cli cubit --name contact_form --freezed

# 5. Build
sf_cli runner
```

### Workflow 3: User Management

```bash
# 1. Generate authentication feature
sf_cli features --name authentication --freezed

# 2. Generate user profile feature
sf_cli features --name user_profile --freezed

# 3. Generate settings feature
sf_cli features --name settings --freezed

# 4. Generate auth bloc for complex flows
sf_cli bloc --name auth_flow --freezed

# 5. Build everything
sf_cli runner
```

## Quick Tips

### 1. Always Use Freezed

```bash
# ✅ Recommended
sf_cli features --name my_feature --freezed
sf_cli cubit --name my_cubit --freezed

# ❌ Not recommended (unless you have specific reasons)
sf_cli features --name my_feature
sf_cli cubit --name my_cubit
```

### 2. Naming Conventions

```bash
# ✅ Good naming (snake_case)
sf_cli features --name user_profile
sf_cli cubit --name shopping_cart
sf_cli bloc --name payment_processing

# ❌ Bad naming
sf_cli features --name UserProfile
sf_cli cubit --name shopping-cart
sf_cli bloc --name paymentProcessing
```

### 3. Project Organization

Keep your features organized by domain:

```
lib/features/
├── authentication/     # User auth
├── user_profile/      # User management
├── products/          # Product catalog
├── shopping_cart/     # Cart functionality
├── orders/           # Order processing
└── settings/         # App settings
```

### 4. Model Design

Design your JSON models thoughtfully:

```json
{
  "id": 1,                    // Always include IDs
  "name": "John Doe",         // Use descriptive names
  "email": "john@example.com", // Include all required fields
  "createdAt": "2024-01-01T10:00:00Z", // Use proper date formats
  "isActive": true,           // Use boolean for flags
  "metadata": {               // Group related data
    "lastLogin": "2024-01-01T10:00:00Z",
    "loginCount": 5
  },
  "tags": ["user", "premium"] // Use arrays for lists
}
```

## Troubleshooting

### Common Issues

**Issue:** Command not found
```bash
# Solution: Make sure SF CLI is installed globally
dart pub global activate sf_cli
```

**Issue:** Build runner fails
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
sf_cli runner
```

**Issue:** Freezed files not generated
```bash
# Solution: Make sure you used --freezed flag and run build runner
sf_cli features --name my_feature --freezed
sf_cli runner
```

## Next Steps

Once you're comfortable with basic usage:

- [Advanced Features](advanced-features.md) - Complex scenarios and patterns
- [Enhanced Feature Generation](enhanced-features.md) - Configuration-based generation
- [Architecture Guide](../architecture.md) - Understanding the generated code structure
