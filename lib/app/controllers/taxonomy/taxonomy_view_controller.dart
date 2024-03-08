import 'dart:convert';
import 'dart:developer';
import '../../controllers/taxonomy/taxonomy_controller.dart';

import '../../models/taxonomy/taxonomy_model.dart';
import '../../services/taxonomy_api_service.dart';

import 'package:get/get.dart';

class TaxonomyViewController extends TaxonomyController {
  final String vocabulary;

  final String? id;
  final TaxonomyApiService _taxonomyApiService;

  TaxonomyViewController(this.vocabulary, this.id, this._taxonomyApiService)
      : super(_taxonomyApiService);

  late TaxonomyModel? taxonomy;
  Rxn<bool> loading = Rxn<bool>(false);
  String? title;

  @override
  void onInit() async {
    title = Get.arguments != null && Get.arguments.containsKey('title')
        ? Get.arguments['title']
        : 'View Taxonomy';
    loading.value = true;
    taxonomy = await load(vocabulary, id!);
    loading.value = false;
    super.onInit();
  }
}
