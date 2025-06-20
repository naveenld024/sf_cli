import 'package:args/args.dart';
import 'package:sf_cli/build_runners.dart';
import 'package:sf_cli/cubit.dart';
import 'package:sf_cli/bloc.dart';
import 'package:sf_cli/feature.dart';
import 'package:sf_cli/generate_from_config.dart';
import 'package:sf_cli/generate_feature_from_config.dart';
import 'package:sf_cli/generate_model.dart';
import 'package:sf_cli/init.dart';

void showHelp() {
  print('''
SF CLI - Flutter Scaffolding Tool v1.0.3

A powerful command-line interface tool for Flutter developers that automates
the creation of feature-based project structures, model generation from JSON,
and BLoC pattern implementation.

USAGE:
  sf_cli <command> [options]

AVAILABLE COMMANDS:
  init                Initialize a new Flutter project with SF CLI structure
  features            Generate a new feature with complete folder structure
  model               Generate Dart model classes from JSON files
  cubit               Generate a new Cubit class with state management
  bloc                Generate a new BLoC class with event and state management
  runner              Run build_runner to generate code
  config              Generate code from configuration file
  generate-feature    Generate complete feature from enhanced configuration file

GLOBAL OPTIONS:
  -h, --help          Show this help information
  -v, --version       Show version information

EXAMPLES:
  sf_cli init
  sf_cli features --name user_profile --freezed
  sf_cli model --file data/user.json
  sf_cli cubit --name settings --freezed
  sf_cli bloc --name auth --freezed
  sf_cli runner
  sf_cli config --config-file config.json
  sf_cli generate-feature --config enhanced_config.json --freezed

For more information about a specific command, use:
  sf_cli <command> --help

Documentation: https://naveenld024.github.io/sf_cli/
Repository: https://github.com/naveenld024/sf_cli
''');
}

void showVersion() {
  print('SF CLI version 1.0.3');
}

