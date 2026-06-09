import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:otaupdate/src/rust/api/ota.dart';
import 'package:otaupdate/src/rust/frb_generated.dart';

import 'pages/home.dart';
import 'pages/settings.dart';

Future<void> main() async {
  await RustLib.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      // 启用MD3动态颜色
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme:
                darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
          ),

          home: const HomePage(),
          // Routers
          routes: {'/home': (context) => const HomePage(),
            '/settings': (context) => const SettingsPage()
          },
        );
      },
    );
  }
}
