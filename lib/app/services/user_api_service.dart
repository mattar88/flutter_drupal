import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../config/config_locale.dart';
import '../controllers/auth_controller.dart';
import '../models/file_model.dart';
import '../models/user_model.dart';
import '../routes/app_pages.dart';
import '../values/app_colors.dart';
import 'api_service.dart';

class UserApiService extends ApiService {
  static String userPath = '/user';
  static String userType = 'user';

  final bool localeEnabled = false;

  UserApiService();

//In this function we uses the main HTTP package because
//GetConnect doesn't support bodyBytes in addition we inject access tokens
//@TODO: integrate with GETconnect and use AddRequestModifier() in ApiService
//to inject access token.
  Future<FileModel?> uploadFile(String fieldMachineName, XFile? file,
      {Progress? uploadProgress}) async {
    AuthController authController = Get.find();

    final stream = file!.openRead();
    int length = await file.length();
    final client = new HttpClient();

    final request = await client.postUrl(Uri.parse(
        '$baseUrl/$apiPathPrefix$userPath/$userType/$fieldMachineName'));
    request.headers.add('Content-Type', 'application/octet-stream');
    request.headers.add('Accept', '*/*');
    request.headers.add('Content-Disposition', 'file; filename="${file.name}"');
    request.headers.add('Authorization',
        'Bearer ${authController.tokenCredentials()!.accessToken}');
    request.contentLength = length;

    int byteCount = 0;
    double percent = 0;
    Stream<List<int>> stream2 = stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;
          if (uploadProgress != null) {
            percent = (byteCount / length) * 100;
            uploadProgress(percent);
          }
          sink.add(data);
        },
        handleError: (error, stack, sink) {},
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    await request.addStream(stream2);

    final response = await request.close();

