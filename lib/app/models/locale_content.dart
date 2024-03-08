import 'dart:ui';

class LocaleModel {
  Locale locale;
  String language;
  bool defaultLanguage = false;

  LocaleModel(
      {required this.locale,
      required this.language,
      required this.defaultLanguage});
}
