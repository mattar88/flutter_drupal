import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_controller.dart';

class ThemeModeController extends BaseController {
  ThemeModeController();

  late SharedPreferences prefs;
  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    selectedDisplay = Rxn<ThemeMode>(getThemeMode());
    super.onInit();
  }

  late Rxn<ThemeMode> selectedDisplay;

  onChanged(ThemeMode themeMode) {
    selectedDisplay.value = themeMode;
    Get.changeThemeMode(themeMode);
    saveThemeMode(themeMode);
  }

  void saveThemeMode(ThemeMode themeMode) {
    // GetStorage().write('theme_mode', themeMode.name);
    prefs.setString('theme_mode', themeMode.name);
  }

  String? loadThemeMode() {
    // return GetStorage().hasData('theme_mode')
    //     ? GetStorage().read('theme_mode')
    //     : null;

    return prefs.containsKey('theme_mode')
        ? prefs.getString('theme_mode')
        : null;
  }

  ThemeMode getThemeMode() {
    var themeMode = loadThemeMode();
    switch (themeMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
