# Quick Start

This guide will help you get started with SF CLI in just a few minutes.

## Prerequisites

Make sure you have SF CLI installed. If not, follow the [Installation Guide](installation.md).

## Your First Project

### 1. Initialize a New Flutter Project

First, create a new Flutter project or navigate to an existing one:

```bash
flutter create my_app
cd my_app
```

### 2. Initialize SF CLI Structure

Set up the recommended folder structure:

```bash
sf_cli init
```

This creates a comprehensive folder structure including:
- Feature-based architecture (auth, splash)
- Shared components (API, constants, themes, utils)
- Clean architecture layers (domain, logic, screens, widgets)

### 3. Generate Your First Feature

Create a complete feature with all necessary files:

```bash
sf_cli features --name user_profile --freezed
```

This generates:
```
lib/features/user_profile/
├── domain/
│   ├── models/user_profile_model.dart
│   ├── repository/user_profile_repository.dart
│   └── services/user_profile_service.dart
├── logic/user_profile/
│   ├── user_profile_cubit.dart
│   └── user_profile_state.dart
├── screens/user_profile_screen.dart
├── widgets/user_profile_widget.dart
└── user_profile_config.json
```

### 4. Generate a Model from JSON

Create a JSON file with your data structure:

```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "profile": {
    "age": 30,
    "preferences": ["coding", "reading"]
  }
}
```

Generate the Dart model:

```bash
sf_cli model --file path/to/your/model.json
```

### 5. Generate State Management

Create a cubit for state management:

```bash
sf_cli cubit --name authentication --freezed
```

Or create a full BLoC:

```bash
sf_cli bloc --name authentication --freezed
```

### 6. Run Build Runner

After generating freezed models, run the build runner:

```bash
sf_cli runner
```

## Common Workflows

### Feature Development Workflow

1. **Plan your feature**: Identify the data models and business logic needed
2. **Generate feature structure**: `sf_cli features --name my_feature --freezed`
3. **Create models**: Use `sf_cli model` or edit the generated model files
4. **Implement business logic**: Add your logic to the repository and service files
5. **Build UI**: Implement your screens and widgets
6. **Run build runner**: `sf_cli runner` to generate code
7. **Test**: Write and run tests for your feature

### Model-First Development

1. **Design your JSON structure**: Create sample JSON files
2. **Generate models**: `sf_cli model --file your_model.json`
3. **Generate feature**: `sf_cli features --name your_feature --freezed`
4. **Integrate models**: Move generated models to the feature structure
5. **Implement logic**: Add business logic using the generated models

## Best Practices

### Use Freezed for Immutability

Always use the `--freezed` flag when generating features, cubits, or blocs:

```bash
sf_cli features --name my_feature --freezed
sf_cli cubit --name my_cubit --freezed
sf_cli bloc --name my_bloc --freezed
```

### Organize by Features

Keep related functionality together in feature folders:

```
lib/features/
├── authentication/
├── user_profile/
├── settings/
└── dashboard/
```

### Use Configuration Files

For complex features, use enhanced configuration files:

```bash
sf_cli generate-feature --config enhanced_config.json --freezed
```

## Next Steps

Now that you've got the basics down, explore:

- [Complete Command Reference](commands.md)
- [Advanced Examples](examples.md)
- [Architecture Patterns](architecture.md)
- [Configuration Files](configuration.md)

## Need Help?

- Check the [Examples](examples.md) for more detailed use cases
- Review the [Command Reference](commands.md) for all available options
- Visit the [GitHub repository](https://github.com/naveenld024/sf_cli) for issues and discussions
