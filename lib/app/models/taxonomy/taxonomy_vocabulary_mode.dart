import 'dart:developer';

import '../../locale/config_locale.dart';

class TaxonomyVocabularyModel {
  late String? id;
  late String name;
  late String machineName;
  late String? description;
  late String? langcode;

  TaxonomyVocabularyModel(
      {this.id,
      required this.name,
      required this.machineName,
      this.description,
      this.langcode}) {
    langcode = langcode ?? ConfigLocale.undefine.languageCode;
  }
  TaxonomyVocabularyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['attributes']['name'];
    machineName = json['attributes']['drupal_internal__vid'];
    description = json['attributes']['description'] ?? '';
    langcode = json['attributes']['langcode'];
  }
}
