# SF CLI - Flutter Scaffolding Tool

> A powerful command-line interface tool for Flutter developers that automates the creation of feature-based project structures, model generation from JSON, and BLoC pattern implementation.

[![pub package](https://img.shields.io/pub/v/sf_cli.svg)](https://pub.dev/packages/sf_cli)

## Features

- 🏗️ **Feature Scaffolding**: Generate complete feature structures with feature folder structures
- 📱 **Project Initialization**: Set up Flutter projects with predefined folder structures
- 🔄 **Model Generation**: Create Dart model classes from JSON files with complex nested support
- 🧩 **BLoC/Cubit Generation**: Generate BLoC cubit and bloc classes with states following best practices (supports both Equatable and Freezed)
- ⚙️ **Build Runner Integration**: Execute build_runner commands with proper configurations
- 📋 **Config-based Generation**: Generate multiple components from configuration files

## Quick Start

### Global Installation (Recommended)

```bash
dart pub global activate sf_cli
```

### Initialize a New Flutter Project Structure

```bash
sf_cli init
```

### Generate a New Feature

```bash
sf_cli features --name user_profile --freezed
```

## What's Next?

- [Installation Guide](installation.md) - Detailed installation instructions
- [Commands Reference](commands.md) - Complete command documentation
- [Examples](examples.md) - Practical examples and tutorials
- [Architecture](architecture.md) - Understanding the generated architecture patterns