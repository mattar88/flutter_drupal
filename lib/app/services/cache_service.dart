import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mixins/helper_mixin.dart';
import '../models/user_model.dart';
import '../models/user_oauth_model.dart';

class CacheService extends GetxService with HelperMixin {
  late SharedPreferences prefs;
  @override
  onInit() async {
    prefs = await SharedPreferences.getInstance();
    // OAuthClientService _OAuthClientService = Get.find();
    // credentialsOAuth = _OAuthClientService.client.credentials;
    super.onInit();
  }

  void clear() {
    deleteUserInfo();
  }

  Future<bool> saveUserOauth(UserOauthModel user) {
    // log('Save user info: ${jsonEncode(user)}');
    prefs.setString('userInfo', jsonEncode(user));
    // var userInfoSeri = prefs.getString('userInfo');
    // log('Load user info ${jsonDecode(userInfoSeri!)}');
    return Future.value(true);
  }

  UserOauthModel? loadUserOauth() {
    try {
      var userOauth = prefs.getString('userInfo');
      // log('Load user info 2222${jsonDecode(userOauth!)}');
      // log('Load user info after decode${UserOauthModel.fromJson(jsonDecode(userOauth)).toJson()}');
      return userOauth != null && userOauth.isNotEmpty
          ? UserOauthModel.fromJson(jsonDecode(userOauth))
          : null;
    } catch (e) {
      throw Exception(
          'An error occurred in loadUserOauth() in cache service: ${e.toString()}');
    }
  }

  Future<bool> deleteUserInfo() {
    return prefs.remove('userInfo');
  }
}

enum CacheManagerKey { TOKEN }
