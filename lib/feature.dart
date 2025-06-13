// features.dart
import 'dart:io';
import 'package:path/path.dart' as path;

void createFeature(String featureName, {bool useFreezed = false}) {
  final featurePath = path.join('lib', 'features', featureName.toLowerCase());
  final featureNameCapitalized = toPascalCase(featureName.toLowerCase());

  // Create directory structure
  Directory(path.join(featurePath, 'domain', 'models'))
      .createSync(recursive: true);
  Directory(path.join(featurePath, 'domain', 'repository'))
      .createSync(recursive: true);
  Directory(path.join(featurePath, 'domain', 'services'))
      .createSync(recursive: true);
  Directory(path.join(featurePath, 'logic', featureName.toLowerCase()))
      .createSync(recursive: true);
  Directory(path.join(featurePath, 'screens')).createSync(recursive: true);
  Directory(path.join(featurePath, 'widgets')).createSync(recursive: true);

  // Create files with content
  createFileWithContent(
    path.join(featurePath, 'domain', 'models',
        '${featureName.toLowerCase()}_model.dart'),
    '// TODO: Implement $featureNameCapitalized model',
  );

  createFileWithContent(
    path.join(featurePath, 'domain', 'repository',
        '${featureName.toLowerCase()}_repository.dart'),
    '''abstract class ${featureNameCapitalized}Repository {
  const ${featureNameCapitalized}Repository();

  Future<int?> someFunctionName({required String s});
}''',
  );

  createFileWithContent(
    path.join(featurePath, 'domain', 'services',
        '${featureName.toLowerCase()}_service.dart'),
    '''import '../repository/${featureName.toLowerCase()}_repository.dart';

class ${featureNameCapitalized}Service implements ${featureNameCapitalized}Repository {

  @override
  Future<int?> someFunctionName({required String s}) async {
    // TODO: implement function
    throw UnimplementedError();
  }
}''',
  );

  if (useFreezed) {
    _createFreezedCubitFiles(featurePath, featureName, featureNameCapitalized);
  } else {
    _createRegularCubitFiles(featurePath, featureName, featureNameCapitalized);
  }

  createFileWithContent(
    path.join(
        featurePath, 'screens', '${featureName.toLowerCase()}_screen.dart'),
    '''import 'package:flutter/material.dart';

class ${featureNameCapitalized}Screen extends StatelessWidget {
  const ${featureNameCapitalized}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('${featureNameCapitalized}Screen'),
      ),
    );
  }
}''',
  );

  createFileWithContent(
    path.join(
        featurePath, 'widgets', '${featureName.toLowerCase()}_widget.dart'),
    '// TODO: Implement $featureNameCapitalized widget',
  );

  createFileWithContent(
      path.join(featurePath, '${featureName.toLowerCase()}_config.json'), '''{
  "model1": {
    "model_class_relative_path": "<your folder_path>/${featureName.toLowerCase()}.json",
    "end_point": "/sample",
    "method": "get", 
    "function_name": "sample",
    "parameters": {
      "parameter_name": "parameter_type"
    }
  }
}''');

  print(
      "Feature folder structure and files created for $featureNameCapitalized${useFreezed ? ' (with Freezed)' : ''}!");
}

void createFileWithContent(String filePath, String content) {
  final file = File(filePath);
  file.writeAsStringSync(content);
}

void _createRegularCubitFiles(String featurePath, String featureName, String featureNameCapitalized) {
  createFileWithContent(
    path.join(featurePath, 'logic', featureName.toLowerCase(),
        '${featureName.toLowerCase()}_cubit.dart'),
    '''import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '${featureName.toLowerCase()}_state.dart';

class ${featureNameCapitalized}Cubit extends Cubit<${featureNameCapitalized}State> {
  ${featureNameCapitalized}Cubit() : super(${featureNameCapitalized}Initial());
}''',
  );

  createFileWithContent(
    path.join(featurePath, 'logic', featureName.toLowerCase(),
        '${featureName.toLowerCase()}_state.dart'),
    '''part of '${featureName.toLowerCase()}_cubit.dart';

sealed class ${featureNameCapitalized}State extends Equatable {
  const ${featureNameCapitalized}State();

  @override
  List<Object> get props => [];
}

final class ${featureNameCapitalized}Initial extends ${featureNameCapitalized}State {}''',
  );
}

void _createFreezedCubitFiles(String featurePath, String featureName, String featureNameCapitalized) {
  createFileWithContent(
    path.join(featurePath, 'logic', featureName.toLowerCase(),
        '${featureName.toLowerCase()}_cubit.dart'),
    '''import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '${featureName.toLowerCase()}_state.dart';
part '${featureName.toLowerCase()}_cubit.freezed.dart';

class ${featureNameCapitalized}Cubit extends Cubit<${featureNameCapitalized}State> {
  ${featureNameCapitalized}Cubit() : super(const ${featureNameCapitalized}State.initial());
}''',
  );

  createFileWithContent(
    path.join(featurePath, 'logic', featureName.toLowerCase(),
        '${featureName.toLowerCase()}_state.dart'),
    '''part of '${featureName.toLowerCase()}_cubit.dart';

@freezed
class ${featureNameCapitalized}State with _\$${featureNameCapitalized}State {
  const factory ${featureNameCapitalized}State.initial() = _Initial;
  const factory ${featureNameCapitalized}State.loading() = _Loading;
  const factory ${featureNameCapitalized}State.success() = _Success;
  const factory ${featureNameCapitalized}State.error(String message) = _Error;
}''',
  );
}

String toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}
