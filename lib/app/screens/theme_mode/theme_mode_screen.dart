import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controllers/theme_mode_controller.dart';
import '../../widgets/Labeled_radio.dart';
import '../base_screen.dart';

class ThemeModeScreen extends BaseScreen<ThemeModeController> {
  ThemeModeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(T.darkMode),
      ),
      body: Obx(() {
        // log('------------${controller.selectedLanguage.value}....${Get.deviceLocale.toString().split('_').first}');
//  Get.isPlatformDarkMode

        return SingleChildScrollView(
            child: Container(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <LabeledRadio>[
            LabeledRadio<ThemeMode>(
              label: T.useSystemSettings,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              value: ThemeMode.system,
              groupValue: controller.selectedDisplay.value!,
              onChanged: controller.onChanged,
            ),
            LabeledRadio<ThemeMode>(
              label: T.dark,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              value: ThemeMode.dark,
              groupValue: controller.selectedDisplay.value!,
              onChanged: controller.onChanged,
            ),
            LabeledRadio<ThemeMode>(
              label: T.light,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              value: ThemeMode.light,
              groupValue: controller.selectedDisplay.value!,
              onChanged: controller.onChanged,
            ),
          ],
        )));
      }),
    );
  }
}
