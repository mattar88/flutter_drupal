import 'package:flutter/material.dart';
import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';

void main() async {
  EnvConfig devConfig = EnvConfig(
    appName: "Flutter Drupal Dev",
    baseUrl: "https://flutter.tolastbit.com", //Do not add "/" at the end
    clientId: "cklX9qi2FGTEPPYqWD1zcsy8YAxh3ygXnoNcCQ6FdC0",
    clientSecret: "secret",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}
