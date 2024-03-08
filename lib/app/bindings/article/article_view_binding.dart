import 'package:get/get.dart';

import '../../controllers/article/article_view_controller.dart';
import '../../models/node/article_model.dart';
import '../../services/node_api_service.dart';
import '../node/node_view_binding.dart';

class ArticleViewBinding extends NodeViewBinding {
  ArticleViewBinding({this.id}) : super(id: null, nodeType: 'article');
  String? id;

  @override
  void dependencies() {
    super.dependencies();

    Get.lazyPut<ArticleViewController>(() => ArticleViewController('article',
        id, Get.put(NodeApiService<ArticleModel>(ArticleModel.fromJson))));
  }
}
