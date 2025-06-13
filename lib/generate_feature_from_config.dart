import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Enhanced configuration schema for complete feature generation
class FeatureConfig {
  final String featureName;
  final String description;
  final List<ModelConfig> models;
  final List<ApiEndpointConfig> endpoints;
  final UiConfig? uiConfig;

  FeatureConfig({
    required this.featureName,
    required this.description,
    required this.models,
    required this.endpoints,
    this.uiConfig,
  });

  factory FeatureConfig.fromJson(Map<String, dynamic> json) {
    return FeatureConfig(
      featureName: json['feature_name'] ?? '',
      description: json['description'] ?? '',
      models: (json['models'] as List<dynamic>?)
          ?.map((model) => ModelConfig.fromJson(model))
          .toList() ?? [],
      endpoints: (json['endpoints'] as List<dynamic>?)
          ?.map((endpoint) => ApiEndpointConfig.fromJson(endpoint))
          .toList() ?? [],
      uiConfig: json['ui_config'] != null 
          ? UiConfig.fromJson(json['ui_config']) 
          : null,
    );
  }
}

class ModelConfig {
  final String name;
  final String jsonFilePath;
  final bool useFreezed;

  ModelConfig({
    required this.name,
    required this.jsonFilePath,
    this.useFreezed = true,
  });

  factory ModelConfig.fromJson(Map<String, dynamic> json) {
    return ModelConfig(
      name: json['name'] ?? '',
      jsonFilePath: json['json_file_path'] ?? '',
      useFreezed: json['use_freezed'] ?? true,
    );
  }
}

class ApiEndpointConfig {
  final String name;
  final String endpoint;
  final String method;
  final String functionName;
  final Map<String, String> parameters;
  final String? returnType;

  ApiEndpointConfig({
    required this.name,
    required this.endpoint,
    required this.method,
    required this.functionName,
    required this.parameters,
    this.returnType,
  });

  factory ApiEndpointConfig.fromJson(Map<String, dynamic> json) {
    return ApiEndpointConfig(
      name: json['name'] ?? '',
      endpoint: json['endpoint'] ?? '',
      method: json['method'] ?? 'GET',
      functionName: json['function_name'] ?? '',
      parameters: Map<String, String>.from(json['parameters'] ?? {}),
      returnType: json['return_type'],
    );
  }
}

class UiConfig {
  final bool hasListScreen;
  final bool hasDetailScreen;
  final bool hasFormScreen;
  final List<String> customWidgets;

  UiConfig({
    this.hasListScreen = true,
    this.hasDetailScreen = false,
    this.hasFormScreen = false,
    this.customWidgets = const [],
  });

  factory UiConfig.fromJson(Map<String, dynamic> json) {
    return UiConfig(
      hasListScreen: json['has_list_screen'] ?? true,
      hasDetailScreen: json['has_detail_screen'] ?? false,
      hasFormScreen: json['has_form_screen'] ?? false,
      customWidgets: List<String>.from(json['custom_widgets'] ?? []),
    );
  }
}

/// Main function to generate complete feature from enhanced config
Future<void> generateFeatureFromConfig(String configFilePath, {bool useFreezed = false}) async {
  try {
    final config = await _readFeatureConfig(configFilePath);
    
    print('Generating feature: ${config.featureName}');
    print('Description: ${config.description}');
    
    // Create feature directory structure
    await _createFeatureStructure(config, useFreezed);
    
    // Generate models from JSON files
    await _generateModels(config, useFreezed);
    
    // Generate repository and service files
    await _generateRepositoryAndService(config, useFreezed);
    
    // Generate cubit/state management
    await _generateStateManagement(config, useFreezed);
    
    // Generate UI components
    await _generateUIComponents(config, useFreezed);
    
    print('✅ Feature "${config.featureName}" generated successfully!');
    print('📁 Location: lib/features/${config.featureName.toLowerCase()}');
    print('🔧 Run "sf_cli runner" to generate freezed files');
    
  } catch (e) {
    print('❌ Error generating feature: $e');
    exit(1);
  }
}

