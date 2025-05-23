// lib/pub_get.dart
import 'package:process_run/process_run.dart';

Future<void> pubGet() async {
  try {
    final result = await runExecutableArguments('flutter', ['pub', 'get']);
    print(result.stdout);
    print(result.stderr);
    print('Dependencies fetched successfully.');
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> pubAdd(String packageName) async {
  try {
    final result = await runExecutableArguments('flutter', ['pub', 'add', packageName]);
    print(result.stdout);
    print(result.stderr);
    print('Package $packageName added successfully.');
  } catch (e) {
    print('Error: $e');
  }
}
