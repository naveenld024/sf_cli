# Command Reference

SF CLI provides a comprehensive set of commands for Flutter development. Here's a complete reference of all available commands.

## Command Overview

| Command | Description | Key Options |
|---------|-------------|-------------|
| [`init`](#init) | Initialize project structure | None |
| [`features`](#features) | Generate feature scaffold | `--name`, `--freezed` |
| [`model`](#model) | Generate model from JSON | `--file` |
| [`cubit`](#cubit) | Generate BLoC cubit | `--name`, `--freezed` |
| [`bloc`](#bloc) | Generate BLoC bloc | `--name`, `--freezed` |
| [`runner`](#runner) | Run build_runner | None |
| [`config`](#config) | Generate from config | `--config-file` |
| [`generate-feature`](#generate-feature) | Generate complete feature from enhanced config | `--config`, `--freezed` |

## Commands

### init

Initialize a new Flutter project structure with recommended folder organization.

```bash
sf_cli init
```

**What it creates:**
- Feature-based architecture folders
- Shared components structure
- Clean architecture layers
- Basic configuration files

**Example output structure:**
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

### features

Generate a complete feature structure with all necessary files and folders.

```bash
sf_cli features --name <feature_name> [--freezed]
```

**Options:**
- `--name, -n`: Name of the feature (required)
- `--freezed`: Generate freezed cubit and state classes

**Examples:**
```bash
# Basic feature generation
sf_cli features --name user_profile

# With freezed support
sf_cli features --name user_profile --freezed

# Short form
sf_cli features -n authentication --freezed
```

**Generated structure:**
```
lib/features/<feature_name>/
├── domain/
│   ├── models/<feature_name>_model.dart
│   ├── repository/<feature_name>_repository.dart
│   └── services/<feature_name>_service.dart
├── logic/<feature_name>/
│   ├── <feature_name>_cubit.dart
│   └── <feature_name>_state.dart
├── screens/<feature_name>_screen.dart
├── widgets/<feature_name>_widget.dart
└── <feature_name>_config.json
```

### model

Generate Dart model classes from JSON files with proper serialization support.

```bash
sf_cli model --file <json_file_path>
```

**Options:**
- `--file, -f`: Path to the JSON file (required)

**Examples:**
```bash
sf_cli model --file data/user.json
sf_cli model -f models/product.json
```

**Features:**
- Automatic type inference
- Nested object support
- List and array handling
- Null safety compliance
- JSON serialization methods

### cubit

Generate BLoC cubit with state classes following best practices.

```bash
sf_cli cubit --name <cubit_name> [--freezed]
```

**Options:**
- `--name, -n`: Name of the cubit (required)
- `--freezed`: Generate freezed state classes

**Examples:**
```bash
# Basic cubit
sf_cli cubit --name authentication

# With freezed
sf_cli cubit --name authentication --freezed

# Short form
sf_cli cubit -n user_settings --freezed
```

**Generated files:**
- `<name>_cubit.dart`: Cubit class with business logic
- `<name>_state.dart`: State classes (initial, loading, success, error)

### bloc

Generate BLoC bloc with event and state classes.

```bash
sf_cli bloc --name <bloc_name> [--freezed]
```

**Options:**
- `--name, -n`: Name of the bloc (required)
- `--freezed`: Generate freezed event and state classes

**Examples:**
```bash
# Basic bloc
sf_cli bloc --name authentication

# With freezed
sf_cli bloc --name authentication --freezed

# Short form
sf_cli bloc -n user_management --freezed
```

**Generated files:**
- `<name>_bloc.dart`: Bloc class with event handling
- `<name>_event.dart`: Event classes
- `<name>_state.dart`: State classes

### runner

Execute build_runner with optimized settings for code generation.

```bash
sf_cli runner
```

**What it does:**
- Runs `dart run build_runner build --delete-conflicting-outputs`
- Handles freezed code generation
- Cleans up conflicting files
- Optimized for SF CLI generated code

### config

Generate multiple components from a configuration file.

```bash
sf_cli config --config-file <config_path>
```

**Options:**
- `--config-file, -c`: Path to the configuration file (required)

**Example:**
```bash
sf_cli config --config-file config/api_config.json
```

**Configuration format:**
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

### generate-feature

Generate a complete feature from an enhanced configuration file with full architecture support.

```bash
sf_cli generate-feature --config <config_path> [--freezed]
```

**Options:**
- `--config, -c`: Path to the enhanced configuration file (required)
- `--freezed`: Use freezed for models and state management

**Examples:**
```bash
# Basic generation
sf_cli generate-feature --config enhanced_config.json

# With freezed (recommended)
sf_cli generate-feature --config enhanced_config.json --freezed

# Short form
sf_cli generate-feature -c config/user_feature.json --freezed
```

**What it generates:**
- Complete feature structure
- Freezed models with JSON serialization
- Repository and service layers
- Cubit-based state management
- UI screens and widgets
- Proper error handling
- Loading states

## Global Options

All commands support these global options:

- `--help, -h`: Show help information
- `--version`: Show version information
- `--verbose, -v`: Enable verbose output

## Examples

### Complete Workflow Example

```bash
# 1. Initialize project
sf_cli init

# 2. Generate a feature
sf_cli features --name user_profile --freezed

# 3. Generate models from JSON
sf_cli model --file data/user.json

# 4. Generate additional state management
sf_cli cubit --name settings --freezed

# 5. Run build runner
sf_cli runner
```

### Advanced Feature Generation

```bash
# Generate complete feature from config
sf_cli generate-feature --config enhanced_user_config.json --freezed

# Run build runner to generate code
sf_cli runner
```

## Tips

1. **Always use `--freezed`** for better immutability and code generation
2. **Run `sf_cli runner`** after generating freezed code
3. **Organize features** by domain for better maintainability
4. **Use configuration files** for complex, repeatable setups
5. **Follow naming conventions** (snake_case for feature names)
