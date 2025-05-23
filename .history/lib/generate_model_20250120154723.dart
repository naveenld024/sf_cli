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

  // Handle nested complex JSON structure
  final modelClass = _generateComplexModelClass(jsonMap, className);

  final outputFile = File('$outputDirectory/${className.toLowerCase()}_response.dart');
  outputFile.writeAsStringSync(modelClass);

  print('Model class generated successfully: ${outputFile.path}');
}

String _generateComplexModelClass(Map<String, dynamic> jsonMap, String className) {
  final responseClassName = '${_toCamelCase(className)}Response';
  final dataClassName = 'Datum';

  // Detect if the JSON has a nested list structure
  final hasDataList = jsonMap.containsKey('data') && jsonMap['data'] is List;
  final dataList = hasDataList ? jsonMap['data'][0] : null;

  return '''
// To parse this JSON data, do
//
//     final $responseClassName = ${responseClassName}FromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part '${responseClassName.toLowerCase()}.freezed.dart';
part '${responseClassName.toLowerCase()}.g.dart';

$responseClassName ${responseClassName}FromJson(String str) => $responseClassName.fromJson(json.decode(str));

String ${responseClassName}ToJson($responseClassName data) => json.encode(data.toJson());

@freezed
class $responseClassName with _\$${responseClassName} {
    const factory $responseClassName({
        ${_generateConstructorFields(jsonMap)}
    }) = _$responseClassName;

    factory $responseClassName.fromJson(Map<String, dynamic> json) => _\$${responseClassName}FromJson(json);
}

${_generateNestedModelClass(dataList, dataClassName)}
''';
}

String _generateNestedModelClass(Map<String, dynamic>? dataMap, String className) {
  if (dataMap == null) return '';

  return '''
@freezed
class $className with _\$${className} {
    const factory $className({
        ${_generateDateTimeConstructorFields(dataMap)}
    }) = _$className;

    factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);
}
''';
}

String _generateConstructorFields(Map<String, dynamic> jsonMap) {
  return jsonMap.entries
      .map((entry) {
        final type = _getComplexType(entry.value);
        return 'required $type? ${entry.key},';
      })
      .join(' ');
}

String _generateDateTimeConstructorFields(Map<String, dynamic> jsonMap) {
  return jsonMap.entries
      .map((entry) {
        final type = _getComplexType(entry.value);
        return 'required $type? ${entry.key},';
      })
      .join(' ');
}

String _getComplexType(dynamic value) {
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is bool) return 'bool';
  if (value is String) {
    // Check if the string looks like a datetime
    if (_isDateTimeString(value)) return 'DateTime';
    return 'String';
  }
  if (value is List) {
    final itemType = _getComplexType(value.isNotEmpty ? value.first : null);
    return 'List<$itemType>';
  }
  return 'dynamic';
}

bool _isDateTimeString(String value) {
  // Basic datetime format check
  final dateTimeRegex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$');
  return dateTimeRegex.hasMatch(value);
}

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

String _getFileNameWithoutExtension(String filePath) {
  final fileName = path.basenameWithoutExtension(filePath);
  return _toCamelCase(fileName);
}

String _toCamelCase(String text) {
  return text.split('_').map((word) => _capitalize(word)).join('');
}