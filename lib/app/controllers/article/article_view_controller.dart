import 'dart:developer';

import '../../models/node/article_model.dart';
import 'package:get/get.dart';

import '../../models/file_model.dart';
import '../../models/taxonomy/taxonomy_model.dart';
import '../node/node_view_controller.dart';

class ArticleViewController extends NodeViewController<ArticleModel> {
  ArticleViewController(nodeType, id, _nodeApiService)
      : super(nodeType, id, _nodeApiService, include: ['field_image']);

  Rxn<List<TaxonomyModel>> tags = Rxn<List<TaxonomyModel>>([]);
  Rxn<List<FileModel>?> images = Rxn<List<FileModel>>([]);
  @override
  void onInit() async {
    super.onInit();
    ever(loading, (loaded) {
      if (loaded == false) _initDefaultValueFields();
    });
  }

  _initDefaultValueFields() {
    log('Images length ...${node.images.length!}');
    tags.value = node!.tags;
    images.value = node!.images;

    return true;
  }
}
