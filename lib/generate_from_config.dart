import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'generate_model.dart';

Future<void> generateFromConfig(String configFilePath) async {
  final config = await readConfigFile(configFilePath);

  // Iterate over each model configuration
  for (var modelConfig in config.values) {
    generateModelClasses(modelConfig['model_class_relative_path']);
    modifyRepositoryFile(modelConfig);
  }
}

void modifyRepositoryFile(Map<String, dynamic> modelConfig) {
  final functionName = modelConfig['function_name'];
  final parameters = modelConfig['parameters'];
  final modelClassRelativePath = modelConfig['model_class_relative_path'];
  final modelDirectory = path.dirname(modelClassRelativePath);
  final repositoryDirectory = path.join(modelDirectory, '..', 'repository');
  final repositoryFileName = '${_getFileNameWithoutExtension(modelClassRelativePath).toLowerCase()}_repository.dart';
  final repositoryPath = path.join(repositoryDirectory, repositoryFileName);
  final repositoryFile = File(repositoryPath);

  if (!repositoryFile.existsSync()) {
    print('Repository file not found at $repositoryPath.');
    return;
  }

  final repositoryContent = repositoryFile.readAsStringSync();
  print('Current repository content:\n$repositoryContent'); // Debug print

  if (!repositoryContent.contains('$functionName({')) {
    final functionParameters = parameters.entries
        .map((entry) => 'required ${_getType(entry.value)} ${_toCamelCase(entry.key)}')
        .join(', ');

    final modelClassName = _toCamelCase(_getFileNameWithoutExtension(modelClassRelativePath));

    final newFunction = '''
  Future<$modelClassName?> $functionName({$functionParameters});
''';

    final updatedContent = repositoryContent.replaceFirstMapped(
      RegExp(r'(abstract class\s+\w+Repository\s*{)'),
      (match) => '${match.group(0)}\n$newFunction',
    );

    print('Updated repository content:\n$updatedContent'); // Debug print

    repositoryFile.writeAsStringSync(updatedContent);
    print('Repository file updated successfully: $repositoryPath');
  } else {
    print('Function $functionName already exists in repository.');
  }
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String _getFileNameWithoutExtension(String filePath) {
  final fileName = path.basenameWithoutExtension(filePath);
  return fileName;
}

String _toCamelCase(String text) {
  final parts = text.split('_');
  return parts.first + parts.skip(1).map((word) => _capitalize(word)).join('');
}

String _getType(dynamic value) {
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is List) return 'List<${_getType(value.first)}>';
  return 'String';
}

Future<Map<String, dynamic>> readConfigFile(String configFilePath) async {
  final file = File(configFilePath);
  if (!file.existsSync()) {
    print('Config file not found!');
    exit(1);
  }

  final configString = await file.readAsString();
  return jsonDecode(configString); // Ensure jsonDecode is used correctly
}