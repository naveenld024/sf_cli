<div align="center">

# 🚀 SF CLI - Flutter Scaffolding Tool

[![pub package](https://img.shields.io/pub/v/sf_cli.svg?style=for-the-badge&color=blue)](https://pub.dev/packages/sf_cli)
[![Documentation](https://img.shields.io/badge/docs-docsify-blue.svg?style=for-the-badge)](https://naveenld024.github.io/sf_cli/)
[![GitHub Stars](https://img.shields.io/github/stars/naveenld024/sf_cli?style=for-the-badge&color=yellow)](https://github.com/naveenld024/sf_cli)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=for-the-badge)](LICENSE)
[![Dart Version](https://img.shields.io/badge/dart-%5E3.4.3-blue.svg?style=for-the-badge&logo=dart)](https://dart.dev)
[![Build Status](https://img.shields.io/github/actions/workflow/status/naveenld024/sf_cli/ci.yml?style=for-the-badge)](https://github.com/naveenld024/sf_cli/actions)

**A powerful command-line interface tool for Flutter developers that automates the creation of feature-based project structures, model generation from JSON, and BLoC pattern implementation.**

*Boost your Flutter development productivity with automated scaffolding and clean architecture patterns.*

[📖 **Documentation**](https://naveenld024.github.io/sf_cli/) • [🚀 **Quick Start**](#quick-start) • [💡 **Examples**](#examples) • [🤝 **Contributing**](#contributing)

</div>

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🏗️ **Project Scaffolding**
- ✅ Complete feature-based architecture setup
- ✅ Clean folder structure generation
- ✅ Predefined templates for common patterns
- ✅ Domain-driven design structure

### 🤖 **Smart Code Generation**
- ✅ Dart model classes from JSON
- ✅ Complex nested object support
- ✅ Null safety and type safety
- ✅ Automatic serialization methods

</td>
<td width="50%">

### 🧩 **State Management**
- ✅ BLoC/Cubit pattern implementation
- ✅ Equatable and Freezed support
- ✅ Best practices enforcement
- ✅ Immutable state management

### ⚙️ **Developer Tools**
- ✅ Build runner integration
- ✅ Config-based generation
- ✅ Enhanced feature creation
- ✅ Dependency injection setup

</td>
</tr>
</table>

## 🎯 Why Choose SF CLI?

> **"From idea to implementation in minutes, not hours"**

- **🚀 Rapid Development**: Generate complete features with a single command
- **📐 Clean Architecture**: Enforces best practices and maintainable code structure
- **🔧 Type Safety**: Full null safety and strong typing support
- **🎨 Customizable**: Flexible configuration options for different project needs
- **📚 Well Documented**: Comprehensive documentation with examples
- **🧪 Battle Tested**: Used in production Flutter applications

## 📦 Installation

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

### Verify Installation

```bash
sf_cli --version
```

## 🚀 Quick Start

Get up and running with SF CLI in under 2 minutes:

```bash
# 1. Install SF CLI globally
dart pub global activate sf_cli

# 2. Initialize your Flutter project structure
sf_cli init

# 3. Generate your first feature
sf_cli features --name user_profile --freezed

# 4. Generate models from JSON
sf_cli model --file path/to/user.json

# 5. Run build runner to generate code
sf_cli runner
```

## 📋 Usage

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

### Generate Complete Feature from Enhanced Configuration

```bash
# Generate complete feature with freezed models and state management (recommended)
sf_cli generate-feature --config path/to/enhanced_config.json --freezed

# Generate feature with regular models and state management
sf_cli generate-feature --config path/to/enhanced_config.json
# or
sf_cli generate-feature -c path/to/enhanced_config.json --freezed
```

This new command generates a complete feature structure including:
- Freezed models with JSON serialization
- Repository and service layers with dependency injection
- Cubit-based state management
- UI screens and widgets
- Proper error handling and loading states

See `example/ENHANCED_FEATURE_GENERATION.md` for detailed documentation and `example/enhanced_feature_config.json` for a complete example.

## 📊 Command Reference

| Command | Description | Options |
|---------|-------------|---------|
| `init` | Initialize project structure | None |
| `features` | Generate feature scaffold | `--name, -n`: Feature name<br>`--freezed`: Use Freezed for cubit/state |
| `model` | Generate model from JSON | `--file, -f`: JSON file path |
| `cubit` | Generate BLoC cubit | `--name, -n`: Cubit name<br>`--freezed`: Use Freezed for cubit/state |
| `bloc` | Generate BLoC bloc | `--name, -n`: Bloc name<br>`--freezed`: Use Freezed for bloc/event/state |
| `runner` | Run build_runner | None |
| `config` | Generate from config | `--config-file, -c`: Config file path |
| `generate-feature` | Generate complete feature from enhanced config | `--config, -c`: Enhanced config file path<br>`--freezed`: Use Freezed for models/state |

## 💡 Examples

<details>
<summary><strong>🏗️ Complete Project Setup</strong></summary>

```bash
# Initialize a new Flutter project with SF CLI structure
flutter create my_app
cd my_app
sf_cli init

# Generate authentication feature with Freezed
sf_cli features --name auth --freezed

# Generate user profile feature
sf_cli features --name user_profile --freezed

# Generate models from API responses
sf_cli model --file api_responses/user.json
sf_cli model --file api_responses/auth.json

# Run build runner to generate code
sf_cli runner
```

</details>

<details>
<summary><strong>🤖 Model Generation from Complex JSON</strong></summary>

Given a complex JSON structure:
```json
{
  "user": {
    "id": 1,
    "profile": {
      "name": "John Doe",
      "avatar": "https://example.com/avatar.jpg",
      "settings": {
        "theme": "dark",
        "notifications": true,
        "preferences": ["coding", "reading"]
      }
    },
    "posts": [
      {
        "id": 1,
        "title": "My First Post",
        "tags": ["flutter", "dart"]
      }
    ]
  }
}
```

Generate with:
```bash
sf_cli model --file user_data.json
```

This creates properly nested Dart classes with full type safety.

</details>

<details>
<summary><strong>🧩 State Management Setup</strong></summary>

```bash
# Generate authentication cubit with Freezed
sf_cli cubit --name auth --freezed

# Generate user management bloc with Freezed
sf_cli bloc --name user_management --freezed

# The generated files include:
# - Immutable state classes
# - Proper event handling
# - Type-safe state transitions
# - Built-in equality comparisons
```

</details>

## 🏛️ Architecture Patterns

This tool promotes clean architecture patterns:

- **Domain Layer**: Models, repositories, and business logic
- **Logic Layer**: BLoC/Cubit state management
- **Presentation Layer**: Screens and widgets
- **Shared Components**: Reusable utilities and constants

## 📋 Requirements

- **Dart SDK**: ^3.4.3
- **Flutter**: Compatible with latest stable versions
- **Operating System**: Windows, macOS, Linux

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create your feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add some amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Development Setup

```bash
# Clone the repository
git clone https://github.com/naveenld024/sf_cli.git
cd sf_cli

# Install dependencies
dart pub get

# Run tests
dart test

# Build the project
dart compile exe bin/sf_cli.dart
```

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📖 Documentation

📖 **[Complete Documentation](https://naveenld024.github.io/sf_cli/)** - Comprehensive guides, examples, and API reference

### Quick Links
- [Installation Guide](https://naveenld024.github.io/sf_cli/#/installation)
- [Quick Start](https://naveenld024.github.io/sf_cli/#/quickstart)
- [Command Reference](https://naveenld024.github.io/sf_cli/#/commands)
- [Examples & Tutorials](https://naveenld024.github.io/sf_cli/#/examples)
- [Architecture Guide](https://naveenld024.github.io/sf_cli/#/architecture)

## 🆘 Support

- 📖 [Documentation](https://naveenld024.github.io/sf_cli/)
- 🐛 [Issue Tracker](https://github.com/naveenld024/sf_cli/issues)
- 💬 [Discussions](https://github.com/naveenld024/sf_cli/discussions)
- 📧 [Email Support](mailto:naveenld024@gmail.com)

## 🌟 Show Your Support

If this project helped you, please consider:

- ⭐ **Starring** the repository
- 🐛 **Reporting** bugs and issues
- 💡 **Suggesting** new features
- 📖 **Contributing** to documentation
- 🔄 **Sharing** with other Flutter developers

---

<div align="center">

**Made with ❤️ by [Naveen](https://github.com/naveenld024)**

*Happy Flutter Development! 🚀*

</div>


