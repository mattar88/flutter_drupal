import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../services/node_api_service.dart';
import 'node_controller.dart';

class NodeViewController<T> extends NodeController<T> {
  final String nodeType;
  final String? id;
  final NodeApiService<T> _nodeApiService;
  late dynamic node;
  List<String>? include;

  NodeViewController(this.nodeType, this.id, this._nodeApiService,
      {this.include})
      : super(_nodeApiService) {
    include = include != null ? [...?include, 'uid'] : ['uid'];
  }

  Rxn<bool> loading = Rxn<bool>(false);
  String? title;

  @override
  void onInit() async {
    try {
      title = Get.arguments != null && Get.arguments.containsKey('title')
          ? Get.arguments['title']
          : 'View node';
      loading.value = true;
      node = await load(nodeType, id!, include: include) as T;
      loading.value = false;
    } catch (e) {
      throw Exception('NodeViewController: $e');
    }
    super.onInit();
  }

  get updateDate => DateFormat('yyyy-MM-dd HH:mm').format(node.changed);
  get createdDate => DateFormat('dd MMMM, yyyy').format(node.created);
}
