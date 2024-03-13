import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../locale/config_locale.dart';
import '../controllers/auth_controller.dart';
import '../models/file_model.dart';
import '../routes/app_pages.dart';
import '../values/app_colors.dart';
import 'api_service.dart';

class NodeApiService<T> extends ApiService {
  String nodePath = '/node';
  final bool localeEnabled = true;

  final Function(Map<String, dynamic> json) fromJson;
  NodeApiService(this.fromJson);

//In this function we uses the main HTTP package because
//GetConnect doesn't support bodyBytes in addition we inject access tokens
//@TODO: integrate with GETconnect and use AddRequestModifier() in ApiService
//to inject access token.
  Future<FileModel?> uploadFile(
      String nodeType, String fieldMachineName, XFile? file,
      {Progress? uploadProgress}) async {
    AuthController authController = Get.find();

    final stream = file!.openRead();
    int length = await file.length();
    final client = new HttpClient();

    final request = await client.postUrl(Uri.parse(
        '$baseUrl/$apiPathPrefix$nodePath/$nodeType/$fieldMachineName'));
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

        // throw Exception(
        //     'An error occurred, Method not allowed maybe the node does not contains field of type file!');
        Get.snackbar(
          'Error',
          'An error occurred, Method not allowed maybe the node does not contains field of type file!',
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

  Map<String, Map<String, dynamic>> _filterListQueryCache = {};

  Future<List<T>?> filterList(String nodeType,
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

    return getNodesByFilter(nodeType, filterQuery);
  }

  Future<List<T>?> getNodesByFilter(
      String nodeType, Map<String, dynamic> filter) async {
    if (localeEnabled) {
      filter['filter[langcode]'] =
          ConfigLocale.currentLocale.locale.languageCode;
    }
    var response = await get('$nodePath/$nodeType', query: filter);
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return List<T>.from(result['data']
          .map((nodeJson) => fromJson({'data': nodeJson}))
          .toList());
    } else {
      throw Exception(
          'An error occurred when filter list of content(${result['error_messages']}), please try again!');
    }
  }

  Future<List<T>?> list(String nodeType,
      {String? title,
      String condition = 'CONTAINS',
      int? offset,
      int? limit}) async {
    var filterTitle = '${nodeType}filterByTitle';
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
    return getNodesByFilter(nodeType = nodeType, filter = filter);
  }

  Future<T?> load(String nodeType, String id, {List<String>? include}) async {
    Map<String, dynamic> query = {};

    if (include != null && include.isNotEmpty) {
      query = {'include': include.join(',')};
    }
    var response = await get(
      '$nodePath/$nodeType/$id',
      query: query,
    );
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return fromJson(result);
    } else {
      throw Exception(
          'An error occurred when load node(${result['error_messages']}), please try again!');
    }
  }

  Future<T> create(dynamic node) async {
    log('create--------${node.toJson()}');
    var response = await post('$nodePath/${node.type}', node.toJson());
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return fromJson(result);
    } else {
      var addMsg = result['error_messages'];
      if (response.statusCode == HttpStatus.unprocessableEntity) {
        addMsg +=
            'Maybe the uploaded file exceeds the limit allowed in the field settings';
      }
      throw Exception(
          'An error occurred when creating an node ($addMsg), please try again!');
    }
  }

  Future<T> update(dynamic node) async {
    log('Update--------${node.toJson()}');
    var response =
        await patch('$nodePath/${node.type}/${node.id}', node.toJson());
    log('${response.statusText}');
    var result = jsonDecode(response.body);
    if (response.isOk) {
      return fromJson(result);
    } else {
      throw Exception(
          'An error occurred when updating an node(${result['error_messages']}), please try again!');
    }
  }

  ///Delete node by pass `nodeType` and UUID `id`
  Future<bool> remove(String nodeType, String id) async {
    var response = await delete('$nodePath/$nodeType/$id');
    if (response.isOk) {
      return true;
    } else {
      //Only on exception response has body
      var result = jsonDecode(response.body);
      throw Exception(
          'An error occurred when deleting an node(${result['error_messages']}), please try again!');
    }
  }
}