void showCommandHelp(String commandName) {
  switch (commandName) {
    case 'init':
      print('''
sf_cli init

Initialize a new Flutter project with SF CLI structure.

This command sets up a complete project structure with:
- Feature-based architecture
- Clean architecture layers
- Shared components and utilities
- Proper folder organization

USAGE:
  sf_cli init

EXAMPLE:
  sf_cli init
''');
      break;

    case 'features':
      print('''
sf_cli features --name <feature_name> [--freezed]

Generate a new feature with complete folder structure.

OPTIONS:
  -n, --name <name>    Name of the feature (required)
      --freezed        Generate freezed cubit and state

EXAMPLES:
  sf_cli features --name user_profile
  sf_cli features --name auth --freezed
  sf_cli features -n dashboard --freezed
''');
      break;

    case 'model':
      print('''
sf_cli model --file <json_file>

Generate Dart model classes from JSON files.

OPTIONS:
  -f, --file <path>    The JSON file path for model generation (required)

EXAMPLES:
  sf_cli model --file data/user.json
  sf_cli model -f api_responses/auth.json
''');
      break;

    case 'cubit':
      print('''
sf_cli cubit --name <cubit_name> [--freezed]

Generate a new Cubit class with state management.

OPTIONS:
  -n, --name <name>    Name of the cubit (required)
      --freezed        Generate freezed cubit and state

EXAMPLES:
  sf_cli cubit --name settings
  sf_cli cubit --name user_profile --freezed
  sf_cli cubit -n auth --freezed
''');
      break;

    case 'bloc':
      print('''
sf_cli bloc --name <bloc_name> [--freezed]

Generate a new BLoC class with event and state management.

OPTIONS:
  -n, --name <name>    Name of the bloc (required)
      --freezed        Generate freezed bloc and event

EXAMPLES:
  sf_cli bloc --name authentication
  sf_cli bloc --name user_management --freezed
  sf_cli bloc -n settings --freezed
''');
      break;

    case 'runner':
      print('''
sf_cli runner

Run build_runner to generate code.

This command executes 'dart run build_runner build --delete-conflicting-outputs'
to generate code for annotations like @freezed, @JsonSerializable, etc.

USAGE:
  sf_cli runner

EXAMPLE:
  sf_cli runner
''');
      break;

    case 'config':
      print('''
sf_cli config --config-file <config_file>

Generate code from configuration file.

OPTIONS:
  -c, --config-file <path>    The configuration JSON file path (required)

EXAMPLES:
  sf_cli config --config-file config.json
  sf_cli config -c project_config.json
''');
      break;

    case 'generate-feature':
      print('''
sf_cli generate-feature --config <config_file> [--freezed]

Generate complete feature from enhanced configuration file.

OPTIONS:
  -c, --config <path>    Configuration file path for feature generation (required)
      --freezed          Generate freezed models and state management

EXAMPLES:
  sf_cli generate-feature --config enhanced_config.json
  sf_cli generate-feature --config feature_config.json --freezed
  sf_cli generate-feature -c config.json --freezed
''');
      break;

    default:
      print('No help available for command: $commandName');
      showHelp();
  }
}

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Show help information', negatable: false)
    ..addFlag('version', abbr: 'v', help: 'Show version information', negatable: false);

  // Add commands with their specific options
  parser.addCommand('init', ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Show help for init command', negatable: false));

  parser.addCommand('features', ArgParser()
    ..addOption('name', abbr: 'n', help: 'Name of the feature')
    ..addFlag('freezed', help: 'Generate freezed cubit and state', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Show help for features command', negatable: false));

  parser.addCommand('model', ArgParser()
    ..addOption('file', abbr: 'f', help: 'The JSON file path for model generation')
    ..addFlag('help', abbr: 'h', help: 'Show help for model command', negatable: false));

  parser.addCommand('cubit', ArgParser()
    ..addOption('name', abbr: 'n', help: 'Name of the cubit')
    ..addFlag('freezed', help: 'Generate freezed cubit and state', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Show help for cubit command', negatable: false));

  parser.addCommand('bloc', ArgParser()
    ..addOption('name', abbr: 'n', help: 'Name of the bloc')
    ..addFlag('freezed', help: 'Generate freezed bloc and event', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Show help for bloc command', negatable: false));

  parser.addCommand('runner', ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Show help for runner command', negatable: false));

  parser.addCommand('config', ArgParser()
    ..addOption('config-file', abbr: 'c', help: 'The configuration JSON file path')
    ..addFlag('help', abbr: 'h', help: 'Show help for config command', negatable: false));

  parser.addCommand('generate-feature', ArgParser()
    ..addOption('config', abbr: 'c', help: 'Configuration file path for feature generation')
    ..addFlag('freezed', help: 'Generate freezed models and state management', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Show help for generate-feature command', negatable: false));

  try {
    ArgResults argResults = parser.parse(arguments);

    // Handle global flags
    if (argResults['help'] == true || arguments.isEmpty) {
      showHelp();
      return;
    }

    if (argResults['version'] == true) {
      showVersion();
      return;
    }

    // Handle commands
    final command = argResults.command;
    if (command == null) {
      showHelp();
      return;
    }

    // Check for command-specific help
    if (command['help'] == true) {
      showCommandHelp(command.name!);
      return;
    }

    switch (command.name) {
      case 'init':
        initializeProject();
        break;

      case 'features':
        String? featureName = command['name'];
        bool useFreezed = command['freezed'] ?? false;
        if (featureName != null) {
          createFeature(featureName, useFreezed: useFreezed);
        } else {
          print('Error: Please provide a feature name using --name or -n');
          showCommandHelp('features');
        }
        break;

      case 'model':
        String? filePath = command['file'];
        if (filePath != null) {
          print('Input path provided: $filePath');
          generateModelClasses(filePath);
        } else {
          print('Error: Please provide the JSON file path using --file or -f option.');
          showCommandHelp('model');
        }
        break;

      case 'cubit':
        String? cubitName = command['name'];
        bool useFreezed = command['freezed'] ?? false;
        if (cubitName != null) {
          createCubitClass(cubitName, useFreezed: useFreezed);
        } else {
          print('Error: Please provide a cubit name using --name or -n');
          showCommandHelp('cubit');
        }
        break;

      case 'bloc':
        String? blocName = command['name'];
        bool useFreezed = command['freezed'] ?? false;
        if (blocName != null) {
          createBlocClass(blocName, useFreezed: useFreezed);
        } else {
          print('Error: Please provide a bloc name using --name or -n');
          showCommandHelp('bloc');
        }
        break;

      case 'runner':
        runBuildRunner();
        break;

      case 'config':
        String? configFilePath = command['config-file'];
        if (configFilePath != null) {
          await generateFromConfig(configFilePath);
        } else {
          print('Error: Please provide the config file path using --config-file or -c option.');
          showCommandHelp('config');
        }
        break;

      case 'generate-feature':
        String? configFilePath = command['config'];
        bool useFreezed = command['freezed'] ?? false;
        if (configFilePath != null) {
          await generateFeatureFromConfig(configFilePath, useFreezed: useFreezed);
        } else {
          print('Error: Please provide the config file path using --config or -c option.');
          showCommandHelp('generate-feature');
        }
        break;

      default:
        print('Error: Unknown command "${command.name}"');
        showHelp();
    }
  } catch (e) {
    print('Error: $e');
    showHelp();
  }
}