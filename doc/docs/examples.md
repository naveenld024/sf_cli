# Examples & Tutorials

This section provides practical examples and step-by-step tutorials for using SF CLI effectively in your Flutter projects.

## Quick Examples

### Basic Feature Generation

Generate a simple user profile feature:

```bash
sf_cli features --name user_profile --freezed
```

### Model from JSON

Create a model from a JSON API response:

```bash
# Create user.json
echo '{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "profile": {
    "age": 30,
    "bio": "Flutter developer"
  }
}' > user.json

# Generate model
sf_cli model --file user.json
```

### Complete Workflow

```bash
# 1. Initialize project structure
sf_cli init

# 2. Generate authentication feature
sf_cli features --name authentication --freezed

# 3. Generate user management feature
sf_cli features --name user_management --freezed

# 4. Run build runner
sf_cli runner
```

## Detailed Tutorials

### Tutorial 1: Building a Todo App

Let's build a complete todo application using SF CLI.

#### Step 1: Project Setup

```bash
# Create new Flutter project
flutter create todo_app
cd todo_app

# Initialize SF CLI structure
sf_cli init
```

#### Step 2: Create Todo Model

Create `todo.json`:

```json
{
  "id": 1,
  "title": "Complete Flutter app",
  "description": "Build a todo app using SF CLI",
  "isCompleted": false,
  "createdAt": "2024-01-01T10:00:00Z",
  "priority": "high"
}
```

Generate the model:

```bash
sf_cli model --file todo.json
```

#### Step 3: Generate Todo Feature

```bash
sf_cli features --name todo --freezed
```

#### Step 4: Generate State Management

```bash
sf_cli cubit --name todo_list --freezed
```

#### Step 5: Build and Test

```bash
sf_cli runner
flutter test
```

### Tutorial 2: E-commerce App Structure

#### Step 1: Initialize Project

```bash
flutter create ecommerce_app
cd ecommerce_app
sf_cli init
```

#### Step 2: Generate Core Features

```bash
# Authentication
sf_cli features --name authentication --freezed

# Product catalog
sf_cli features --name products --freezed

# Shopping cart
sf_cli features --name cart --freezed

# User profile
sf_cli features --name profile --freezed

# Orders
sf_cli features --name orders --freezed
```

#### Step 3: Create Product Model

Create `product.json`:

```json
{
  "id": 1,
  "name": "Flutter T-Shirt",
  "description": "Comfortable cotton t-shirt",
  "price": 29.99,
  "currency": "USD",
  "images": ["image1.jpg", "image2.jpg"],
  "category": {
    "id": 1,
    "name": "Clothing"
  },
  "variants": [
    {
      "id": 1,
      "size": "M",
      "color": "Blue",
      "stock": 10
    }
  ]
}
```

```bash
sf_cli model --file product.json
```

#### Step 4: Generate Additional State Management

```bash
sf_cli cubit --name product_search --freezed
sf_cli cubit --name cart_management --freezed
sf_cli bloc --name order_processing --freezed
```

#### Step 5: Build

```bash
sf_cli runner
```

### Tutorial 3: Enhanced Feature Generation

Using configuration files for complex features.

#### Step 1: Create Enhanced Configuration

Create `user_feature_config.json`:

```json
{
  "feature_name": "user_management",
  "models": [
    {
      "name": "User",
      "json_path": "data/user.json"
    },
    {
      "name": "UserProfile",
      "json_path": "data/user_profile.json"
    }
  ],
  "api_endpoints": [
    {
      "name": "getUsers",
      "method": "GET",
      "path": "/api/users",
      "parameters": {
        "page": "int",
        "limit": "int"
      }
    },
    {
      "name": "createUser",
      "method": "POST",
      "path": "/api/users",
      "body": "User"
    }
  ],
  "state_management": {
    "type": "cubit",
    "use_freezed": true
  }
}
```

#### Step 2: Generate Feature

```bash
sf_cli generate-feature --config user_feature_config.json --freezed
```

## Real-World Examples

### Social Media App

```bash
# Core features
sf_cli features --name authentication --freezed
sf_cli features --name user_profile --freezed
sf_cli features --name posts --freezed
sf_cli features --name comments --freezed
sf_cli features --name messaging --freezed

# Additional state management
sf_cli cubit --name feed --freezed
sf_cli cubit --name notifications --freezed
sf_cli bloc --name real_time_updates --freezed
```

### News App

```bash
# Features
sf_cli features --name news --freezed
sf_cli features --name categories --freezed
sf_cli features --name bookmarks --freezed
sf_cli features --name search --freezed

# Models from API
sf_cli model --file news_article.json
sf_cli model --file category.json
```

### Banking App

```bash
# Secure features
sf_cli features --name authentication --freezed
sf_cli features --name accounts --freezed
sf_cli features --name transactions --freezed
sf_cli features --name transfers --freezed
sf_cli features --name settings --freezed

# Complex state management
sf_cli bloc --name transaction_processing --freezed
sf_cli cubit --name account_balance --freezed
```

## Best Practices from Examples

### 1. Feature Organization

```
lib/features/
├── core/           # Shared across features
├── authentication/ # User auth
├── user_profile/   # User management
├── products/       # Product catalog
└── orders/         # Order processing
```

### 2. Model Design

- Use descriptive property names
- Include proper typing in JSON
- Consider nested objects for complex data
- Plan for null safety

### 3. State Management

- Use cubits for simple state
- Use blocs for complex event handling
- Always use freezed for immutability
- Separate concerns properly

### 4. Configuration Files

- Use enhanced configs for complex features
- Keep configurations version controlled
- Document configuration schemas
- Use meaningful naming conventions

## Common Patterns

### API Integration Pattern

```bash
# 1. Create model from API response
sf_cli model --file api_response.json

# 2. Generate feature with repository
sf_cli features --name api_feature --freezed

# 3. Add state management
sf_cli cubit --name api_data --freezed

# 4. Build
sf_cli runner
```

### Form Handling Pattern

```bash
# 1. Create form data model
sf_cli model --file form_data.json

# 2. Generate form feature
sf_cli features --name user_form --freezed

# 3. Add form state management
sf_cli cubit --name form_validation --freezed
```

## Next Steps

- [Architecture Patterns](architecture.md) - Learn about the generated architecture
- [Configuration Guide](configuration.md) - Master configuration files
- [Advanced Features](examples/advanced-features.md) - Explore advanced use cases
