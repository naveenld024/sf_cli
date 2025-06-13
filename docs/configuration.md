# Configuration Files

SF CLI supports configuration files to automate complex code generation tasks. This guide covers the different types of configuration files and how to use them effectively.

## Configuration Types

### 1. Simple Configuration

Used with `sf_cli config` command for basic model and API generation.

### 2. Enhanced Configuration

Used with `sf_cli generate-feature` command for complete feature generation with full architecture support.

## Simple Configuration

### Basic Structure

```json
{
  "model_name": {
    "model_class_relative_path": "path/to/model.json",
    "end_point": "/api/endpoint",
    "method": "get|post|put|delete",
    "function_name": "functionName",
    "parameters": {
      "param1": "type1",
      "param2": "type2"
    }
  }
}
```

### Example: User API Configuration

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
  "user_create": {
    "model_class_relative_path": "lib/features/user/domain/models/user.json",
    "end_point": "/api/users",
    "method": "post",
    "function_name": "createUser",
    "parameters": {
      "user": "User"
    }
  }
}
```

### Usage

```bash
sf_cli config --config-file simple_config.json
```

## Enhanced Configuration

### Complete Structure

```json
{
  "feature_name": "string",
  "description": "string (optional)",
  "models": [
    {
      "name": "string",
      "json_path": "string",
      "use_freezed": "boolean (optional)"
    }
  ],
  "api_endpoints": [
    {
      "name": "string",
      "method": "GET|POST|PUT|DELETE",
      "path": "string",
      "parameters": "object (optional)",
      "body": "string (optional)",
      "response_model": "string (optional)"
    }
  ],
  "state_management": {
    "type": "cubit|bloc",
    "use_freezed": "boolean",
    "states": ["string"] (optional)
  },
  "ui_components": {
    "generate_screen": "boolean",
    "generate_widgets": "boolean",
    "screen_type": "stateless|stateful"
  },
  "dependencies": ["string"] (optional)
}
```

### Example: Complete User Management Feature

```json
{
  "feature_name": "user_management",
  "description": "Complete user management feature with CRUD operations",
  "models": [
    {
      "name": "User",
      "json_path": "data/user.json",
      "use_freezed": true
    },
    {
      "name": "UserProfile",
      "json_path": "data/user_profile.json",
      "use_freezed": true
    }
  ],
  "api_endpoints": [
    {
      "name": "getUsers",
      "method": "GET",
      "path": "/api/users",
      "parameters": {
        "page": "int",
        "limit": "int",
        "search": "String?"
      },
      "response_model": "List<User>"
    },
    {
      "name": "getUser",
      "method": "GET",
      "path": "/api/users/{id}",
      "parameters": {
        "id": "int"
      },
      "response_model": "User"
    },
    {
      "name": "createUser",
      "method": "POST",
      "path": "/api/users",
      "body": "User",
      "response_model": "User"
    },
    {
      "name": "updateUser",
      "method": "PUT",
      "path": "/api/users/{id}",
      "parameters": {
        "id": "int"
      },
      "body": "User",
      "response_model": "User"
    },
    {
      "name": "deleteUser",
      "method": "DELETE",
      "path": "/api/users/{id}",
      "parameters": {
        "id": "int"
      }
    }
  ],
  "state_management": {
    "type": "cubit",
    "use_freezed": true,
    "states": ["initial", "loading", "loaded", "error", "creating", "updating", "deleting"]
  },
  "ui_components": {
    "generate_screen": true,
    "generate_widgets": true,
    "screen_type": "stateful"
  },
  "dependencies": [
    "http",
    "flutter_bloc",
    "freezed_annotation",
    "json_annotation"
  ]
}
```

### Usage

```bash
sf_cli generate-feature --config enhanced_config.json --freezed
```

## Configuration Schemas

### Model Configuration

```json
{
  "name": "User",                    // Model class name
  "json_path": "data/user.json",    // Path to JSON file
  "use_freezed": true               // Generate freezed model
}
```

### API Endpoint Configuration

```json
{
  "name": "getUsers",               // Function name
  "method": "GET",                  // HTTP method
  "path": "/api/users",            // API endpoint
  "parameters": {                   // Query parameters or path variables
    "page": "int",
    "limit": "int"
  },
  "body": "User",                   // Request body model (for POST/PUT)
  "response_model": "List<User>"    // Expected response model
}
```

### State Management Configuration

```json
{
  "type": "cubit",                  // cubit or bloc
  "use_freezed": true,             // Use freezed for states
  "states": [                       // Custom state names
    "initial",
    "loading", 
    "loaded",
    "error"
  ]
}
```

## Real-World Examples

### E-commerce Product Feature

```json
{
  "feature_name": "products",
  "description": "Product catalog with search and filtering",
  "models": [
    {
      "name": "Product",
      "json_path": "data/product.json",
      "use_freezed": true
    },
    {
      "name": "Category",
      "json_path": "data/category.json",
      "use_freezed": true
    },
    {
      "name": "ProductFilter",
      "json_path": "data/product_filter.json",
      "use_freezed": true
    }
  ],
  "api_endpoints": [
    {
      "name": "getProducts",
      "method": "GET",
      "path": "/api/products",
      "parameters": {
        "page": "int",
        "limit": "int",
        "category": "String?",
        "minPrice": "double?",
        "maxPrice": "double?"
      },
      "response_model": "List<Product>"
    },
    {
      "name": "searchProducts",
      "method": "GET",
      "path": "/api/products/search",
      "parameters": {
        "query": "String",
        "filters": "ProductFilter?"
      },
      "response_model": "List<Product>"
    }
  ],
  "state_management": {
    "type": "cubit",
    "use_freezed": true,
    "states": ["initial", "loading", "loaded", "searching", "filtered", "error"]
  },
  "ui_components": {
    "generate_screen": true,
    "generate_widgets": true,
    "screen_type": "stateful"
  }
}
```

### Authentication Feature

```json
{
  "feature_name": "authentication",
  "description": "User authentication with login, register, and password reset",
  "models": [
    {
      "name": "User",
      "json_path": "data/user.json",
      "use_freezed": true
    },
    {
      "name": "LoginRequest",
      "json_path": "data/login_request.json",
      "use_freezed": true
    },
    {
      "name": "RegisterRequest",
      "json_path": "data/register_request.json",
      "use_freezed": true
    },
    {
      "name": "AuthResponse",
      "json_path": "data/auth_response.json",
      "use_freezed": true
    }
  ],
  "api_endpoints": [
    {
      "name": "login",
      "method": "POST",
      "path": "/api/auth/login",
      "body": "LoginRequest",
      "response_model": "AuthResponse"
    },
    {
      "name": "register",
      "method": "POST",
      "path": "/api/auth/register",
      "body": "RegisterRequest",
      "response_model": "AuthResponse"
    },
    {
      "name": "logout",
      "method": "POST",
      "path": "/api/auth/logout"
    },
    {
      "name": "refreshToken",
      "method": "POST",
      "path": "/api/auth/refresh",
      "parameters": {
        "refreshToken": "String"
      },
      "response_model": "AuthResponse"
    }
  ],
  "state_management": {
    "type": "bloc",
    "use_freezed": true,
    "states": ["initial", "loading", "authenticated", "unauthenticated", "error"]
  },
  "ui_components": {
    "generate_screen": true,
    "generate_widgets": true,
    "screen_type": "stateful"
  }
}
```

## Best Practices

### 1. Naming Conventions

- Use snake_case for feature names
- Use PascalCase for model names
- Use camelCase for function names
- Use descriptive, meaningful names

### 2. File Organization

```
config/
├── features/
│   ├── authentication.json
│   ├── user_management.json
│   └── products.json
├── models/
│   ├── user.json
│   ├── product.json
│   └── category.json
└── simple/
    ├── api_config.json
    └── model_config.json
```

### 3. Model Design

- Keep JSON models simple and focused
- Use proper typing in JSON examples
- Include all required fields
- Consider optional fields with null values

### 4. API Design

- Follow RESTful conventions
- Use consistent parameter naming
- Include proper HTTP methods
- Define clear response models

### 5. State Management

- Choose cubit for simple state
- Choose bloc for complex event handling
- Always use freezed for immutability
- Define meaningful state names

## Validation

SF CLI validates configuration files and provides helpful error messages:

```bash
# Valid configuration
sf_cli generate-feature --config valid_config.json --freezed
✓ Configuration validated successfully
✓ Feature generated: user_management

# Invalid configuration
sf_cli generate-feature --config invalid_config.json --freezed
✗ Configuration validation failed:
  - Missing required field: feature_name
  - Invalid HTTP method: PATCH (use GET, POST, PUT, DELETE)
  - Model file not found: data/missing.json
```

## Next Steps

- [Simple Config Examples](configuration/simple-config.md)
- [Enhanced Config Examples](configuration/enhanced-config.md)
- [Advanced Configuration Patterns](examples/advanced-features.md)
