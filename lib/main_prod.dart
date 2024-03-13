import 'package:flutter/material.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';

void main() async {
  EnvConfig prodConfig = EnvConfig(
    appName: "Flutter Drupal",
    baseUrl: "", //Do not add "/" at the end
    clientId: "cklX9qi2FGTEPPYqWD1zcsy8YAxh3ygXnoNcCQ6FdC0",
    clientSecret: "secret",
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.PRODUCTION,
    envConfig: prodConfig,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}
