# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-01-20

### Fixed
- **Help System**: Complete overhaul of the CLI help functionality
  - Fixed help command not showing available commands and descriptions
  - Help now displays all commands with proper descriptions instead of just global options
  - Resolved argument parser structure issues that prevented proper help display

### Added
- **Comprehensive Help Display**: Professional CLI help system
  - Main help shows all commands, descriptions, examples, and documentation links
  - Individual command help with detailed usage syntax and examples
  - Version flag (`--version`) to display current CLI version
  - Better error messages that guide users to correct usage

### Improved
- **CLI User Experience**: Enhanced command-line interface
  - Professional formatting with clear command descriptions
  - Command-specific help accessible via `sf_cli <command> --help`
  - Better error handling with helpful guidance messages
  - Improved argument parser structure for better command separation
  - Exception handling for invalid commands and malformed arguments

### Technical
- Reorganized argument parser to properly separate commands and their options
- Added comprehensive help functions for each command
- Enhanced error handling with try-catch blocks
- Updated version display across all help outputs

## [1.0.2] - 2024-12-19

### Added
- **Comprehensive Documentation**: Complete documentation system using Docsify
  - Interactive documentation website with modern UI
  - API reference with detailed command explanations
  - Architecture guide explaining clean architecture patterns
  - Configuration guide for advanced usage
  - Examples and quickstart tutorials
  - Contributing guidelines for developers

- **Enhanced CONFIG.JSON Setup**: Advanced configuration-based feature generation
  - Support for complex feature scaffolding via JSON configuration
  - Enhanced model generation with nested object support
  - Automatic repository and service layer generation
  - State management integration (BLoC/Cubit) through configuration
  - Batch processing capabilities for multiple features
  - Template-based code generation with customizable patterns

### Improved
- Better error handling and validation for configuration files
- Enhanced CLI help system with more detailed command descriptions
- Improved code generation templates for better maintainability

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