Future<FeatureConfig> _readFeatureConfig(String configFilePath) async {
  final file = File(configFilePath);
  if (!file.existsSync()) {
    throw Exception('Config file not found: $configFilePath');
  }

  final configString = await file.readAsString();
  final configJson = jsonDecode(configString);
  
  return FeatureConfig.fromJson(configJson);
}

Future<void> _createFeatureStructure(FeatureConfig config, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final featurePath = path.join('lib', 'features', featureName);

  // Create directory structure
  final directories = [
    path.join(featurePath, 'domain', 'models'),
    path.join(featurePath, 'domain', 'repository'),
    path.join(featurePath, 'domain', 'services'),
    path.join(featurePath, 'logic', featureName),
    path.join(featurePath, 'screens'),
    path.join(featurePath, 'widgets'),
  ];

  for (final dir in directories) {
    await Directory(dir).create(recursive: true);
  }

  print('📁 Created directory structure for ${config.featureName}');
}

Future<void> _generateModels(FeatureConfig config, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final featurePath = path.join('lib', 'features', featureName, 'domain', 'models');
  
  for (final modelConfig in config.models) {
    if (File(modelConfig.jsonFilePath).existsSync()) {
      print('🔧 Generating model: ${modelConfig.name}');
      
      // Generate model in the feature's models directory
      final modelName = modelConfig.name.toLowerCase();
      
      // Copy JSON to feature directory temporarily for processing
      final tempJsonPath = path.join(featurePath, '${modelName}_temp.json');
      await File(modelConfig.jsonFilePath).copy(tempJsonPath);
      
      // Generate model
      await _generateModelInFeature(tempJsonPath, modelName, featurePath);
      
      // Clean up temp file
      await File(tempJsonPath).delete();
    } else {
      print('⚠️  JSON file not found: ${modelConfig.jsonFilePath}');
    }
  }
}

String _toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}

String _toCamelCase(String input) {
  final parts = input.split('_');
  return parts.first + parts.skip(1).map((word) => word[0].toUpperCase() + word.substring(1)).join('');
}

Future<void> _generateModelInFeature(String jsonFilePath, String modelName, String outputDirectory) async {
  final file = File(jsonFilePath);
  if (!file.existsSync()) {
    print('JSON file not found: $jsonFilePath');
    return;
  }

  final jsonString = file.readAsStringSync();
  final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  final modelClassName = _toPascalCase(modelName);
  final modelContent = _generateFreezedModelClass(jsonMap, modelClassName);

  final outputFile = File('$outputDirectory/${modelName}_model.dart');
  outputFile.writeAsStringSync(modelContent);

  print('Model class generated successfully: ${outputFile.path}');
}

String _generateFreezedModelClass(Map<String, dynamic> jsonMap, String className) {
  return '''
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part '${className.toLowerCase()}_model.freezed.dart';
part '${className.toLowerCase()}_model.g.dart';

$className ${className}FromJson(String str) => $className.fromJson(json.decode(str));

String ${className}ToJson($className data) => json.encode(data.toJson());

@freezed
class $className with _\$$className {
    const factory $className({
        ${_generateConstructorFields(jsonMap)}
    }) = _$className;

    factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);
}
''';
}

String _generateConstructorFields(Map<String, dynamic> jsonMap) {
  return jsonMap.entries
      .map((entry) {
        final type = _getComplexType(entry.value);
        return '@Default(null) $type? ${entry.key},';
      })
      .join('\n        ');
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
    if (value.isEmpty) return 'List<dynamic>';
    final itemType = _getComplexType(value.first);
    return 'List<$itemType>';
  }
  if (value is Map) return 'Map<String, dynamic>';
  return 'dynamic';
}

