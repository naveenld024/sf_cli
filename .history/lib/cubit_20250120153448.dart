import 'dart:io';
import 'package:path/path.dart' as path;

void createCubitClass(String cubitName) {
  final cubitPath = path.join('lib', 'features', cubitName.toLowerCase());
  final cubitNameCapitalized = toPascalCase(cubitName.toLowerCase());
  final logicPath = path.join(cubitPath, 'logic', cubitName.toLowerCase());
  final cubitFilePath = path.join(logicPath, '${cubitName.toLowerCase()}_cubit.dart');
  final stateFilePath = path.join(logicPath, '${cubitName.toLowerCase()}_state.dart');

  // Check if cubit files already exist
  if (File(cubitFilePath).existsSync() || File(stateFilePath).existsSync()) {
    print("Cubit for $cubitNameCapitalized already exists. Skipping creation.");
    return;
  }

  // Ensure the logic directory exists
  Directory(logicPath).createSync(recursive: true);

  // Create Cubit file
  createFileWithContent(
    cubitFilePath,
    '''import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '${cubitName.toLowerCase()}_state.dart';

class ${cubitNameCapitalized}Cubit extends Cubit<${cubitNameCapitalized}State> {
  ${cubitNameCapitalized}Cubit() : super(${cubitNameCapitalized}Initial());
}''',
  );

  // Create State file
  createFileWithContent(
    stateFilePath,
    '''part of '${cubitName.toLowerCase()}_cubit.dart';

sealed class ${cubitNameCapitalized}State extends Equatable {
  const ${cubitNameCapitalized}State();
  
  @override
  List<Object> get props => [];
}

final class ${cubitNameCapitalized}Initial extends ${cubitNameCapitalized}State {}''',
  );

  print("Cubit files created for $cubitNameCapitalized!");
}

void createFileWithContent(String filePath, String content) {
  final file = File(filePath);
  file.writeAsStringSync(content);
}

String toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}
