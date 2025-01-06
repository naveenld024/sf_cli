import 'dart:io';

Future<void> runBuildRunner() async {
  print('Running build_runner...');
  final result = await Process.run(
      'dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
      runInShell: true); // Ensure the command runs in the shell
  print(
      'Command executed: dart run build_runner build --delete-conflicting-outputs');
  print('Exit code: ${result.exitCode}');
  print('Stdout: ${result.stdout}');
  print('Stderr: ${result.stderr}');
  if (result.exitCode == 0) {
    print('build_runner completed successfully.');
  } else {
    print('build_runner failed with exit code ${result.exitCode}.');
  }
}