bool _isDateTimeString(String value) {
  // Basic datetime format check
  final dateTimeRegex = RegExp(r'^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}');
  return dateTimeRegex.hasMatch(value);
}

Future<void> _generateRepositoryAndService(FeatureConfig config, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final featureNamePascal = _toPascalCase(featureName);
  final featurePath = path.join('lib', 'features', featureName);

  // Generate repository
  await _generateRepository(config, featurePath, featureNamePascal);

  // Generate service
  await _generateService(config, featurePath, featureNamePascal);
}

Future<void> _generateRepository(FeatureConfig config, String featurePath, String featureNamePascal) async {
  final featureName = config.featureName.toLowerCase();
  final repositoryPath = path.join(featurePath, 'domain', 'repository', '${featureName}_repository.dart');

  // Generate import statements for models
  final modelImports = config.models.map((model) {
    return "import '../models/${model.name.toLowerCase()}_model.dart';";
  }).join('\n');

  // Generate repository methods based on endpoints
  final methods = config.endpoints.map((endpoint) {
    final parameters = endpoint.parameters.entries
        .map((entry) => 'required ${entry.value} ${_toCamelCase(entry.key)}')
        .join(', ');

    // Use proper return type or default to ResponseResult
    final returnType = endpoint.returnType ?? 'ResponseResult<dynamic>';

    return '  Future<$returnType> ${endpoint.functionName}({$parameters});';
  }).join('\n\n');

  final repositoryContent = '''
import 'package:sf_app/core/result.dart';
$modelImports

abstract class ${featureNamePascal}Repository {
  const ${featureNamePascal}Repository();

$methods
}
''';

  await File(repositoryPath).writeAsString(repositoryContent);
  print('📄 Generated repository: ${featureNamePascal}Repository');
}

