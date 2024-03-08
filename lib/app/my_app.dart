import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../flavors/build_config.dart';
import './bindings/app_binding.dart';
import './controllers/auth_controller.dart';
import './controllers/languages_controller.dart';
import './controllers/theme_mode_controller.dart';
import './values/color_schemes.g.dart';
import 'config/config_locale.dart';
import 'routes/app_pages.dart';
import 'services/auth_api_service.dart';
import 'services/cache_service.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeApp();
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: BuildConfig.instance.config.appName,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: ConfigLocale.supportedLocales,
      locale: Get.find<LanguagesController>().locale.value,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: Get.find<ThemeModeController>().getThemeMode(),
      // theme: ThemeData(
      //   useMaterial3: true,
      //   //backgroundColor: Colors.white,
      //   accentColor: AppColors.secondary,

      //   primarySwatch: AppColors.primarySwatch,
      //   scaffoldBackgroundColor: AppColors.background,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      //   brightness: Brightness.light,
      //   // appBarTheme: appBarTheme,
      //   // elevatedButtonTheme: defaultElevatedButtonTheme,
      //   // textTheme: textTheme,
      //   textTheme: Theme.of(context).textTheme.apply(
      //         bodyColor: AppColors.textColorPrimary, //<-- SEE HERE
      //         displayColor: AppColors.textColorSecondary,
      //       ),
      //   fontFamily: GoogleFonts.openSans().fontFamily,
      // ),
      // locale: LocalizationService.locale,
      // fallbackLocale: LocalizationService.fallbackLocale,
      // translations: LocalizationService(),
      initialRoute: Routes.HOME.path,
      initialBinding: AppBinding(),
      getPages: AppPages.pages,
    );
  }
}

Future<void> initializeApp() async {
  AuthApiService authApiService = Get.put(AuthApiService());
  Get.put(CacheService(), permanent: true);
  await authApiService.initCredentials();
  Get.put(AuthController(authApiService), permanent: true);

  Get.put(LanguagesController(), permanent: true);
  await Get.find<LanguagesController>().initialize();
  Get.put(ThemeModeController(), permanent: true);

  log('Initialize');
}
