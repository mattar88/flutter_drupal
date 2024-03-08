import 'package:get/get.dart';

import '../../controllers/article/article_form_controller.dart';
import '../../models/enum/entity_action.dart';
import '../../models/node/article_model.dart';
import '../../services/node_api_service.dart';
import '../node/node_form_binding.dart';

class ArticleFormBinding extends NodeFormBinding {
  final EntityAction action;
  String? id;
  ArticleFormBinding(this.action)
      : super(action, id: null, nodeType: 'article');

  @override
  void dependencies() {
    super.dependencies();

    Get.lazyPut<ArticleFormController>(() => ArticleFormController(action, id,
        Get.put(NodeApiService<ArticleModel>(ArticleModel.fromJson))));
  }
}
