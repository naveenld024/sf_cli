# SF CLI - Flutter Scaffolding Tool
[![pub package](https://img.shields.io/pub/v/sf_cli.svg)](https://pub.dev/packages/sf_cli)
A powerful command-line interface tool for Flutter developers that automates the creation of feature-based project structures, model generation from JSON, and BLoC pattern implementation.

## Features

- 🏗️ **Feature Scaffolding**: Generate complete feature structures with feature folder structures
- 📱 **Project Initialization**: Set up Flutter projects with predefined folder structures
- 🔄 **Model Generation**: Create Dart model classes from JSON files with complex nested support
- 🧩 **BLoC/Cubit Generation**: Generate BLoC cubit and bloc classes with states following best practices (supports both Equatable and Freezed)
- ⚙️ **Build Runner Integration**: Execute build_runner commands with proper configurations
- 📋 **Config-based Generation**: Generate multiple components from configuration files

## Installation

### Global Installation (Recommended)

```bash
dart pub global activate sf_cli
```

### Local Installation

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  sf_cli: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Usage

### Initialize a New Flutter Project Structure

```bash
sf_cli init
```

This creates a comprehensive folder structure including:
- Feature-based architecture (auth, splash)
- Shared components (API, constants, themes, utils)
- Clean architecture layers (domain, logic, screens, widgets)

### Generate a New Feature

```bash
sf_cli features --name user_profile
# or
sf_cli features -n user_profile

# Generate with Freezed cubit and state
sf_cli features --name user_profile --freezed
```

Creates a complete feature structure:
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

### Generate Model Classes from JSON

```bash
sf_cli model --file path/to/your/model.json
# or
sf_cli model -f path/to/your/model.json
```

Example JSON input:
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

Generates a Dart model class with:
- Proper constructors
- JSON serialization methods
- Null safety support
- Nested class handling

### Generate BLoC Cubit

```bash
sf_cli cubit --name authentication
# or
sf_cli cubit -n authentication

# Generate with Freezed
sf_cli cubit --name authentication --freezed
```

Creates cubit and state files with proper BLoC patterns. Use `--freezed` flag to generate freezed variants with immutable state classes.

### Generate BLoC

```bash
sf_cli bloc --name authentication
# or
sf_cli bloc -n authentication

# Generate with Freezed
sf_cli bloc --name authentication --freezed
```

Creates bloc, event, and state files with proper BLoC patterns. Use `--freezed` flag to generate freezed variants with immutable event and state classes.

### Run Build Runner

```bash
sf_cli runner
```

Executes: `dart run build_runner build --delete-conflicting-outputs`

### Generate from Configuration File

```bash
sf_cli config --config-file path/to/config.json
# or
sf_cli config -c path/to/config.json
```

Example configuration:
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
  }
}
```

## Command Reference

| Command | Description | Options |
|---------|-------------|---------|
| `init` | Initialize project structure | None |
| `features` | Generate feature scaffold | `--name, -n`: Feature name<br>`--freezed`: Use Freezed for cubit/state |
| `model` | Generate model from JSON | `--file, -f`: JSON file path |
| `cubit` | Generate BLoC cubit | `--name, -n`: Cubit name<br>`--freezed`: Use Freezed for cubit/state |
| `bloc` | Generate BLoC bloc | `--name, -n`: Bloc name<br>`--freezed`: Use Freezed for bloc/event/state |
| `runner` | Run build_runner | None |
| `config` | Generate from config | `--config-file, -c`: Config file path |

## Requirements

- Dart SDK: ^3.4.3
- Flutter: Compatible with latest stable versions

## Architecture Patterns

This tool promotes clean architecture patterns:

- **Domain Layer**: Models, repositories, and business logic
- **Logic Layer**: BLoC/Cubit state management
- **Presentation Layer**: Screens and widgets
- **Shared Components**: Reusable utilities and constants

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://github.com/your_username/sf_cli#readme)
- 🐛 [Issue Tracker](https://github.com/your_username/sf_cli/issues)
- 💬 [Discussions](https://github.com/your_username/sf_cli/discussions)
