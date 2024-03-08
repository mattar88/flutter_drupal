import 'package:flutter/material.dart';
import '../../config/config_locale.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_pages.dart';
import '../../values/app_values.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(T.settings),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: AppValues.pagePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: ListTile(
                        enabled: ConfigLocale.enabled,
                        leading: const Icon(Icons.language),
                        title: Text(T.languages),
                        onTap: () {
                          Get.toNamed(Routes.LANGUAGES.path);
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.dark_mode),
                        title: Text(T.darkMode),
                        onTap: () {
                          Get.toNamed(Routes.THEME_MODE.path);
                        },
                      ),
                    ),
                  ],
                ))));
  }
}
