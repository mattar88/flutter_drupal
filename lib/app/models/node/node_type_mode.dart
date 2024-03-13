import 'dart:developer';

import '../../locale/config_locale.dart';

class NodeTypeModel {
  late String? id;
  late String name;
  late String machineName;
  late String? description;
  late String? langcode;

  NodeTypeModel(
      {this.id,
      required this.name,
      required this.machineName,
      this.description,
      this.langcode}) {
    langcode = langcode ?? ConfigLocale.undefine.languageCode;
    ;
  }
  NodeTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['attributes']['name'];
    machineName = json['attributes']['drupal_internal__type'];
    description = json['attributes']['description'] ?? '';
    langcode = json['attributes']['langcode'];
  }
}
