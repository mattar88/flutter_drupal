import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../models/enum/message_status.dart';
import '../../models/node/node_type_mode.dart';
import '../../services/node_type_api.service.dart';

class NodeTypeListController extends BaseController {
  final NodeTypeApiService _nodeTypeApiService;

  Rxn<bool> isLoading = Rxn<bool>(false);
  var list = RxList(<NodeTypeModel>[]);

  NodeTypeListController(this._nodeTypeApiService);
  @override
  void onInit() async {
    isLoading.value = true;
    _nodeTypeApiService.list().then((value) {
      isLoading.value = false;
      list.value = value!;
    }).catchError((onError) {
      isLoading.value = false;
      list.value = <NodeTypeModel>[];
      addMessage(message: onError.toString(), status: MessageStatus.error);
      throw Exception(onError);
    });
    super.onInit();
  }
}