Future<void> _generateService(FeatureConfig config, String featurePath, String featureNamePascal) async {
  final featureName = config.featureName.toLowerCase();
  final servicePath = path.join(featurePath, 'domain', 'services', '${featureName}_service.dart');

  // Generate import statements
  final modelImports = config.models.map((model) {
    return "import '../models/${model.name.toLowerCase()}_model.dart';";
  }).join('\n');

  // Generate service methods based on endpoints
  final methods = config.endpoints.map((endpoint) {
    final parameters = endpoint.parameters.entries
        .map((entry) => 'required ${entry.value} ${_toCamelCase(entry.key)}')
        .join(', ');

    final returnType = endpoint.returnType ?? 'ResponseResult<dynamic>';
    final httpMethod = endpoint.method.toLowerCase();

    // Generate proper model parsing based on return type
    String modelParsing = 'return ResponseResult(data: response.data);';
    if (returnType.contains('<') && returnType.contains('>')) {
      final modelType = returnType.substring(returnType.indexOf('<') + 1, returnType.indexOf('>'));
      if (modelType != 'dynamic') {
        modelParsing = 'return ResponseResult(data: $modelType.fromJson(response.data));';
      }
    }

    return '''
  @override
  Future<$returnType> ${endpoint.functionName}({$parameters}) async {
    try {
      final Response response = await NetworkProvider().$httpMethod(
        '${endpoint.endpoint}',
        options: Options(
          headers: {'auth': false},
        ),
        force: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['code'] == 200) {
          $modelParsing
        } else {
          return ResponseResult(error: response.data['msg']);
        }
      } else {
        return ResponseResult(error: 'Failed to ${endpoint.functionName}');
      }
    } on DioException catch (e) {
      return ResponseResult(error: e.error.toString());
    }
  }''';
  }).join('\n\n');

  final serviceContent = '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/endpoint/api_endpoints.dart';
import '../../../../core/api/network/network.dart';
import '../../../../core/result.dart';
$modelImports
import '../repository/${featureName}_repository.dart';

@Injectable(as: ${featureNamePascal}Repository)
class ${featureNamePascal}Service implements ${featureNamePascal}Repository {
$methods
}
''';

  await File(servicePath).writeAsString(serviceContent);
  print('📄 Generated service: ${featureNamePascal}Service');
}

Future<void> _generateStateManagement(FeatureConfig config, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final featureNamePascal = _toPascalCase(featureName);
  final featurePath = path.join('lib', 'features', featureName);

  if (useFreezed) {
    await _generateFreezedCubit(config, featurePath, featureNamePascal);
  } else {
    await _generateRegularCubit(config, featurePath, featureNamePascal);
  }
}

Future<void> _generateFreezedCubit(FeatureConfig config, String featurePath, String featureNamePascal) async {
  final featureName = config.featureName.toLowerCase();
  final cubitPath = path.join(featurePath, 'logic', featureName, '${featureName}_cubit.dart');
  final statePath = path.join(featurePath, 'logic', featureName, '${featureName}_state.dart');

  // Generate model imports
  final modelImports = config.models.map((model) {
    return "import '../../domain/models/${model.name.toLowerCase()}_model.dart';";
  }).join('\n');

  // Determine the primary model type for the state
  final primaryModelType = config.models.isNotEmpty
      ? _toPascalCase(config.models.first.name)
      : 'dynamic';

  // Generate cubit methods based on endpoints
  final cubitMethods = config.endpoints.map((endpoint) {
    final parameters = endpoint.parameters.entries
        .map((entry) => 'required ${entry.value} ${_toCamelCase(entry.key)}')
        .join(', ');

    final parameterCall = endpoint.parameters.keys
        .map((key) => '${_toCamelCase(key)}: ${_toCamelCase(key)}')
        .join(', ');

    return '''
  Future<void> ${endpoint.functionName}({$parameters}) async {
    emit(state.copyWith(status: DataStatus.loading));
    try {
      final result = await _${featureName}Service.${endpoint.functionName}($parameterCall);
      if (result.data != null) {
        emit(
          state.copyWith(
            status: DataStatus.success,
            data: result.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DataStatus.failed,
            error: result.error,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: DataStatus.failed, error: e.toString()));
    }
  }''';
  }).join('\n\n');

  final cubitContent = '''
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sf_app/core/constants/enums.dart';

$modelImports
import '../../domain/repository/${featureName}_repository.dart';

part '${featureName}_state.dart';
part '${featureName}_cubit.freezed.dart';

@injectable
class ${featureNamePascal}Cubit extends Cubit<${featureNamePascal}State> {
  final ${featureNamePascal}Repository _${featureName}Service;
  ${featureNamePascal}Cubit(this._${featureName}Service) : super(const ${featureNamePascal}State());

$cubitMethods
}
''';

  final stateContent = '''
part of '${featureName}_cubit.dart';

@freezed
class ${featureNamePascal}State with _\$${featureNamePascal}State {
  const factory ${featureNamePascal}State({
    @Default(DataStatus.idle) DataStatus status,
    $primaryModelType? data,
    String? error,
  }) = _${featureNamePascal}State;
}
''';

  await File(cubitPath).writeAsString(cubitContent);
  await File(statePath).writeAsString(stateContent);

  print('📄 Generated freezed cubit: ${featureNamePascal}Cubit');
}

Future<void> _generateRegularCubit(FeatureConfig config, String featurePath, String featureNamePascal) async {
  final featureName = config.featureName.toLowerCase();
  final cubitPath = path.join(featurePath, 'logic', featureName, '${featureName}_cubit.dart');
  final statePath = path.join(featurePath, 'logic', featureName, '${featureName}_state.dart');

  // Generate model imports
  final modelImports = config.models.map((model) {
    return "import '../../domain/models/${model.name.toLowerCase()}_model.dart';";
  }).join('\n');

  // Determine the primary model type for the state
  final primaryModelType = config.models.isNotEmpty
      ? _toPascalCase(config.models.first.name)
      : 'dynamic';

  // Generate cubit methods based on endpoints
  final cubitMethods = config.endpoints.map((endpoint) {
    final parameters = endpoint.parameters.entries
        .map((entry) => 'required ${entry.value} ${_toCamelCase(entry.key)}')
        .join(', ');

    final parameterCall = endpoint.parameters.keys
        .map((key) => '${_toCamelCase(key)}: ${_toCamelCase(key)}')
        .join(', ');

    return '''
  Future<void> ${endpoint.functionName}({$parameters}) async {
    emit(${featureNamePascal}Loading());
    try {
      final result = await _${featureName}Service.${endpoint.functionName}($parameterCall);
      if (result.data != null) {
        emit(${featureNamePascal}Success(result.data));
      } else {
        emit(${featureNamePascal}Error(result.error ?? 'Unknown error'));
      }
    } catch (e) {
      emit(${featureNamePascal}Error(e.toString()));
    }
  }''';
  }).join('\n\n');

  final cubitContent = '''
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

$modelImports
import '../../domain/repository/${featureName}_repository.dart';

part '${featureName}_state.dart';

@injectable
class ${featureNamePascal}Cubit extends Cubit<${featureNamePascal}State> {
  final ${featureNamePascal}Repository _${featureName}Service;
  ${featureNamePascal}Cubit(this._${featureName}Service) : super(${featureNamePascal}Initial());

$cubitMethods
}
''';

  final stateContent = '''
part of '${featureName}_cubit.dart';

sealed class ${featureNamePascal}State extends Equatable {
  const ${featureNamePascal}State();

  @override
  List<Object?> get props => [];
}

final class ${featureNamePascal}Initial extends ${featureNamePascal}State {}

final class ${featureNamePascal}Loading extends ${featureNamePascal}State {}

final class ${featureNamePascal}Success extends ${featureNamePascal}State {
  final $primaryModelType? data;

  const ${featureNamePascal}Success(this.data);

  @override
  List<Object?> get props => [data];
}

final class ${featureNamePascal}Error extends ${featureNamePascal}State {
  final String message;

  const ${featureNamePascal}Error(this.message);

  @override
  List<Object?> get props => [message];
}
''';

  await File(cubitPath).writeAsString(cubitContent);
  await File(statePath).writeAsString(stateContent);

  print('📄 Generated regular cubit: ${featureNamePascal}Cubit');
}

Future<void> _generateUIComponents(FeatureConfig config, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final featureNamePascal = _toPascalCase(featureName);
  final featurePath = path.join('lib', 'features', featureName);

  // Generate main screen
  await _generateMainScreen(config, featurePath, featureNamePascal, useFreezed);

  // Generate widgets
  await _generateWidgets(config, featurePath, featureNamePascal);

  // Generate additional screens based on UI config
  if (config.uiConfig != null) {
    if (config.uiConfig!.hasDetailScreen) {
      await _generateDetailScreen(config, featurePath, featureNamePascal, useFreezed);
    }
    if (config.uiConfig!.hasFormScreen) {
      await _generateFormScreen(config, featurePath, featureNamePascal, useFreezed);
    }
  }
}

Future<void> _generateMainScreen(FeatureConfig config, String featurePath, String featureNamePascal, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final screenPath = path.join(featurePath, 'screens', '${featureName}_screen.dart');

  // Determine the primary model type for the UI
  final primaryModelType = config.models.isNotEmpty
      ? _toPascalCase(config.models.first.name)
      : 'dynamic';

  final stateHandling = useFreezed ? '''
            if (state.status == DataStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == DataStatus.failed) {
              return Center(child: Text(state.error ?? 'An error occurred'));
            } else if (state.data == null) {
              return const Center(child: Text('No data available'));
            }

            return _buildContent(state.data, context);''' : '''
            if (state is ${featureNamePascal}Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ${featureNamePascal}Error) {
              return Center(child: Text(state.message));
            } else if (state is ${featureNamePascal}Success) {
              return _buildContent(state.data, context);
            }

            return const Center(child: Text('Welcome to $featureNamePascal'));''';

  final screenContent = '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
${useFreezed ? "import 'package:sf_app/core/constants/enums.dart';" : ""}

import '../../../core/dependency_injection/injectable.dart';
import '../logic/$featureName/${featureName}_cubit.dart';

class ${featureNamePascal}Screen extends StatelessWidget {
  const ${featureNamePascal}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$featureNamePascal'),
      ),
      body: BlocProvider(
        create: (context) => getIt<${featureNamePascal}Cubit>(),
        child: BlocBuilder<${featureNamePascal}Cubit, ${featureNamePascal}State>(
          builder: (context, state) {
$stateHandling
          },
        ),
      ),
    );
  }

  Widget _buildContent($primaryModelType? data, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$featureNamePascal Content'),
          const SizedBox(height: 16),
          Text('Data: \$data'),
          // TODO: Implement your UI based on the data
          // The data parameter is now properly typed as $primaryModelType?
        ],
      ),
    );
  }
}
''';

  await File(screenPath).writeAsString(screenContent);
  print('📄 Generated screen: ${featureNamePascal}Screen');
}

Future<void> _generateWidgets(FeatureConfig config, String featurePath, String featureNamePascal) async {
  final featureName = config.featureName.toLowerCase();
  final widgetPath = path.join(featurePath, 'widgets', '${featureName}_widget.dart');

  final widgetContent = '''
import 'package:flutter/material.dart';

class ${featureNamePascal}Widget extends StatelessWidget {
  const ${featureNamePascal}Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '$featureNamePascal Widget',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // TODO: Implement your custom widget content
        ],
      ),
    );
  }
}
''';

  await File(widgetPath).writeAsString(widgetContent);
  print('📄 Generated widget: ${featureNamePascal}Widget');
}

Future<void> _generateDetailScreen(FeatureConfig config, String featurePath, String featureNamePascal, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final screenPath = path.join(featurePath, 'screens', '${featureName}_detail_screen.dart');

  final screenContent = '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dependency_injection/injectable.dart';
import '../logic/$featureName/${featureName}_cubit.dart';

class ${featureNamePascal}DetailScreen extends StatelessWidget {
  final dynamic itemId;

  const ${featureNamePascal}DetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$featureNamePascal Details'),
      ),
      body: BlocProvider(
        create: (context) => getIt<${featureNamePascal}Cubit>(),
        child: BlocBuilder<${featureNamePascal}Cubit, ${featureNamePascal}State>(
          builder: (context, state) {
            return const Center(
              child: Text('Detail Screen - TODO: Implement details view'),
            );
          },
        ),
      ),
    );
  }
}
''';

  await File(screenPath).writeAsString(screenContent);
  print('📄 Generated detail screen: ${featureNamePascal}DetailScreen');
}

Future<void> _generateFormScreen(FeatureConfig config, String featurePath, String featureNamePascal, bool useFreezed) async {
  final featureName = config.featureName.toLowerCase();
  final screenPath = path.join(featurePath, 'screens', '${featureName}_form_screen.dart');

  final screenContent = '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dependency_injection/injectable.dart';
import '../logic/$featureName/${featureName}_cubit.dart';

class ${featureNamePascal}FormScreen extends StatefulWidget {
  const ${featureNamePascal}FormScreen({super.key});

  @override
  State<${featureNamePascal}FormScreen> createState() => _${featureNamePascal}FormScreenState();
}

class _${featureNamePascal}FormScreenState extends State<${featureNamePascal}FormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$featureNamePascal Form'),
      ),
      body: BlocProvider(
        create: (context) => getIt<${featureNamePascal}Cubit>(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // TODO: Add form fields based on your model
                const Text('Form Screen - TODO: Implement form fields'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Handle form submission
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
''';

  await File(screenPath).writeAsString(screenContent);
  print('📄 Generated form screen: ${featureNamePascal}FormScreen');
}
