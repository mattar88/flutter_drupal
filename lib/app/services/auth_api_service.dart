import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:oauth2/oauth2.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';

import '../../flavors/build_config.dart';
import '../mixins/helper_mixin.dart';
import '../models/user_oauth_model.dart';
import 'api_service.dart';
import 'cache_service.dart';

class AuthApiService extends ApiService {
  static String signUpUrl = '/jsonapi/user/register';
  static String userInfoUrl = '/oauth/userinfo';
  // These URLs are endpoints that are provided by the authorization
// server. They're usually included in the server's documentation of its
// OAuth2 API.
  static String authorizationUrl = '/oauth/authorize';
  static String refreshTokenUrl = '/oauth/token';
// This is a URL on your application's server. The authorization server
// will redirect the resource owner here once they've authorized the
// client. The redirection will include the authorization code in the
// query parameters.

  get redirectUrl => BuildConfig.instance.config.callbackPath;

  get authorizationEndpoint => Uri.parse(baseUrl + authorizationUrl);
  get tokenEndpoint => Uri.parse(baseUrl + refreshTokenUrl);

// The authorization server will issue each client a separate client
// identifier and secret, which allows the server to tell which client
// is accessing it. Some servers may also have an anonymous
// identifier/secret pair that any client may use.
//
// Note that clients whose source code or binary executable is readily
// available may not be able to make sure the client secret is kept a
// secret. This is fine; OAuth2 servers generally won't rely on knowing
// with certainty that a client is who it claims to be.
  String clientId = BuildConfig.instance.config.clientId!;
  String clientSecret = BuildConfig.instance.config.clientSecret!;

  /// A file in which the users credentials are stored persistently. If the server
  /// issues a refresh token allowing the client to refresh outdated credentials,
  /// these may be valid indefinitely, meaning the user never has to
  /// re-authenticate.
  late File _credentialsFile;
  var _directory;
  Credentials? credentials;
  late AuthorizationCodeGrant _grant;
  oauth2.Client? client;

  initCredentials() async {
    _directory = await getApplicationDocumentsDirectory();

    _credentialsFile = File('${_directory.path}/credentials.json');
    credentials = await loadCredentails();
  }

  getAuthorizationUrl() {
    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    _grant = oauth2.AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: clientSecret);
    // A URL on the authorization server (authorizationEndpoint with some additional
    // query parameters). Scopes and state can optionally be passed into this method.
    log('redirectUrl: ${redirectUrl}');
    return _grant.getAuthorizationUrl(
      Uri.parse(redirectUrl),
      // scopes: ['access_token'],
    );
  }

  /// Either load an OAuth2 client from saved credentials or authenticate a new one
  Future<oauth2.Client?> handleAuthorizationResponse(Uri responseUrl) async {
    // Once the user is redirected to `redirectUrl`, pass the query parameters to
    // the AuthorizationCodeGrant. It will validate them and extract the
    // authorization code to create a new Client.

    return await _grant
        .handleAuthorizationResponse(responseUrl.queryParameters);
  }

  Future<Credentials?> authGrantPassword(username, password) async {
    // Make a request to the authorization endpoint that will produce the fully
    // authenticated Client.
    var client = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint, username, password,
        identifier: clientId, secret: clientSecret);
    saveCredentails(client.credentials);
    return client.credentials;
  }

  Future<Credentials?> loadCredentails() async {
    var exists = await _credentialsFile.exists();
    // return null;
    log('${exists.isBlank}');

    return exists && oauth2.Credentials != null
        ? oauth2.Credentials.fromJson(await _credentialsFile.readAsString())
        : null;
  }

  Future<Credentials> refreshToken() async {
    log('refresh-token');
    var credentials = await loadCredentails();

    try {
      if (credentials!.canRefresh) {
        var cre = await credentials.refresh(
            identifier: clientId, secret: clientSecret);
        // log('refresh-token ${cre.toJson()}');
        await saveCredentails(cre);

        return cre;
      } else {
        throw 'Could not refresh the Token!';
      }
    } catch (e) {
      printError(
          info:
              'Oauth client service exception refreshToken:  ${e.toString()}');
      throw 'Oauth client service exception refreshToken:  ${e.toString()}';
    }
  }

  Future<bool> saveCredentails(Credentials? credentials) async {
    await _credentialsFile.writeAsString(credentials!.toJson());
    this.credentials = credentials;
    return true;
  }

  Future<bool> removeCredentails() async {
    await _credentialsFile.writeAsString('');
    _credentialsFile.delete();
    credentials = null;
    return true;
  }

  bool sessionIsEmpty() {
    if (credentials == null) return true;
    return false;
  }

  bool sessionIsExpired() {
    int currentTimestamp = HelperMixin.getTimestamp();
    printInfo(
        info:
            'Expired in: ${credentials != null ? (credentials!.expiration!.millisecondsSinceEpoch / 1000 - currentTimestamp) / 60 : 0} mins -- isExceeded: ${credentials!.isExpired} and Can Refresh : ${credentials!.canRefresh}');
    if (sessionIsEmpty()) return true;

    return credentials!.isExpired;
  }

  Future<Response?> signUp(Map<String, dynamic> data) async {
    try {
      var body = {
        'name': data['username'],
        'mail': data['email'],
      };
      if (BuildConfig.instance.config.signupWithPassword) {
        body['pass'] = {
          'pass1': data['password'],
          'pass2': data['confirmPassword']
        };
      }
      return post(signUpUrl, body);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  ///
  ///Load User info using access token
  ///
  Future<UserOauthModel> userOauth() async {
    CacheService cs = Get.find();
    UserOauthModel? user = cs.loadUserOauth();
    if (user == null) {
      var response = await get(
        userInfoUrl,
      );
      log('userInfo: ${userInfoUrl}, ${response.statusCode}, ${response.body}');
      var result = response.body;
      if (response.isOk) {
        var user = UserOauthModel.fromJson(result);
        log('user_info: ${user.toJson()}');
        cs.saveUserOauth(user);
        return user;
      } else {
        var addMsg = result['error_messages'];
        throw Exception(
            'An error occurred when load user information ($addMsg), please try again!');
      }
    }
    return user;
  }

  void signOut() async {
    try {
      removeCredentails();
      CacheService cs = Get.find();
      cs.deleteUserInfo();
    } catch (e) {
      throw Exception('An error occurred when signout $e');
    }
  }
}