    if (response.statusCode == HttpStatus.created) {
      // Process the response
      final body = await response.transform(utf8.decoder).join();

      var result = jsonDecode(body);
      //  log('resultttt ${result.toString()}');
      if (result['data'] != null) {
        return FileModel.fromJson(result);
      }
    } else {
      if (response.statusCode == HttpStatus.unauthorized) {
        Get.offAllNamed(Routes.LOGIN.path, arguments: {
          'message': {
            'status': 'warning',
            'status_text': 'session_expired',
            'body':
                'An error occurred, Unauthorized request empty session or expired please log in again.!'
          }
        });
      }

      if (response.statusCode == HttpStatus.methodNotAllowed) {
        // print(response.statusCode);

        Get.snackbar(
          'Error',
          'An error occurred, Method not allowed maybe the user does not contains field of type file!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          shouldIconPulse: true,
          barBlur: 20,
        );
      }
      print(response.statusCode);
    }
    return null;
  }

  Future<UserModel?> getCurrentUser(List<String>? include) async {
    try {
      AuthController auth = Get.find();
      var userOauth = await auth.userOauth();
      log('userInfo***:${userOauth.toJson()}');
      if (userOauth.id != null) {
        var user = await load(userOauth.id!, include: include);

        return user;
      } else {
        throw Exception('Invalid user id');
      }
    } catch (e) {
      throw Exception(
          'An error occurred when getCurrentUser(), ${e.toString()}');
    }
  }

  Future<UserModel?> getUserByInternalId(int drupalInternalUid,
      {List<String>? include}) async {
    Map<String, dynamic> query = {};
    try {
      if (include != null && include.isNotEmpty) {
        query['include'] = include.join(',');
      }
      query['filter[uid][value]'] = drupalInternalUid.toString();
      var users = await getUsersByFilter(query);
      // log('Users...........${users!.first.toJson()}');
      return users!.first;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<List<UserModel>?> getUsersByFilter(Map<String, dynamic>? query) async {
    if (localeEnabled) {
      if (query!.isEmpty) query = {};
      query['filter[langcode]'] =
          ConfigLocale.currentLocale.locale.languageCode;
    }

    return get('$userPath/$userType',
            headers: {
              // 'Content-type': 'application/vnd.api+json',
              'Accept': 'application/json'
            },
            query: query)
        .then((response) {
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['data'] != null) {
          return List<UserModel>.from(result['data']
              .map((userJson) => UserModel.fromJson({
                    'data': userJson,
                    'included': result.containsKey('included')
                        ? result['included']
                        : null
                  }))
              .toList());
        }
      } else {
        throw Exception(
            'An error occurred please try again ${response.statusCode}');
      }
      //
    });
  }

  Map<String, Map<String, dynamic>> _filterListQueryCache = {};

  Future<List<UserModel>?> filterList(
      {String? filterTitle,
      String? text,
      String? operation,
      int? offset,
      int? limit}) async {
    Map<String, dynamic> filterQuery = {};
    var filterTitleQuery = '${text}_$filterTitle';
    // bool allFiltersEmpty =
    //     (filter == null);
    log('Enter----FilterList ${filterTitle}');
    if (_filterListQueryCache.containsKey(filterTitleQuery)) {
      filterQuery = _filterListQueryCache[filterTitleQuery]!;
    } else {
      var textIsNotEmpty = (text != null && text.replaceAll(' ', '') != "");

      if (textIsNotEmpty) {
        //All filters unselected should search on title or body
        if (filterTitle == null) {
          filterQuery['filter[or-group][group][conjunction]'] = 'OR';
        }
        if (filterTitle == 'title' ||
            filterTitle == "published" ||
            filterTitle == null) {
          filterQuery['filter[title-filter][condition][path]'] = 'title';
          filterQuery['filter[title-filter][condition][value]'] = text;
          filterQuery['filter[title-filter][condition][operator]'] = 'CONTAINS';
          if (filterTitle == null) {
            filterQuery['filter[title-filter][condition][memberOf]'] =
                'or-group';
          }
        }

        if (filterTitle == 'body' ||
            filterTitle == "published" ||
            filterTitle == null) {
          filterQuery['filter[body-filter][condition][path]'] = 'body.value';
          filterQuery['filter[body-filter][condition][value]'] = text;
          filterQuery['filter[body-filter][condition][operator]'] = 'CONTAINS';
          if (filterTitle == null) {
            filterQuery['filter[body-filter][condition][memberOf]'] =
                'or-group';
          }
        }
      }

      if (filterTitle == "published") {
        filterQuery['filter[status-filter][condition][path]'] = 'status';
        filterQuery['filter[status-filter][condition][value]'] = '1';
        filterQuery['filter[status-filter][condition][operator]'] = '=';

        if (textIsNotEmpty) {
          filterQuery['filter[and-status-group][group][conjunction]'] = 'AND';
          filterQuery['filter[or-status-group][group][conjunction]'] = 'OR';
          //Put the OR group into the AND GROUP
          filterQuery['filter[or-status-group][group][memberOf]'] =
              'and-status-group';
          filterQuery['filter[status-filter][condition][memberOf]'] =
              'and-status-group';
          filterQuery['filter[title-filter][condition][memberOf]'] =
              'or-status-group';
          filterQuery['filter[body-filter][condition][memberOf]'] =
              'or-status-group';
        }
      }

      if (filterQuery.isNotEmpty) {
        _filterListQueryCache = {};
        _filterListQueryCache[filterTitleQuery] = filterQuery;
        // log('_filterListQueryCache ----- ${_filterListQueryCache}');
      }
    }

    filterQuery['sort[sort-created][path]'] = 'created';
    filterQuery['sort[sort-created][direction]'] = 'DESC';

    if (offset != null && limit != null) {
      filterQuery['page[offset]'] = offset.toString();
      filterQuery['page[limit]'] = limit.toString();
    }

    return getUsersByFilter(filterQuery);
  }

  Future<List<UserModel>?> list(
      {String? title,
      String condition = 'CONTAINS',
      int? offset,
      int? limit}) async {
    var filterTitle = '${userType}filterByTitle';
    Map<String, dynamic> filter = {};
    if (offset != null && limit != null) {
      filter['page[offset]'] = offset.toString();
      filter['page[limit]'] = limit.toString();
    }
    if (title != null) {
      filter['filter[$filterTitle][condition][path]'] = 'title';
      filter['filter[$filterTitle][condition][value]'] = title;
      filter['filter[$filterTitle][condition][operator]'] = condition;
    }
    log('Filterrrr --- ${filter}');
    return getUsersByFilter(filter = filter);
  }

  Future<UserModel> load(String id, {List<String>? include}) async {
    Map<String, dynamic> query = {};

    if (include != null && include.isNotEmpty) {
      query = {'include': include.join(',')};
    }
    var response = await get(
      '$userPath/$userType/$id',
      query: query,
      // headers: {
      //   'Content-type': 'application/vnd.api+json',
      //   'Accept': 'application/json'
      // },
    );
    var result = jsonDecode(response.body);
    if (response.isOk) {
      UserModel user = UserModel.fromJson(result);

      return user;
    } else {
      var addMsg = result['error_messages'] ?? '';
      throw Exception(
          'An error occurred when load user($addMsg), please try again!');
    }
  }

  Future<UserModel> create(UserModel user) async {
    log('create--------${user.toJson()}');
    var response = await post('$userPath/${user.type}', user.toJson());
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return UserModel.fromJson(result);
    } else {
      var addMsg = '';
      if (response.statusCode == HttpStatus.unprocessableEntity) {
        addMsg =
            'Maybe the uploaded file exceeds the limit allowed in the field settings';
      }

      addMsg += result['error_messages'];
      throw Exception(
          'An error occurred when creating an user ($addMsg), please try again!');
    }
  }

  Future<UserModel> update(UserModel user) async {
    log('Update--------${user.toJson()}');
    try {
      var response =
          await patch('$userPath/${user.type}/${user.id}', user.toJson());
      log('${response.statusText}');
      var result = jsonDecode(response.body);

      if (response.isOk) {
        return UserModel.fromJson(result);
      } else {
        throw Exception(
            'An error occurred when updating an user, please try again!');
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Delete user by pass  UUID `id`
  Future<bool> remove(String id) async {
    log('delete taxonomy******delete********* ${id}');

    var response = await delete('$userPath/$userType/$id');
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return true;
    } else {
      var addMsg = result['error_messages'];

      throw Exception(
          'An error occurred when deleting an user($addMsg), please try again!');
    }
  }
}
