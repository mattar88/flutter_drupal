import 'package:get/get.dart';

import '../../controllers/node/node_view_controller.dart';
import '../../models/node/node_model.dart';
import '../../services/node_api_service.dart';

class NodeViewBinding extends Bindings {
  NodeViewBinding({this.nodeType, this.id});
  String? id;
  String? nodeType;

  @override
  void dependencies() {
    if (Get.parameters.containsKey('nodeType')) {
      nodeType = Get.parameters['nodeType'].toString();
    }
    if (nodeType!.isEmpty) {
      throw Exception('An error occurred when view node, Empty Node!.');
    }

    if (Get.parameters.containsKey('id')) {
      id = Get.parameters['id'].toString();
    }

    if (id!.isEmpty) {
      throw Exception('An error occurred when view Node, Empty Id!.');
    }

    Get.lazyPut<NodeViewController<NodeModel>>(() =>
        NodeViewController<NodeModel>(nodeType!, id,
            Get.put(NodeApiService<NodeModel>(NodeModel.fromJson))));
  }
}
