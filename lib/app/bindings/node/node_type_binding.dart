import 'package:get/get.dart';

import '../../controllers/node/node_type_list_controller.dart';
import '../../services/node_type_api.service.dart';

class NodeTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NodeTypeListController>(
        () => NodeTypeListController(Get.put(NodeTypeApiService())));
  }
}
