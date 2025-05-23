# SF CLI Examples

This directory contains examples demonstrating how to use SF CLI effectively.

## Example 1: Creating a User Management Feature

```bash
# Generate a complete user feature
sf_cli features --name user_management
```

This creates:
- Domain models and repositories
- BLoC cubit for state management
- Screen and widget templates
- Configuration file for API integration

## Example 2: Model Generation from JSON

Create a file `user.json`:
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "profile": {
    "firstName": "John",
    "lastName": "Doe",
    "age": 30,
    "preferences": ["coding", "reading", "gaming"]
  },
  "isActive": true
}
```

Generate the model:
```bash
sf_cli model --file user.json
```

## Example 3: Configuration-based Generation

Create `config.json`:
```json
{
  "user_model": {
    "model_class_relative_path": "lib/features/user/domain/models/user.json",
    "end_point": "/api/users",
    "method": "get",
    "function_name": "getUsers",
    "parameters": {
      "page": "int",
      "limit": "int"
    }
  },
  "product_model": {
    "model_class_relative_path": "lib/features/product/domain/models/product.json",
    "end_point": "/api/products",
    "method": "post",
    "function_name": "createProduct",
    "parameters": {
      "name": "String",
      "price": "double"
    }
  }
}
```

Generate from config:
```bash
sf_cli config --config-file config.json
```

## Example 4: Complete Project Setup

```bash
# Initialize project structure
sf_cli init

# Create authentication feature
sf_cli features --name authentication

# Create product catalog feature
sf_cli features --name product_catalog

# Generate models from JSON files
sf_cli model --file models/user.json
sf_cli model --file models/product.json

# Run build runner for code generation
sf_cli runner
```

## Best Practices

1. **Feature Naming**: Use snake_case for feature names
2. **JSON Structure**: Ensure your JSON files represent the actual API response structure
3. **Configuration**: Use configuration files for batch operations
4. **Build Runner**: Always run after generating models that use code generation
