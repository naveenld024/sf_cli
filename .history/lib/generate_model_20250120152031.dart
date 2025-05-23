import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

void generateModelClasses(String inputPath) {
  print('Input path provided: $inputPath'); // Debug print
  final absolutePath = path.absolute(inputPath);
  print('Absolute path: $absolutePath'); // Debug print

  final file = File(absolutePath);

  if (file.existsSync()) {
    print('Processing file: $absolutePath');
    final fileNameWithoutExtension = _getFileNameWithoutExtension(absolutePath);
    final outputDirectory = path.dirname(absolutePath);
    _generateModelClass(absolutePath, fileNameWithoutExtension, outputDirectory);
  } else {
    print('File not found: $absolutePath');
  }
}

void _generateModelClass(String jsonFilePath, String className, String outputDirectory) {
  final file = File(jsonFilePath);
  if (!file.existsSync()) {
    print('JSON file not found: $jsonFilePath');
    return;
  }

  final jsonString = file.readAsStringSync();
  final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  final fields = _generateFields(jsonMap);
  final constructorFields = _generateConstructorFields(jsonMap);

  final modelClass = '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${className.toLowerCase()}.freezed.dart';
part '${className.toLowerCase()}.g.dart';

@freezed
class $className with _\$${className} {
  const factory $className({
    $constructorFields
  }) = _${className};

  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);
}
  ''';

  final outputFile = File('$outputDirectory/${className.toLowerCase()}.dart');
  outputFile.writeAsStringSync(modelClass);

  print('Model class generated successfully: ${outputFile.path}');
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String _getFileNameWithoutExtension(String filePath) {
  final fileName = path.basenameWithoutExtension(filePath);
  return _toCamelCase(fileName);
}

String _toCamelCase(String text) {
  return text.split('_').map((word) => _capitalize(word)).join('');
}

String _generateFields(Map<String, dynamic> jsonMap) {
  return jsonMap.entries
      .map((entry) => 'final ${_getType(entry.value)} ${entry.key};')
      .join('\n  ');
}

String _getType(dynamic value) {
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is List) return 'List<${_getType(value.first)}>';
  return 'String';
}

String _generateConstructorFields(Map<String, dynamic> jsonMap) {
  return jsonMap.entries
      .map((entry) => 'required ${_getType(entry.value)} ${entry.key},')
      .join(' ');
}