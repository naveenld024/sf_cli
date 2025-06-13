import 'dart:io';
import 'package:path/path.dart' as path;

void createBlocClass(String blocName, {bool useFreezed = false}) {
  final blocPath = path.join('lib', 'features', blocName.toLowerCase());
  final blocNameCapitalized = _toPascalCase(blocName.toLowerCase());

  final blocFilePath = path.join(blocPath,
      '${blocName.toLowerCase()}_bloc.dart');
  final eventFilePath = path.join(blocPath,
      '${blocName.toLowerCase()}_event.dart');
  final stateFilePath = path.join(blocPath,
      '${blocName.toLowerCase()}_state.dart');

  // Check if bloc files already exist
  if (File(blocFilePath).existsSync() || File(eventFilePath).existsSync() || File(stateFilePath).existsSync()) {
    print("Bloc files for $blocNameCapitalized already exist!");
    return;
  }

  // Ensure the feature directory exists
  Directory(blocPath).createSync(recursive: true);

  if (useFreezed) {
    _createFreezedBlocFiles(blocName, blocNameCapitalized, blocFilePath, eventFilePath, stateFilePath);
  } else {
    _createRegularBlocFiles(blocName, blocNameCapitalized, blocFilePath, eventFilePath, stateFilePath);
  }

  print("Bloc files created for $blocNameCapitalized${useFreezed ? ' (with Freezed)' : ''}!");
}

void _createRegularBlocFiles(String blocName, String blocNameCapitalized, String blocFilePath, String eventFilePath, String stateFilePath) {
  // Create Bloc file
  _createFileWithContent(
    blocFilePath,
    '''import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '${blocName.toLowerCase()}_event.dart';
part '${blocName.toLowerCase()}_state.dart';

class ${blocNameCapitalized}Bloc extends Bloc<${blocNameCapitalized}Event, ${blocNameCapitalized}State> {
  ${blocNameCapitalized}Bloc() : super(${blocNameCapitalized}Initial()) {
    on<${blocNameCapitalized}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}''',
  );

  // Create Event file
  _createFileWithContent(
    eventFilePath,
    '''part of '${blocName.toLowerCase()}_bloc.dart';

sealed class ${blocNameCapitalized}Event extends Equatable {
  const ${blocNameCapitalized}Event();

  @override
  List<Object> get props => [];
}''',
  );

  // Create State file
  _createFileWithContent(
    stateFilePath,
    '''part of '${blocName.toLowerCase()}_bloc.dart';

sealed class ${blocNameCapitalized}State extends Equatable {
  const ${blocNameCapitalized}State();

  @override
  List<Object> get props => [];
}

final class ${blocNameCapitalized}Initial extends ${blocNameCapitalized}State {}''',
  );
}

void _createFreezedBlocFiles(String blocName, String blocNameCapitalized, String blocFilePath, String eventFilePath, String stateFilePath) {
  // Create Bloc file
  _createFileWithContent(
    blocFilePath,
    '''import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '${blocName.toLowerCase()}_event.dart';
part '${blocName.toLowerCase()}_state.dart';
part '${blocName.toLowerCase()}_bloc.freezed.dart';

class ${blocNameCapitalized}Bloc extends Bloc<${blocNameCapitalized}Event, ${blocNameCapitalized}State> {
  ${blocNameCapitalized}Bloc() : super(const ${blocNameCapitalized}State.initial()) {
    on<${blocNameCapitalized}Event>((event, emit) {
      event.when(
        // TODO: implement event handlers
      );
    });
  }
}''',
  );

  // Create Event file
  _createFileWithContent(
    eventFilePath,
    '''part of '${blocName.toLowerCase()}_bloc.dart';

@freezed
class ${blocNameCapitalized}Event with _\$${blocNameCapitalized}Event {
  const factory ${blocNameCapitalized}Event.started() = _Started;
  // TODO: Add more events as needed
}''',
  );

  // Create State file
  _createFileWithContent(
    stateFilePath,
    '''part of '${blocName.toLowerCase()}_bloc.dart';

@freezed
class ${blocNameCapitalized}State with _\$${blocNameCapitalized}State {
  const factory ${blocNameCapitalized}State.initial() = _Initial;
  const factory ${blocNameCapitalized}State.loading() = _Loading;
  const factory ${blocNameCapitalized}State.success() = _Success;
  const factory ${blocNameCapitalized}State.error(String message) = _Error;
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
