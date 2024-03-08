import 'dart:convert';
import 'dart:developer';
import '../models/user_model.dart';
import '../models/user_oauth_model.dart';
import '../services/oauth_client_service2.dart';
import 'package:oauth2/oauth2.dart';

import '../routes/app_pages.dart';
import '../services/cache_service.dart';
import 'package:get/get.dart';
import '../services/auth_api_service.dart';

//This controller doesn't have view page but used
// for some widget button like signout and other
class AuthController extends GetxController {
  final AuthApiService _authenticationService;

  AuthController(this._authenticationService);

  Future<Credentials?> signIn(String email, String password) async {
    try {
      log('Enter Signin');
      return await _authenticationService.authGrantPassword(email, password);
      // log('is logged in : ${crednetials!.accessToken}');
    } catch (e) {
      // printLog(e);
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<Response?> signUp(Map<String, dynamic> data) async {
    String error_m =
        'An error occurred while registering, please contact the administrator.';
    try {
      return await _authenticationService.signUp(data);

      // if (response.statusCode == 200) {
      //   log('enter signup');

      //   // tokenData = await signIn(data['email'], data['password']);
      // } else {
      //   // var message = response.body['error_description'];

      //   throw Exception(error_m);
      // }
    } catch (e) {
      // printLog(e);
      printError(info: e.toString());
      throw Exception(error_m);
    }
    // return tokenData;
  }

  ///
  ///Load User info using access token
  ///Load if exist in the localStorage otherwise load it using api
  ///
  Future<UserOauthModel> userOauth() async {
    try {
      UserOauthModel user = await _authenticationService.userOauth();
      // log('----User ${user.toJson()}');

      return user;
    } catch (e) {
      printError(info: 'exception userOauth():  ${e.toString()}');
      rethrow;
    }
  }

  Future<UserOauthModel?> saveUserOauth(user) async {
    CacheService cs = Get.find();
    try {
      var saved = await cs.saveUserOauth(user);
      if (saved) return user;
      return null;
    } catch (e) {
      printError(info: 'exception saveUserOauth():  ${e.toString()}');
      rethrow;
    }
  }

  Future<Credentials?> refreshToken() async {
    try {
      return _authenticationService.refreshToken();
    } catch (e) {
      printError(info: 'exception refreshToken:  ${e.toString()}');
      rethrow;
    }
  }

  Credentials? tokenCredentials() => _authenticationService.credentials;

  void signOut() async {
    _authenticationService.signOut();
  }

  bool isAuthenticated() {
    return !_authenticationService.sessionIsExpired();
  }

  //
//  Return true when the token refreshed successfully or the user is authenticated
//
  Future<bool> checkAuthAndRefresh() async {
    AuthController authController = Get.find();
    if (!authController.isAuthenticated()) {
      Credentials? oauthCredentails = await refreshToken();
      if (oauthCredentails == null) {
        authController.signOut();
        Get.offAllNamed(Routes.LOGIN.path);
        return false;
      }
      return true;
    }
    return true;
  }
}
