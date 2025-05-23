// lib/init.dart
import 'dart:io';

Future<void> initializeProject() async {
  try {
    var currentDir = Directory.current;
    var projectName = currentDir.path.split(Platform.pathSeparator).last;

    // Set up directory structure
    final directories = [
      'lib/features/auth/domain/models',
      'lib/features/auth/domain/repository',
      'lib/features/auth/domain/services',
      'lib/features/auth/logic',
      'lib/features/auth/screens',
      'lib/features/auth/widgets',
      'lib/features/splash/screens',
      'lib/shared/api/network/models',
      'lib/shared/api/endpoint',
      'lib/shared/app/enums',
      'lib/shared/app/extension',
      'lib/shared/app/list',
      'lib/shared/constants',
      'lib/shared/models',
      'lib/shared/routes',
      'lib/shared/themes',
      'lib/shared/utils/flavour',
      'lib/shared/utils/auth',
      'lib/shared/utils/bloc_observer',
      'lib/shared/utils/failures',
      'lib/shared/widgets'
    ];

    for (var dir in directories) {
      await Directory(dir).create(recursive: true);
    }

    // Create files with content
    // Create files with content
    final files = {
      'lib/main.dart':
          "import 'package:flutter/material.dart';\nimport 'package:$projectName/my_app.dart';\n\nvoid main() {\n  runApp(MyApp());\n}\n",
      'lib/my_app.dart':
          "import 'package:flutter/material.dart';\n\nclass MyApp extends StatelessWidget {\n  const MyApp({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'Flutter Demo',\n      theme: ThemeData(\n        primarySwatch: Colors.blue,\n      ),\n      home: const HomeScreen(),\n    );\n  }\n}\n\nclass HomeScreen extends StatelessWidget {\n  const HomeScreen({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(\n        title: const Text('Home Screen'),\n      ),\n      body: const Center(\n        child: Text('Welcome to your Flutter app!'),\n      ),\n    );\n  }\n}\n",
      'lib/shared/api/endpoint/api_endpoints.dart':
          "class ApiEndpoints {\n  static const String myEndpoint1 = '/endpoint1';\n  static const String myEndpoint2 = '/endpoint2';\n}\n",
      'lib/shared/api/network/models/response.dart':
          "class ResponseData {\n  final int? statusCode;\n  final bool? success;\n  final String? message;\n\n  ResponseData({\n    this.statusCode,\n    this.success = false,\n    this.message,\n  });\n}\n",
      'lib/features/splash/screens/splash_screen.dart': '''


      import 'package:flutter/material.dart';
      import 'package:flutter_screenutil/flutter_screenutil.dart';
      import 'package:$projectName/shared/app/extension/helper.dart';

      class SplashScreen extends StatefulWidget {
        const SplashScreen({super.key});

        @override
        State<SplashScreen> createState() => _SplashScreenState();
      }

      class _SplashScreenState extends State<SplashScreen> {
        @override
        void initState() {
          super.initState();
          Helper.afterInit(_initialFunction);
        }

        void _initialFunction() {
          final currentContext = context;
          // Future.delayed(const Duration(seconds: 1), () async {
          //   // await AuthUtils.instance.deleteTokens; //test purpose to delete tokens
          //   if (!currentContext.mounted) return;
          //   final bool status = await AuthUtils.instance.isSignedIn;
          //   if (!currentContext.mounted) return;
          //   if (status) {
          //     Navigator.pushNamedAndRemoveUntil(
          //         currentContext, routeMain, ModalRoute.withName(routeRoot));
          //   } else {
          //     Navigator.pushNamedAndRemoveUntil(
          //         currentContext, routeLogin, ModalRoute.withName(routeRoot));
          //   }
          // });
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: FlutterLogo(





                  size: 164.w,
                ),
              ),
            ),
          );
        }
      }
      ''',
      'lib/shared/api/network/network.dart': '''
      import 'dart:async';
      import 'dart:convert';
      import 'package:dio/dio.dart';

      class NetworkProvider {
        final Dio _dio;

        NetworkProvider()
            : _dio = Dio(BaseOptions(
                baseUrl: 'https://api.example.com',
                headers: {'Content-Type': 'application/json'},
              )) {
          _dio.interceptors.add(InterceptorsWrapper(
            onRequest: (options, handler) async {
              print('------------------------------------------');
              String fullUrl = options.baseUrl + options.path;
              print('Full URL: \$fullUrl');
              print('Request = \${jsonEncode(options.data)}');
              print('------------------------------------------');

              if (options.headers.containsKey('auth')) {
                options.headers.remove('auth');
              } else {
                // Implement your logic for adding Authorization header
              }

              return handler.next(options);
            },
            onResponse: (response, handler) {
              print('******************************************');
              print('Response = \${response.data.toString()}');
              print('******************************************');
              return handler.next(response);
            },
            onError: (error, handler) async {
              print('Error-Response [\${error.response?.statusCode}] = \${error.response?.toString()}');

              // Handle error cases and retries
            },
          ));
        }

        Future<Response<T>> get<T>(String path) async {
          try {
            return await _dio.get<T>(path);
          } catch (error) {
            return Future.error(error);
          }
        }

        // Add other methods (post, put, delete, etc.) here
      }
      ''',
      'lib/shared/app/enums/api_fetch_status.dart':
          "enum ApiFetchStatus {\n  idle,\n  loading,\n  success,\n  failed,\n}\n",
      'lib/shared/app/extension/helper.dart':
          "import 'dart:async';\nimport 'package:flutter/cupertino.dart';\n\nclass Helper {\n  static void afterInit(Function function) {\n    WidgetsBinding.instance.addPostFrameCallback((_) {\n      function();\n    });\n  }\n}\n",
      'lib/shared/routes/navigator.dart':
          "import 'package:flutter/material.dart';\nfinal GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();",
      'lib/shared/routes/route_generator.dart':
          "import 'package:flutter/material.dart';\nimport 'package:$projectName/features/splash/screens/splash_screen.dart';\nimport 'package:$projectName/my_app.dart';\n\nclass RouteGenerator {\n  static Route<dynamic> generateRoute(RouteSettings settings) {\n    switch (settings.name) {\n      case '/':\n        return MaterialPageRoute(builder: (_) => SplashScreen());\n      case '/login':\n        return MaterialPageRoute(builder: (_) => SplashScreen());\n      default:\n        return MaterialPageRoute(\n          builder: (_) => Scaffold(\n            body: Center(child: Text('No route defined for \${settings.name}')),\n          ),\n        );\n    }\n  }\n}\n",
      'lib/shared/routes/routes.dart':
          "import 'package:flutter/material.dart';\nimport 'package:$projectName/shared/routes/navigator.dart';\nimport 'package:$projectName/shared/routes/route_generator.dart';\n\nclass Routes {\n  static const String home = '/';\n  static const String login = '/login';\n}\n",
      'lib/shared/widgets/flavor_banner.dart':
          "import 'package:flutter/material.dart';\n\nclass FlavorBanner extends StatelessWidget {\n  const FlavorBanner({\n    required this.child,\n    required this.message,\n    this.show = true,\n    super.key,\n  });\n  final Widget child;\n  final bool show;\n  final String message;\n  @override\n  Widget build(BuildContext context) => show\n      ? Directionality(\n          textDirection: TextDirection.ltr,\n          child: Banner(\n            location: BannerLocation.topStart,\n            message: message,\n            color: Colors.green.withOpacity(0.6),\n            textStyle: const TextStyle(\n                fontWeight: FontWeight.w700,\n                fontSize: 12.0,\n                letterSpacing: 1.0),\n            textDirection: TextDirection.ltr,\n            child: child,\n          ),\n        )\n      : child;\n}\n",
    };

    for (var path in files.keys) {
      await File(path).writeAsString(files[path]!);
    }

    print('Directory and file setup is complete for $projectName!');
  } catch (e) {
    print('Error: $e');
  }
}
