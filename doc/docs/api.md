# API Reference

This section provides detailed information about the CLI commands, generated code structure, and programmatic usage of SF CLI.

## CLI Commands API

### Global Options

All commands support these global options:

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--help` | `-h` | Show help information | - |
| `--version` | `-v` | Show version information | - |
| `--verbose` | | Enable verbose output | `false` |

### Command: init

Initialize a Flutter project with SF CLI structure.

```bash
sf_cli init [options]
```

**Options:** None

**Exit Codes:**
- `0`: Success
- `1`: General error
- `2`: Directory already initialized

**Example:**
```bash
sf_cli init
```

### Command: features

Generate a complete feature structure.

```bash
sf_cli features --name <name> [--freezed]
```

**Options:**

| Option | Short | Type | Required | Description |
|--------|-------|------|----------|-------------|
| `--name` | `-n` | String | Yes | Feature name (snake_case) |
| `--freezed` | | Flag | No | Generate freezed cubit and state |

**Exit Codes:**
- `0`: Success
- `1`: Invalid feature name
- `2`: Feature already exists
- `3`: File system error

**Examples:**
```bash
sf_cli features --name user_profile
sf_cli features -n authentication --freezed
```

### Command: model

Generate Dart model from JSON file.

```bash
sf_cli model --file <path>
```

**Options:**

| Option | Short | Type | Required | Description |
|--------|-------|------|----------|-------------|
| `--file` | `-f` | String | Yes | Path to JSON file |

**Exit Codes:**
- `0`: Success
- `1`: File not found
- `2`: Invalid JSON format
- `3`: Generation error

**Examples:**
```bash
sf_cli model --file data/user.json
sf_cli model -f models/product.json
```

### Command: cubit

Generate BLoC cubit with state management.

```bash
sf_cli cubit --name <name> [--freezed]
```

**Options:**

| Option | Short | Type | Required | Description |
|--------|-------|------|----------|-------------|
| `--name` | `-n` | String | Yes | Cubit name (snake_case) |
| `--freezed` | | Flag | No | Generate freezed state classes |

**Exit Codes:**
- `0`: Success
- `1`: Invalid cubit name
- `2`: Files already exist
- `3`: Generation error

### Command: bloc

Generate BLoC bloc with events and states.

```bash
sf_cli bloc --name <name> [--freezed]
```

**Options:**

| Option | Short | Type | Required | Description |
|--------|-------|------|----------|-------------|
| `--name` | `-n` | String | Yes | Bloc name (snake_case) |
| `--freezed` | | Flag | No | Generate freezed classes |

### Command: runner

Execute build_runner for code generation.

```bash
sf_cli runner
```

**Options:** None

**What it executes:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Command: config

Generate from simple configuration file.

```bash
sf_cli config --config-file <path>
```

**Options:**

| Option | Short | Type | Required | Description |
|--------|-------|------|----------|-------------|
| `--config-file` | `-c` | String | Yes | Path to config file |

### Command: generate-feature

Generate complete feature from enhanced configuration.

```bash
sf_cli generate-feature --config <path> [--freezed]
```

**Options:**

| Option | Short | Type | Required | Description |
|--------|-------|------|----------|-------------|
| `--config` | `-c` | String | Yes | Path to enhanced config |
| `--freezed` | | Flag | No | Use freezed for models/state |

## Generated Code Structure

### Feature Structure

When generating a feature with `sf_cli features`, the following structure is created:

```
lib/features/<feature_name>/
├── domain/
│   ├── models/
│   │   └── <feature_name>_model.dart
│   ├── repository/
│   │   └── <feature_name>_repository.dart
│   └── services/
│       └── <feature_name>_service.dart
├── logic/<feature_name>/
│   ├── <feature_name>_cubit.dart
│   └── <feature_name>_state.dart
├── screens/
│   └── <feature_name>_screen.dart
├── widgets/
│   └── <feature_name>_widget.dart
└── <feature_name>_config.json
```

### Model Classes

Generated model classes include:

```dart
class UserModel {
  final int id;
  final String name;
  final String email;
  
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });
  
  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
  
  // Equality and hash
  @override
  bool operator ==(Object other) => // ...
  
  @override
  int get hashCode => // ...
  
  // Copy with
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
  );
}
```

### Freezed Models

When using `--freezed` flag:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String email,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### Cubit Classes

Generated cubit classes follow this pattern:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  
  Future<void> loadUser(int id) async {
    emit(UserLoading());
    try {
      // Business logic here
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

### State Classes

Regular state classes:

```dart
part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  
  const UserLoaded(this.user);
  
  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;
  
  const UserError(this.message);
  
  @override
  List<Object> get props => [message];
}
```

### Freezed State Classes

When using `--freezed`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserInitial;
  const factory UserState.loading() = UserLoading;
  const factory UserState.loaded(UserModel user) = UserLoaded;
  const factory UserState.error(String message) = UserError;
}
```

