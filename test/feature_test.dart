// test/feature_test.dart
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import '../lib/feature.dart';

void main() {
  group('Feature Creation Tests', () {
    final testFeatureName = 'test_feature';

    setUp(() {
      // Clean up before running tests
      final featurePath =
          path.join('lib', 'features', testFeatureName.toLowerCase());
      final directory = Directory(featurePath);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    test('Creates features folder structure and files', () {
      createFeature(testFeatureName);

      final featurePath =
          path.join('lib', 'features', testFeatureName.toLowerCase());
      final expectedPaths = [
        path.join(featurePath, 'domain', 'models',
            '${testFeatureName.toLowerCase()}_model.dart'),
        path.join(featurePath, 'domain', 'repository',
            '${testFeatureName.toLowerCase()}_repository.dart'),
        path.join(featurePath, 'domain', 'services',
            '${testFeatureName.toLowerCase()}_service.dart'),
        path.join(featurePath, 'logic', testFeatureName.toLowerCase(),
            '${testFeatureName.toLowerCase()}_cubit.dart'),
        path.join(featurePath, 'logic', testFeatureName.toLowerCase(),
            '${testFeatureName.toLowerCase()}_state.dart'),
        path.join(featurePath, 'screens',
            '${testFeatureName.toLowerCase()}_screen.dart'),
        path.join(featurePath, 'widgets',
            '${testFeatureName.toLowerCase()}_widget.dart'),
      ];

      for (final expectedPath in expectedPaths) {
        expect(File(expectedPath).existsSync(), isTrue,
            reason: '$expectedPath should exist');
      }
    });

    tearDown(() {
      // Clean up after running tests
      final featurePath =
          path.join('lib', 'features', testFeatureName.toLowerCase());
      final directory = Directory(featurePath);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });
  });
}
