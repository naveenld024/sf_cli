# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2024-06-10

### Changed
- Bug fixes and improvements.

## [1.0.0] - 2024-01-20

### Added
- **Feature Scaffolding**: Complete feature generation with clean architecture patterns
  - Domain layer (models, repositories, services)
  - Logic layer (BLoC/Cubit with states)
  - Presentation layer (screens, widgets)
  - Configuration files for further customization

- **Project Initialization**: Comprehensive Flutter project structure setup
  - Authentication feature scaffold
  - Splash screen implementation
  - Shared components (API, constants, themes, utilities)
  - Clean architecture folder organization

- **Model Generation**: Advanced JSON to Dart model conversion
  - Support for nested objects and complex data structures
  - Null safety compliance
  - Automatic constructor and serialization method generation

- **BLoC/Cubit Generation**: State management pattern implementation
  - Cubit class generation with proper state management
  - Equatable integration for state comparison
  - Part file organization following Dart conventions

- **Build Runner Integration**: Streamlined code generation workflow
  - Automated build_runner execution with conflict resolution
  - Proper error handling and status reporting

- **Configuration-based Generation**: Batch processing capabilities
  - JSON configuration file support
  - Multiple model and repository generation
  - Automated repository method injection

### Features
- Command-line interface with intuitive commands
- Comprehensive help system
- Error handling and validation
- Cross-platform compatibility (Windows, macOS, Linux)

### Dependencies
- `args: ^2.3.0` - Command-line argument parsing
- `process_run: ^0.12.2` - Process execution utilities
- `path: ^1.8.0` - File path manipulation

### Development
- Linting with `lints: ^3.0.0`
- Test framework setup with `test: ^1.24.0`
- Comprehensive documentation and examples
