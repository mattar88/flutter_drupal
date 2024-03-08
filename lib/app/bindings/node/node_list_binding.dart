import 'dart:developer';

import 'package:get/get.dart';

import '../../controllers/node/node_list_controller.dart';
import '../../models/node/article_model.dart';
import '../../models/node/node_model.dart';
import '../../services/node_api_service.dart';

class NodeListBinding extends Bindings {
  NodeListBinding({this.nodeType});

  ///Define the bundle of node
  String? nodeType;
  @override
  void dependencies() {
    if (Get.parameters.containsKey('nodeType')) {
      nodeType = Get.parameters['nodeType'].toString();
    }
    if (nodeType == null) {
      throw Exception(
          'An error occurred when opening Node list, Invalid Node Type!.');
    }

    Get.lazyPut<NodeListController>(() => NodeListController(
        nodeType!, Get.put(NodeApiService<NodeModel>(NodeModel.fromJson))));
  }
}
