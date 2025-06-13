# Enhanced Feature Generation from Configuration

This document explains how to use the new enhanced feature generation capability that automatically creates complete feature folders based on comprehensive configuration files.

## Overview

The `generate-feature` command allows you to create complete, production-ready feature implementations by simply providing a configuration file. This is inspired by the existing news feature structure and follows the same clean architecture patterns.

## Command Usage

```bash
# Generate feature with freezed models and state management (recommended)
sf_cli generate-feature --config path/to/feature_config.json --freezed

# Generate feature with regular models and state management
sf_cli generate-feature --config path/to/feature_config.json

# Short form
sf_cli generate-feature -c path/to/feature_config.json --freezed
```

## Configuration Schema

The enhanced configuration file supports the following structure:

```json
{
  "feature_name": "your_feature_name",
  "description": "Description of your feature",
  "models": [
    {
      "name": "model_name",
      "json_file_path": "path/to/model.json",
      "use_freezed": true
    }
  ],
  "endpoints": [
    {
      "name": "endpoint_identifier",
      "endpoint": "/api/endpoint",
      "method": "GET|POST|PUT|DELETE",
      "function_name": "functionName",
      "parameters": {
        "param_name": "param_type"
      },
      "return_type": "ResponseResult<ModelType>"
    }
  ],
  "ui_config": {
    "has_list_screen": true,
    "has_detail_screen": false,
    "has_form_screen": false,
    "custom_widgets": ["widget1", "widget2"]
  }
}
```

## Generated Structure

When you run the command, it generates a complete feature following this structure:

```
lib/features/{feature_name}/
├── domain/
│   ├── models/
│   │   ├── {model_name}_response.dart (freezed)
│   │   ├── {model_name}_response.freezed.dart
│   │   └── {model_name}_response.g.dart
│   ├── repository/
│   │   └── {feature_name}_repository.dart
│   └── services/
│       └── {feature_name}_service.dart
├── logic/{feature_name}/
│   ├── {feature_name}_cubit.dart
│   ├── {feature_name}_state.dart
│   └── {feature_name}_cubit.freezed.dart (if freezed)
├── screens/
│   ├── {feature_name}_screen.dart
│   ├── {feature_name}_detail_screen.dart (optional)
│   └── {feature_name}_form_screen.dart (optional)
└── widgets/
    └── {feature_name}_widget.dart
```

## Features

### 1. **Freezed Models**
- Automatically generates immutable models with freezed
- Includes JSON serialization/deserialization
- Type-safe and null-safe implementations

### 2. **Repository Pattern**
- Abstract repository interface
- Concrete service implementation with dependency injection
- Proper error handling with ResponseResult

### 3. **State Management**
- Choice between freezed and regular cubit implementations
- Proper state handling (loading, success, error)
- Injectable cubits for dependency injection

### 4. **UI Components**
- Main screen with BLoC integration
- Optional detail and form screens
- Reusable widget components
- Proper error and loading states

### 5. **API Integration**
- Service methods based on endpoint configuration
- Proper HTTP method handling
- Error handling and response parsing

## Example Configuration

See `example/enhanced_feature_config.json` for a complete example that generates a product catalog feature with:

- Product and Category models
- Multiple API endpoints (list, details, search, create)
- List, detail, and form screens
- Custom widgets

## Comparison with News Feature

The generated code follows the exact same patterns as the existing news feature:

| Component | News Feature | Generated Feature |
|-----------|--------------|-------------------|
| Models | `NewsItem`, `NewsItemData` (freezed) | Generated from JSON with freezed |
| Repository | `NewsRepository` (abstract) | Generated abstract repository |
| Service | `NewsService` (injectable) | Generated injectable service |
| Cubit | `NewsCubit` with injectable DI | Generated cubit with DI |
| State | Freezed state with DataStatus | Generated freezed/regular state |
| Screen | `NewsDetailsScreen` with BLoC | Generated screen with BLoC |

## Best Practices

1. **JSON Structure**: Ensure your JSON files represent the actual API response structure
2. **Naming**: Use snake_case for feature names and model names
3. **Endpoints**: Define all necessary API endpoints in the configuration
4. **UI Config**: Specify which screens you need to avoid generating unnecessary files
5. **Freezed**: Use freezed for better immutability and code generation
6. **Build Runner**: Always run `sf_cli runner` after generation to build freezed files

## Workflow

1. Create JSON files for your models (see `example/models/`)
2. Create an enhanced configuration file
3. Run the generate-feature command
4. Run build runner to generate freezed files
5. Customize the generated code as needed
6. Add proper imports and dependencies

## Migration from Basic Config

If you have existing basic config files, you can enhance them by:

1. Wrapping the existing configuration in the new schema
2. Adding feature metadata (name, description)
3. Specifying UI requirements
4. Adding model configurations

This enhanced feature generation significantly reduces boilerplate code and ensures consistency across your application features.
