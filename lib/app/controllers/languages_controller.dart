import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_controller.dart';

class LanguagesController extends BaseController {
  LanguagesController();

  late Rxn<String> selectedLanguage;
  late Rxn<Locale> locale;
  late SharedPreferences prefs;
  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  initialize() async {
    prefs = await SharedPreferences.getInstance();
    // selectedLanguage = Rxn<String>(getLocale());
    // log('Enterrr initializeee');
    locale = Rxn<Locale>(getLocale());
  }

  onChanged(Locale locale) {
    // selectedLanguage.value = localeString;
    // locale = parseLocale(localeString);
    this.locale.value = locale;
    Get.updateLocale(locale);

    // log('Locale----${locale.toString()}, ${parseLocale(locale.toString())}}');
    saveLocale(locale);
  }

  Locale parseLocale(String? locale) {
    // ArgumentError.checkNotNull(locale);
    if (locale == null || locale.isEmpty || locale == 'system') {
      return Get.deviceLocale!;
    }
    var localeSplited = locale.split("_");
    return Locale(localeSplited.first, localeSplited.last);
  }

  void saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // GetStorage().write('locale', locale);
    prefs.setString('locale', locale.toString());
  }

  String? loadLocaleString() {
    // var gs = GetStorage();
    // log('has Locallll ${gs.hasData('locale')}');
    // return gs.hasData('locale') ? GetStorage().read('locale') : null;
    return prefs.containsKey('locale') ? prefs.getString('locale') : null;
  }

  String getLocaleString() {
    var locale = loadLocaleString();

    return (locale == null || locale.isEmpty) ? 'system' : locale;
  }

  Locale? getLocale() {
    var localeString = loadLocaleString();
    return parseLocale(localeString);
  }
}
