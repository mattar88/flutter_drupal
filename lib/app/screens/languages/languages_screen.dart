import 'dart:developer';

import 'package:flutter/material.dart';
import '../../widgets/Labeled_radio.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../locale/config_locale.dart';
import '../../controllers/languages_controller.dart';
import '../../models/Locale_content.dart';
import '../base_screen.dart';

class LanguagesScreen extends BaseScreen<LanguagesController> {
  LanguagesScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(T.languages),
      ),
      body: Obx(() {
        // log('------------${controller.selectedLanguage.value}....${Get.deviceLocale.toString().split('_').first}');

        return SingleChildScrollView(
            child: Container(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <LabeledRadio>[
            LabeledRadio<Locale>(
              label: T.deviceLanguage,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              value: Get.deviceLocale!,
              groupValue: controller.locale.value!,
              onChanged: controller.onChanged,
            ),
            ...ConfigLocale.supportedLocalesData
                .map((LocaleModel l) => LabeledRadio<Locale>(
                      label: l.language,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      value: l.locale,
                      groupValue: controller.locale.value!,
                      onChanged: controller.onChanged,
                    )),
            // LabeledRadio<Locale>(
            //   label: 'English',
            //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //   value: const Locale('en', 'UK'),
            //   groupValue: controller.locale.value!,
            //   onChanged: controller.onChanged,
            // ),
            // LabeledRadio<Locale>(
            //   label: 'French',
            //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //   value: const Locale('fr', 'FR'),
            //   groupValue: controller.locale.value!,
            //   onChanged: controller.onChanged,
            // ),
            // LabeledRadio<Locale>(
            //   label: 'العربية',
            //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //   value: const Locale('ar', 'LB'),
            //   groupValue: controller.locale.value!,
            //   onChanged: controller.onChanged,
            // ),
          ],
        )));
      }),
    );
  }
}
