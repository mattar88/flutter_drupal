import 'dart:developer';

import 'package:intl/intl.dart';

import '../mixins/helper_mixin.dart';

class UserOauthModel {
  String? id;
  String? displayName;
  int? drupalInternalUid;
  String? langcode;
  String? preferredLangcode;
  String? name;
  String? mail;
  String? timezone;
  List<String>? roles;
  List<String>? permissions;
  UserOauthModel(
      {this.displayName,
      this.drupalInternalUid,
      this.langcode,
      this.preferredLangcode,
      this.name,
      this.mail,
      this.timezone,
      this.roles,
      this.permissions});

  UserOauthModel.fromJson(Map<String, dynamic> json) {
    try {
      var data = json;
      drupalInternalUid = data['sub'] != null ? int.parse(data['sub']) : null;
      displayName = data['preferred_username'];
      langcode = data['locale'];
      name = data['name'];
      mail = data['email'];
      id = data['uuid'];
      roles = data['roles'] != null ? List<String>.from(data['roles']) : [];
      permissions = data['permissions'] != null
          ? List<String>.from(data['permissions'])
          : [];
    } catch (e) {
      throw Exception(
          'Error occurred in function UserOauthModel.fromJson(): $e');
    }
  }

  Map<String, dynamic> toJson() {
    dynamic data = {
      "uuid": id,
      "sub": drupalInternalUid.toString(),
      "preferred_username": displayName,
      "locale": langcode,
      "preferred_langcode": preferredLangcode,
      "name": name,
      "email": mail,
      "timezone": timezone,
      "roles": roles,
      "permissions": permissions
    };
    return data;
  }
}
