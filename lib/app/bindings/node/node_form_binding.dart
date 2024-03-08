import 'dart:developer';

import '../../models/enum/entity_action.dart';
import 'package:get/get.dart';

import '../../controllers/node/node_form_controller.dart';
import '../../models/node/node_model.dart';
import '../../services/node_api_service.dart';

class NodeFormBinding extends Bindings {
  NodeFormBinding(this.action, {this.nodeType, this.id});
  String? nodeType;
  String? id;
  final EntityAction action;
  @override
  void dependencies() {
    if (Get.parameters.containsKey('nodeType')) {
      nodeType = Get.parameters['nodeType'].toString();
    }
    if (nodeType!.isEmpty) {
      throw Exception('An error occurred when $action node, Empty Node!.');
    }

    if (action == EntityAction.edit) {
      if (Get.parameters.containsKey('id')) {
        id = Get.parameters['id'].toString();
      }

      if (id!.isEmpty) {
        throw Exception('An error occurred when $action Node, Empty Id!.');
      }
    }

    Get.lazyPut<NodeFormController<NodeModel>>(() =>
        NodeFormController<NodeModel>(nodeType!, action, id,
            Get.put(NodeApiService<NodeModel>(NodeModel.fromJson))));

    // log('NodeFormBinding: ${id} ${action}');
  }
}
