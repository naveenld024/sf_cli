# Contributing to SF CLI

Thank you for your interest in contributing to SF CLI! This guide will help you get started with contributing to the project.

## Code of Conduct

By participating in this project, you agree to abide by our code of conduct. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- Dart SDK ^3.4.3 or higher
- Flutter (latest stable version)
- Git
- A code editor (VS Code, IntelliJ, etc.)

### Development Setup

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/sf_cli.git
   cd sf_cli
   ```

2. **Install dependencies**
   ```bash
   dart pub get
   ```

3. **Run tests**
   ```bash
   dart test
   ```

4. **Install locally for testing**
   ```bash
   dart pub global activate --source path .
   ```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

- Follow the existing code style
- Add tests for new functionality
- Update documentation as needed
- Ensure all tests pass

### 3. Test Your Changes

```bash
# Run all tests
dart test

# Test the CLI locally
sf_cli --help
sf_cli init
sf_cli features --name test_feature
```

### 4. Commit Your Changes

```bash
git add .
git commit -m "feat: add new feature description"
```

Follow [Conventional Commits](https://www.conventionalcommits.org/) format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `test:` for test additions/changes
- `refactor:` for code refactoring

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub.

## Project Structure

```
sf_cli/
├── bin/
│   └── sf_cli.dart          # CLI entry point
├── lib/
│   ├── bloc.dart            # BLoC generation
│   ├── cubit.dart           # Cubit generation
│   ├── feature.dart         # Feature scaffolding
│   ├── generate_model.dart  # Model generation
│   ├── init.dart           # Project initialization
│   └── ...
├── test/
│   └── sf_cli_test.dart    # Tests
├── example/                 # Example configurations
├── docs/                   # Documentation
└── pubspec.yaml
```

## Coding Standards

### Dart Style Guide

Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

- Use `lowerCamelCase` for variables and functions
- Use `UpperCamelCase` for classes and types
- Use `snake_case` for file names
- Use 2 spaces for indentation

### Code Organization

- Keep functions small and focused
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Organize imports (dart, flutter, packages, relative)

### Example Code Style

```dart
/// Generates a new feature with the specified [name].
/// 
/// If [useFreezed] is true, generates freezed cubit and state classes.
/// Returns true if generation was successful.
Future<bool> generateFeature({
  required String name,
  bool useFreezed = false,
}) async {
  try {
    final featurePath = _getFeaturePath(name);
    await _createFeatureStructure(featurePath);
    
    if (useFreezed) {
      await _generateFreezedFiles(name, featurePath);
    } else {
      await _generateRegularFiles(name, featurePath);
    }
    
    return true;
  } catch (e) {
    print('Error generating feature: $e');
    return false;
  }
}
```

## Testing Guidelines

### Writing Tests

- Write tests for all new functionality
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern
- Mock external dependencies

### Test Structure

```dart
import 'package:test/test.dart';
import 'package:sf_cli/feature.dart';

void main() {
  group('Feature Generation', () {
    test('should create feature structure with correct files', () async {
      // Arrange
      const featureName = 'test_feature';
      
      // Act
      final result = await generateFeature(name: featureName);
      
      // Assert
      expect(result, isTrue);
      expect(File('lib/features/$featureName').existsSync(), isTrue);
    });
    
    test('should generate freezed files when flag is enabled', () async {
      // Arrange
      const featureName = 'freezed_feature';
      
      // Act
      final result = await generateFeature(
        name: featureName,
        useFreezed: true,
      );
      
      // Assert
      expect(result, isTrue);
      // Add specific freezed file checks
    });
  });
}
```

### Running Tests

```bash
# Run all tests
dart test

# Run specific test file
dart test test/feature_test.dart

# Run tests with coverage
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

## Documentation

### Code Documentation

- Add dartdoc comments for public APIs
- Include examples in documentation
- Document complex algorithms or business logic

### README Updates

When adding new features:
- Update the main README.md
- Add examples to the documentation
- Update the command reference table

### Documentation Site

We use Docsify for documentation. To contribute to docs:

1. Edit files in the `docs/` directory
2. Test locally by serving the docs
3. Ensure all links work correctly

## Pull Request Guidelines

### Before Submitting

- [ ] All tests pass
- [ ] Code follows style guidelines
- [ ] Documentation is updated
- [ ] Commit messages follow conventional format
- [ ] No merge conflicts

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests pass
```

## Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes (backward compatible)

### Release Checklist

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Create release tag
4. Publish to pub.dev
5. Update documentation

## Getting Help

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and general discussion
- **Pull Requests**: Code review and collaboration

### Issue Templates

When creating issues, use the appropriate template:
- Bug Report: Include reproduction steps
- Feature Request: Describe the use case
- Documentation: Specify what needs improvement

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- GitHub contributors page

Thank you for contributing to SF CLI! 🚀
