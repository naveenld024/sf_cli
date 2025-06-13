import 'package:args/args.dart';
import 'package:sf_cli/build_runners.dart';
import 'package:sf_cli/cubit.dart';
import 'package:sf_cli/bloc.dart';
import 'package:sf_cli/feature.dart';
import 'package:sf_cli/generate_from_config.dart';
import 'package:sf_cli/generate_feature_from_config.dart';
import 'package:sf_cli/generate_model.dart';
import 'package:sf_cli/init.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('features')
    ..addCommand('init')
    ..addCommand('model')
    ..addOption('file', abbr: 'f', help: 'The JSON file path for model generation',)
    ..addCommand('runner')
    ..addCommand('config')
    ..addOption('config-file', abbr: 'c', help: 'The configuration JSON file path')
    ..addCommand('generate-feature')
    ..addCommand('cubit')
    ..addCommand('bloc')
    ..addFlag('help', abbr: 'h', help: 'Show help');

  // Add name options to specific commands
  parser.commands['features']?.addOption('name', abbr: 'n', help: 'Name of the feature');
  parser.commands['features']?.addFlag('freezed', help: 'Generate freezed cubit and state');
  parser.commands['generate-feature']?.addOption('config', abbr: 'c', help: 'Configuration file path for feature generation');
  parser.commands['generate-feature']?.addFlag('freezed', help: 'Generate freezed models and state management');
  parser.commands['cubit']?.addOption('name', abbr: 'n', help: 'Name of the cubit');
  parser.commands['cubit']?.addFlag('freezed', help: 'Generate freezed cubit and state');
  parser.commands['bloc']?.addOption('name', abbr: 'n', help: 'Name of the bloc');
  parser.commands['bloc']?.addFlag('freezed', help: 'Generate freezed bloc and event');

  ArgResults argResults = parser.parse(arguments);

  if (argResults.command?.name == 'features') {
    String? featureName = argResults.command?['name'];
    bool useFreezed = argResults.command?['freezed'] ?? false;
    if (featureName != null) {
      createFeature(featureName, useFreezed: useFreezed);
    } else {
      print('Please provide a feature name using --name or -n');
    }
  } else if (argResults.command?.name == 'init') {
    initializeProject();
  } else if (argResults.command?.name == 'model') {
    String? filePath = argResults['file'];
    if (filePath != null) {
      print('Input path provided: $filePath');
      generateModelClasses(filePath);
    } else {
      print('Please provide the JSON file path using --file or -f option.');
    }
  } else if (argResults.command?.name == 'runner') {
    runBuildRunner();
  } else if (argResults.command?.name == 'config') {
    String? configFilePath = argResults['config-file'];
    if (configFilePath != null) {
      await generateFromConfig(configFilePath);
    } else {
      print('Please provide the config file path using --config-file or -c option.');
    }
  } else if (argResults.command?.name == 'generate-feature') {
    String? configFilePath = argResults.command?['config'];
    bool useFreezed = argResults.command?['freezed'] ?? false;
    if (configFilePath != null) {
      await generateFeatureFromConfig(configFilePath, useFreezed: useFreezed);
    } else {
      print('Please provide the config file path using --config or -c option.');
    }
  } else if (argResults.command?.name == 'cubit') {
    String? cubitName = argResults.command?['name'];
    bool useFreezed = argResults.command?['freezed'] ?? false;
    if (cubitName != null) {
      createCubitClass(cubitName, useFreezed: useFreezed);
    } else {
      print('Please provide a cubit name using --name or -n');
    }
  } else if (argResults.command?.name == 'bloc') {
    String? blocName = argResults.command?['name'];
    bool useFreezed = argResults.command?['freezed'] ?? false;
    if (blocName != null) {
      createBlocClass(blocName, useFreezed: useFreezed);
    } else {
      print('Please provide a bloc name using --name or -n');
    }
  } else if (argResults['help'] == true || arguments.isEmpty) {
    print(parser.usage);
  } else {
    print('Invalid command. Use either "features", "init", "model", "runner", "cubit", "bloc", "config", or "generate-feature".\n Use --help for more information.');
  }
}