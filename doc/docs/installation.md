# Installation

## Requirements

Before installing SF CLI, ensure you have the following requirements:

- **Dart SDK**: ^3.4.3 or higher
- **Flutter**: Compatible with latest stable versions
- **Git**: For version control (recommended)

## Global Installation (Recommended)

The easiest way to install SF CLI is globally using Dart's package manager:

```bash
dart pub global activate sf_cli
```

After installation, you can use the `sf_cli` command from anywhere in your terminal.

### Verify Installation

To verify that SF CLI is installed correctly, run:

```bash
sf_cli --help
```

You should see the help output with available commands.

## Local Installation

If you prefer to install SF CLI locally for a specific project, add it to your `pubspec.yaml`:

```yaml
dev_dependencies:
  sf_cli: ^1.0.0
```

Then run:

```bash
dart pub get
```

When using local installation, you'll need to run commands with `dart run`:

```bash
dart run sf_cli --help
```

## Alternative Installation Methods

### From Source

You can also install SF CLI directly from the GitHub repository:

```bash
dart pub global activate --source git https://github.com/naveenld024/sf_cli.git
```

### Specific Version

To install a specific version:

```bash
dart pub global activate sf_cli 1.0.0
```

## Updating SF CLI

To update to the latest version:

```bash
dart pub global activate sf_cli
```

## Uninstalling

To uninstall SF CLI:

```bash
dart pub global deactivate sf_cli
```

## Troubleshooting

### Command Not Found

If you get a "command not found" error after global installation:

1. Make sure Dart's global packages are in your PATH
2. Add the following to your shell profile (`.bashrc`, `.zshrc`, etc.):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

3. Restart your terminal or run `source ~/.bashrc` (or your shell's config file)

### Permission Issues

On some systems, you might need to use `sudo` for global installation:

```bash
sudo dart pub global activate sf_cli
```

### Version Conflicts

If you encounter version conflicts, try:

1. Deactivating the current version: `dart pub global deactivate sf_cli`
2. Clearing pub cache: `dart pub cache clean`
3. Reinstalling: `dart pub global activate sf_cli`

## Next Steps

Once installed, you can:

1. [Get started with the Quick Start guide](quickstart.md)
2. [Explore available commands](commands.md)
3. [Check out examples](examples.md)
