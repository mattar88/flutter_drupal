import 'dart:developer';

import 'package:intl/intl.dart';

import '../mixins/helper_mixin.dart';
import 'file_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class UserModel {
  String? type = 'user';
  String? id;
  String? displayName;
  int? drupalInternalUid;
  String? langcode;
  String? preferredLangcode;
  String? name;
  String? mail;
  String? timezone;
  bool? status;
  DateTime? created;
  DateTime? changed;
  DateTime? access;
  DateTime? login;
  String? init;
  FileModel? userPicture;
  List<String>? roles;
  List<String>? permissions;
  UserModel(
      {this.id,
      this.displayName,
      this.drupalInternalUid,
      this.langcode,
      this.preferredLangcode,
      this.name,
      this.mail,
      this.timezone,
      this.status,
      this.created,
      this.changed,
      this.access,
      this.login,
      this.init,
      this.userPicture,
      this.roles,
      this.permissions});

  UserModel.fromJson(Map<String, dynamic> json) {
    try {
      var data = json['data'];

      DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

      type = data['type'].toString().replaceAll('user--', '');
      id = data['id'];

      if (data.containsKey('attributes')) {
        displayName = data['attributes']['display_name'];
        drupalInternalUid = data['attributes']['drupal_internal__uid'];
        langcode = data['attributes']['langcode'];
        preferredLangcode = data['attributes']['preferred_langcode'];
        name = data['attributes']['name'];
        mail = data['attributes']['mail'];
        timezone = data['attributes']['timezone'];

        if (data['attributes'].containsKey('status') &&
            data['attributes']['status'] != null) {
          status = data['attributes']['status'];
        } else {
          status = null;
        }
        // log('Acess ${data['attributes']['access']}');
        created = data['attributes'].containsKey('created')
            ? dateFormat.parse(data['attributes']['created'], true).toLocal()
            : null;

        changed = data['attributes'].containsKey('changed')
            ? dateFormat.parse(data['attributes']['changed'], true).toLocal()
            : null;

        access = data['attributes'].containsKey('access')
            ? dateFormat.parse(data['attributes']['access'], true).toLocal()
            : null;

        login = data['attributes'].containsKey('login')
            ? dateFormat.parse(data['attributes']['login'], true).toLocal()
            : null;

        init = data['attributes']['init'];
      }

      if (data.containsKey('relationships')) {
        var picture = data['relationships']['user_picture']['data'];
        if (picture != null) {
          userPicture = FileModel.fromJson({'data': picture});
        }

        if (json['included'] != null) {
          json['included'].forEach((includedJson) {
            if (includedJson['type'] == 'file--file') {
              if (userPicture!.id == includedJson['id']) {
                userPicture = FileModel.fromJson({'data': includedJson});
              }
            }
          });
        }

        // log('UserModelllll: ${userPicture!.uri.toString()}');
      }
    } catch (e) {
      throw Exception('Error occurred in UserModel.fromJson() function $e');
    }
  }

  UserModel.fromUserInfoJson(Map<String, dynamic> json) {
    try {
      var data = json;
      type = 'user';
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
          'Error occurred in UserModel.fromUserInfoJson() function $e');
    }
  }

  Map<String, dynamic> toJson() {
    dynamic data = {
      "data": {
        "type": "user--$type",
        "id": id,
        "attributes": {
          "drupal_internal__uid": drupalInternalUid,
          "display_name": displayName,
          "langcode": langcode,
          "preferred_langcode": preferredLangcode,
          "name": name,
          "mail": mail,
          "timezone": timezone,
          "status": status,
          "roles": roles.toString(),
          "permissions": permissions.toString()
        },
      }
    };
    return data;
  }

  get lastAccess => access == null || access!.year <= 1970
      ? 'never'
      : HelperMixin.timeAgo(access);

  get memberFor => HelperMixin.timeAgo(created);
}
