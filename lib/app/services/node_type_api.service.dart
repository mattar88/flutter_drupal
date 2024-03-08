import 'dart:convert';
import 'dart:io';

import '../models/node/node_type_mode.dart';
import 'api_service.dart';

class NodeTypeApiService extends ApiService {
  static String nodeTypesPath = '/node_type/node_type';

  Future<List<NodeTypeModel>?> list() async {
    return get(nodeTypesPath, headers: {
      // 'Content-type': 'application/vnd.api+json',
      'Accept': 'application/json'
    }).then((response) {
      // log('${response.statusText}, ${response.statusCode}, ${response.body.toString()}');
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['data'] != null) {
          return List<NodeTypeModel>.from(result['data']
              .map((nodeTypeJson) => NodeTypeModel.fromJson(nodeTypeJson))
              .toList());
        }
      } else {
        if (response.statusCode == HttpStatus.unauthorized) {
          throw Exception(
              'An error occurred when load list of Node types, maybe you don\'t have the right permissions!');
        }
        throw Exception(
            'An error occurred please try again ${response.statusCode}, ');
      }
      //
    });
  }
}
