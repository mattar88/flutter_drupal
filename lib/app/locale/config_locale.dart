import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/Locale_content.dart';

class ConfigLocale {
  /// 'undefine' do not remove because it used by default
  static const undefine = Locale('und', 'UND');
  static const arabic = Locale('ar', 'LB');
  static const french = Locale('fr', 'FR');
  static const english = Locale('en', 'US');

  ///The languages of content loaded using API,
  ///should be syncronized with remote languages config
  ///To disable it just put [] as a value
  ///
  static List<LocaleModel> get supportedLocalesData => [
        // LocaleModel(locale: arabic, language: 'Arabic', defaultLanguage: false),
        // LocaleModel(
        //     locale: english, language: 'English', defaultLanguage: true),
        // LocaleModel(locale: french, language: 'French', defaultLanguage: false),
      ];
  static get enabled => ConfigLocale.supportedLocalesData.isNotEmpty;

  static get supportedLocales =>
      enabled ? supportedLocalesData.map((e) => e.locale) : [english];

  static get currentLocale => ConfigLocale.supportedLocalesData.isEmpty
      ? LocaleModel(
          locale: undefine, language: 'Undefine', defaultLanguage: true)
      : ConfigLocale.supportedLocalesData.firstWhere((SLC) {
          if (SLC.locale.toString() == Get.locale.toString()) return true;
          if (SLC.locale.languageCode == Get.locale!.languageCode) return true;
          return false;
        });
}
