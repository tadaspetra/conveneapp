import 'package:conveneapp/environment_config.dart';
import 'package:conveneapp/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  const String env = String.fromEnvironment(EnvironmentConfig.envName,
      defaultValue: EnvironmentConfig.prod);
  await setUpMain(env);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AppNavigator(),
      theme: CustomTheme.lightTheme(context),
    );
  }
}
