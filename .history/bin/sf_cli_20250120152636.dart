import 'package:args/args.dart';
import 'package:sf_cli/build_runners.dart';
import 'package:sf_cli/feature.dart';
import 'package:sf_cli/generate_from_config';
import 'package:sf_cli/generate_model.dart';
import 'package:sf_cli/init.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('features')
    ..addOption('name', abbr: 'n', help: 'Name of the features')
    ..addCommand('init')
    ..addCommand('model')
    ..addOption('file', abbr: 'f', help: 'The JSON file path for model generation')
    ..addCommand('runner')
    ..addCommand('config')
    ..addOption('config-file', abbr: 'c', help: 'The configuration JSON file path')
    ..addCommand('cubit')
    ..addOption('name', abbr: 'n', help: 'Name of the cubit')
    ..addFlag('help', abbr: 'h', help: 'Show help');

  ArgResults argResults = parser.parse(arguments);

  if (argResults.command?.name == 'features') {
    String? featureName = argResults['name'];
    if (featureName != null) {
      createFeature(featureName);
    } else {
      print('Please provide a features name using --name or -n');
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
      await generateFromConfig(configFilePath); // Await the function call
    } else {
      print('Please provide the config file path using --config-file or -c option.');
    }
  } else if (argResults.command?.name == 'cubit') {
    String? cubitName = argResults['name'];
    if (cubitName != null) {
      createCubitClass(cubitName);
    } else {
      print('Please provide a cubit name using --name or -n');
    }
  } else if (argResults['help'] == true || arguments.isEmpty) {
    print(parser.usage);
  } else {
    print('Invalid command. Use either "features", "init", "model", "runner", or "config".');
  }
}