### Repository Interface

```dart
abstract class UserRepository {
  Future<UserModel> getUser(int id);
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(int id);
}
```

### Service Class

```dart
class UserService {
  final UserRepository repository;
  
  UserService(this.repository);
  
  Future<UserModel> getUser(int id) async {
    return await repository.getUser(id);
  }
  
  Future<List<UserModel>> getUsers() async {
    return await repository.getUsers();
  }
}
```

## Configuration File Schemas

### Simple Configuration Schema

```json
{
  "type": "object",
  "properties": {
    "<model_name>": {
      "type": "object",
      "properties": {
        "model_class_relative_path": {"type": "string"},
        "end_point": {"type": "string"},
        "method": {"enum": ["get", "post", "put", "delete"]},
        "function_name": {"type": "string"},
        "parameters": {"type": "object"}
      },
      "required": ["model_class_relative_path", "end_point", "method", "function_name"]
    }
  }
}
```

### Enhanced Configuration Schema

```json
{
  "type": "object",
  "properties": {
    "feature_name": {"type": "string"},
    "description": {"type": "string"},
    "models": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "json_path": {"type": "string"},
          "use_freezed": {"type": "boolean"}
        },
        "required": ["name", "json_path"]
      }
    },
    "api_endpoints": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "method": {"enum": ["GET", "POST", "PUT", "DELETE"]},
          "path": {"type": "string"},
          "parameters": {"type": "object"},
          "body": {"type": "string"},
          "response_model": {"type": "string"}
        },
        "required": ["name", "method", "path"]
      }
    },
    "state_management": {
      "type": "object",
      "properties": {
        "type": {"enum": ["cubit", "bloc"]},
        "use_freezed": {"type": "boolean"},
        "states": {"type": "array", "items": {"type": "string"}}
      },
      "required": ["type"]
    }
  },
  "required": ["feature_name"]
}
```

## Error Handling

### Common Error Codes

| Code | Description | Resolution |
|------|-------------|------------|
| `1` | General error | Check command syntax |
| `2` | File/directory exists | Use different name or remove existing |
| `3` | File not found | Verify file path |
| `4` | Invalid JSON | Check JSON syntax |
| `5` | Permission denied | Check file permissions |

### Error Messages

SF CLI provides descriptive error messages:

```bash
# Invalid feature name
Error: Feature name must be in snake_case format
Example: user_profile, not UserProfile or user-profile

# File not found
Error: JSON file not found: data/user.json
Please check the file path and try again

# Invalid JSON
Error: Invalid JSON format in data/user.json
Line 5: Unexpected token ','
```

## Programmatic Usage

While SF CLI is primarily a command-line tool, you can use its functions programmatically:

```dart
import 'package:sf_cli/feature.dart';
import 'package:sf_cli/generate_model.dart';

void main() async {
  // Generate feature
  await generateFeature(
    name: 'user_profile',
    useFreezed: true,
  );
  
  // Generate model
  await generateModel(
    jsonFilePath: 'data/user.json',
  );
}
```

## Next Steps

- [Code Structure Details](api/code-structure.md)
- [Configuration Examples](configuration.md)
- [Contributing Guide](contributing.md)
