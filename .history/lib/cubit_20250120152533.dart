void createCubitClass(String cubitName) {
  final cubitPath = path.join('lib', 'features', cubitName.toLowerCase());
  final cubitNameCapitalized = toPascalCase(cubitName.toLowerCase());

  // Ensure the logic directory exists
  Directory(path.join(cubitPath, 'logic', cubitName.toLowerCase()))
      .createSync(recursive: true);

  // Create Cubit file
  createFileWithContent(
    path.join(cubitPath, 'logic', cubitName.toLowerCase(),
        '${cubitName.toLowerCase()}_cubit.dart'),
    '''import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '${cubitName.toLowerCase()}_state.dart';

class ${cubitNameCapitalized}Cubit extends Cubit<${cubitNameCapitalized}State> {
  ${cubitNameCapitalized}Cubit() : super(${cubitNameCapitalized}Initial());
}''',
  );

  // Create State file
  createFileWithContent(
    path.join(cubitPath, 'logic', cubitName.toLowerCase(),
        '${cubitName.toLowerCase()}_state.dart'),
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
