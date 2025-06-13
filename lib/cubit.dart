import 'dart:io';
import 'package:path/path.dart' as path;

void createCubitClass(String cubitName, {bool useFreezed = false}) {
  final cubitPath = path.join('lib', 'features', cubitName.toLowerCase());
  final cubitNameCapitalized = _toPascalCase(cubitName.toLowerCase());

  final cubitFilePath = path.join(cubitPath,
      '${cubitName.toLowerCase()}_cubit.dart');
  final stateFilePath = path.join(cubitPath,
      '${cubitName.toLowerCase()}_state.dart');

  // Check if cubit files already exist
  if (File(cubitFilePath).existsSync() || File(stateFilePath).existsSync()) {
    print("Cubit files for $cubitNameCapitalized already exist!");
    return;
  }

  // Ensure the feature directory exists
  Directory(cubitPath).createSync(recursive: true);

  if (useFreezed) {
    _createFreezedCubitFiles(cubitName, cubitNameCapitalized, cubitFilePath, stateFilePath);
  } else {
    _createRegularCubitFiles(cubitName, cubitNameCapitalized, cubitFilePath, stateFilePath);
  }

  print("Cubit files created for $cubitNameCapitalized${useFreezed ? ' (with Freezed)' : ''}!");
}

void _createRegularCubitFiles(String cubitName, String cubitNameCapitalized, String cubitFilePath, String stateFilePath) {
  // Create Cubit file
  _createFileWithContent(
    cubitFilePath,
    '''import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '${cubitName.toLowerCase()}_state.dart';

class ${cubitNameCapitalized}Cubit extends Cubit<${cubitNameCapitalized}State> {
  ${cubitNameCapitalized}Cubit() : super(${cubitNameCapitalized}Initial());
}''',
  );

  // Create State file
  _createFileWithContent(
    stateFilePath,
    '''part of '${cubitName.toLowerCase()}_cubit.dart';

sealed class ${cubitNameCapitalized}State extends Equatable {
  const ${cubitNameCapitalized}State();

  @override
  List<Object> get props => [];
}

final class ${cubitNameCapitalized}Initial extends ${cubitNameCapitalized}State {}''',
  );
}

void _createFreezedCubitFiles(String cubitName, String cubitNameCapitalized, String cubitFilePath, String stateFilePath) {
  // Create Cubit file
  _createFileWithContent(
    cubitFilePath,
    '''import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '${cubitName.toLowerCase()}_state.dart';
part '${cubitName.toLowerCase()}_cubit.freezed.dart';

class ${cubitNameCapitalized}Cubit extends Cubit<${cubitNameCapitalized}State> {
  ${cubitNameCapitalized}Cubit() : super(const ${cubitNameCapitalized}State.initial());
}''',
  );

  // Create State file
  _createFileWithContent(
    stateFilePath,
    '''part of '${cubitName.toLowerCase()}_cubit.dart';

@freezed
class ${cubitNameCapitalized}State with _\$${cubitNameCapitalized}State {
  const factory ${cubitNameCapitalized}State.initial() = _Initial;
  const factory ${cubitNameCapitalized}State.loading() = _Loading;
  const factory ${cubitNameCapitalized}State.success() = _Success;
  const factory ${cubitNameCapitalized}State.error(String message) = _Error;
}''',
  );
}

void _createFileWithContent(String filePath, String content) {
  final file = File(filePath);
  file.writeAsStringSync(content);
}

String _toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}
