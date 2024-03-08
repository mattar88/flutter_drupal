import 'package:get/get.dart';

import '../../models/file_model.dart';
import '../../services/node_api_service.dart';
import '../base_controller.dart';

class NodeController<T> extends BaseController {
  final NodeApiService<T> _nodeApiService;

  NodeController(this._nodeApiService);

  Future<List<T>?> getNodes(String nodeType,
      {String? title, String condition = 'CONTAINS', offset, limit}) async {
    try {
      return await _nodeApiService.list(nodeType,
          title: title, condition: condition, offset: offset, limit: limit);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<FileModel?> uploadFile(
      String nodeType, String fieldMachineName, dynamic file,
      {Progress? uploadProgress}) async {
    try {
      return await _nodeApiService.uploadFile(nodeType, fieldMachineName, file,
          uploadProgress: uploadProgress);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///
  ///@include used to load associated objects example({include=field_tags})
  ///with this example we load the node with all tags objects
  ///more details: https://www.drupal.org/docs/core-modules-and-themes/core-modules/jsonapi-module/includes
  ///
  Future<dynamic> load(String nodeType, String id,
      {List<String>? include}) async {
    try {
      return await _nodeApiService.load(nodeType, id, include: include);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<T> create(T node) async {
    try {
      return await _nodeApiService.create(node);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<dynamic> edit(T node) async {
    try {
      return await _nodeApiService.update(node);
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<bool> delete(String nodeType, String id) async {
    try {
      return await _nodeApiService.remove(nodeType, id);

      // log('GetNodeList:  ${response.body}');
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }
}
