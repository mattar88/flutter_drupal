import 'dart:developer';

import 'package:intl/intl.dart';

import '../../config/config_locale.dart';
import '../../access/access.dart';
import '../user_model.dart';

class NodeModel {
  late String? id;
  late String type;
  late String title;
  late String? body;
  late bool? status;
  String? alias;
  //if langcode is not en or und, the delete(405, Method Not Allowed) functionality and other not working
  //More information: https://www.drupal.org/docs/core-modules-and-themes/core-modules/jsonapi-module/translations
  String? langcode;
  DateTime? created;
  DateTime? changed;
  UserModel? author;
  NodeModel(
      {this.id,
      required this.type,
      required this.title,
      this.body,
      this.status,
      this.alias,
      this.langcode,
      this.created,
      this.changed}) {
    langcode = langcode ?? ConfigLocale.undefine.languageCode;
  }
  NodeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      var data = json['data'];
      // log('NodeModel fromjson: ${data}');
      DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
      id = data['id'];
      type = data['type'].toString().replaceAll('node--', '');
      title = data['attributes']['title'];

      body = data['attributes']['body'] != null
          ? data['attributes']['body']['value']
          : '';
      alias = data['attributes']['path'] != null
          ? data['attributes']['path']['alias']
          : '';

      status = data['attributes']['status'];
      langcode = data['attributes']['langcode'];

      //Date ISO8601 format
      created = dateFormat.parse(data['attributes']['created'], true).toLocal();
      // log('Hour: ${created!.hour},Minute: ${created!.minute}, second: ${created!.second}');
      changed = dateFormat.parse(data['attributes']['changed'], true).toLocal();

      if (data['relationships'].containsKey('uid')) {
        var authorDataJson = data['relationships']['uid']['data'];
        author = UserModel(
            id: authorDataJson['id'],
            drupalInternalUid: authorDataJson['meta']
                ['drupal_internal__target_id']);
      }
      if (json['included'] != null) {
        json['included'].forEach((includedJson) {
          if (includedJson['type'] == 'user--user') {
            // log('Node model--6---,${includedJson}');
            author = UserModel.fromJson({'data': includedJson});
          }
        });
      }
      // log('Node model--4---,');
    } catch (e) {
      throw Exception('Error occurred in NodeModel.fromJson() function $e');
    }
  }

  dynamic toJson() {
    log('ToJson:....Enterrr');
    dynamic data = {
      "data": {
        "type": "node--$type",
        "id": id,
        "attributes": {
          "title": title,
          "body": {"value": body, "format": "plain_text"},
          "path": {"alias": alias},
          'langcode': langcode
        },
      }
    };

    if (Access.administerNodes()) {
      data['data']['attributes']['status'] = status;
    }
    return data;
  }
}
