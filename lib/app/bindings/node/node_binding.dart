import 'package:get/get.dart';

import '../../controllers/node/node_controller.dart';
import '../../models/node/node_model.dart';
import '../../services/node_api_service.dart';

class NodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NodeController<NodeModel>>(() => NodeController<NodeModel>(
        Get.put(NodeApiService<NodeModel>(NodeModel.fromJson))));
  }
}
