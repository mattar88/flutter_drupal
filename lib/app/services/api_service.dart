import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oauth2/oauth2.dart';

import '../../flavors/build_config.dart';
import '../locale/config_locale.dart';
import '../controllers/auth_controller.dart';
import '../mixins/helper_mixin.dart';
import '../routes/app_pages.dart';
import '../values/app_colors.dart';
import 'auth_api_service.dart';

class ApiService extends GetConnect {
  @override
  String get baseUrl => BuildConfig.instance.config.baseUrl;

  String? get apiPathPrefix => BuildConfig.instance.config.apiPathPrefix;

  int retry = 0;

  String fetchResponseErrorMessage(response) {
    var errorMsg = '';

    var result = jsonDecode(response.body);
    if (result.containsKey('errors')) {
      result['errors'].forEach((error) {
        if (errorMsg != '') {
          errorMsg += ',';
        }
        errorMsg += '${error['detail']}';
      });
    }
    return errorMsg;
  }

////Add Api Path prefix
////Add local prefix used to load the settings translations like label and fields description and others
  Uri addUrlPrefix(Uri url) {
    String urlPrefix = '';

    //Add locale prefix
    if (ConfigLocale.supportedLocalesData.isNotEmpty) {
      var localeContent = ConfigLocale.currentLocale;

      if (!localeContent.defaultLanguage) {
        urlPrefix = '/${localeContent.locale.languageCode}';
      }
    }

    //Add API Path Prefix
    if (apiPathPrefix != null &&
        apiPathPrefix!.isNotEmpty &&
        apiPathPrefix != '') {
      urlPrefix += '/$apiPathPrefix';
    }

    if (urlPrefix == '') {
      return url;
    }

    log('Urllll: ${url.toString().replaceAll(baseUrl, '$baseUrl/$urlPrefix')}');
    return Uri.parse(url.toString().replaceAll(baseUrl, '$baseUrl$urlPrefix'));
    //     .replace(queryParameters: {
    //   'filter[langcode]': localeContent.locale.languageCode
    // });
  }

  @override
  void onInit() {
    // BaseController baseController = Get.put(BaseController());
    // httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.maxAuthRetries = retry = 3;
    httpClient.followRedirects = true;
    httpClient.defaultContentType = 'application/vnd.api+json';

//addAuthenticator only is called after
//a request (get/post/put/delete) that returns HTTP status code 401
    httpClient.addAuthenticator<dynamic>((request) async {
      retry--;
      log('addAuthenticator ${request.url.toString()}');

      AuthController authController = Get.find();
      AuthApiService authService = Get.find();
      Credentials? oauthCredentails = authService.credentials;
      try {
        if (oauthCredentails != null && oauthCredentails.canRefresh) {
          oauthCredentails = await authController.refreshToken();
          log('Enter hereeee');
          if (oauthCredentails!.accessToken.isNotEmpty) {
            log('addAuthenticator refresh token ${oauthCredentails.accessToken}');
            request.headers['Authorization'] =
                'Bearer ${oauthCredentails.accessToken}';
          } else {
            if (retry == 0) {
              retry = httpClient.maxAuthRetries;

              Get.offAllNamed(Routes.LOGIN.path);
            }
          }
        } else {
          if (retry == 0) {
            retry = httpClient.maxAuthRetries;

            Get.offAllNamed(Routes.LOGIN.path, arguments: {
              'message': {
                'status': 'warning',
                'status_text': 'session_expired',
                'body': 'Session expired please log in again.!'
              }
            });
          }
        }
      } catch (err, _) {
        printError(info: err.toString());

        authController.signOut();
        Get.offAllNamed(Routes.LOGIN.path, arguments: {
          'message': {
            'status': 'warning',
            'status_text': 'session_expired',
            'body':
                'Session expired Or invalid refresh token, please log in again.!'
          }
        });
      }

      return request;
    });

    httpClient.addResponseModifier((request, response) {
      log('call addREsponseModifier ${request.url} ${response.statusCode}, ${response.statusText}');
      try {
        if (response.statusCode == null) {
          throw Exception(
              'An error occurred!, No internet connection or unable to access server.');
        }

        // if (response.statusCode == 443) {
        //   return Response(request: request, statusCode: 401);
        // }

        if (response.statusCode == HttpStatus.unauthorized) {
          return response;
        }

        var body = HelperMixin.tryJsonDecode(response.body);

        //On failure request re-encapsulate error message to all requests
        if (!response.isOk) {
          body['error_messages'] = fetchResponseErrorMessage(response);

          return Response(
              request: request,
              statusCode: response.statusCode,
              statusText: response.statusText,
              bodyBytes: response.bodyBytes,
              bodyString: response.bodyString,
              body: jsonEncode(body),
              headers: response.headers);

          // Get.snackbar(
          //   'Error',
          //   body['error_messages'],
          //   snackPosition: SnackPosition.TOP,
          //   backgroundColor: AppColors.error,
          //   colorText: Colors.white,
          //   icon: const Icon(Icons.error, color: Colors.white),
          //   shouldIconPulse: true,
          //   barBlur: 20,
          // );
        }

        //Some resources have been omitted because of insufficient authorization/ or permissions
        if (body != null &&
            body.containsKey('meta') &&
            body['meta'].containsKey('omitted')) {
          var errorMessage = body['meta']['omitted']['detail'];
          printError(info: body['meta']['omitted'].toString());

          Get.snackbar(
            'Warning',
            errorMessage,
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.warning,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            shouldIconPulse: true,
            barBlur: 20,
          );
        }

        return response;
      } catch (e) {
        printError(
            info: 'An error occurred in addResponseModifier() function $e');
        throw Exception(
            'An error occurred in addResponseModifier() function $e');
      }
    });

    httpClient.addRequestModifier<dynamic>((request) async {
      request = request.copyWith(url: addUrlPrefix(request.url));

      AuthController authController = Get.find();
      var tc = authController.tokenCredentials();
      log('IsAuthenticated: ${authController.isAuthenticated()}');
      if (tc != null && tc.accessToken.isNotEmpty) {
        // log('Add Request Modifier is authenticated ${authController.tokenCredentials()!.accessToken}');
        request.headers['Authorization'] =
            'Bearer ${authController.tokenCredentials()!.accessToken}';
      }

      return request;
    });
  }
}
