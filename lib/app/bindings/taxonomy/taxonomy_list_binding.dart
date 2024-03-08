import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../controllers/taxonomy/taxonomy_list_controller.dart';
import '../../services/taxonomy_api_service.dart';

class TaxonomyListBinding extends Bindings {
  TaxonomyListBinding({this.vocabulary});

  ///Define the bundle of Taxonomy
  String? vocabulary;
  @override
  void dependencies() {
    if (Get.parameters.containsKey('vocabulary')) {
      vocabulary = Get.parameters['vocabulary'].toString();
    }
    if (vocabulary == null) {
      throw Exception(
          'An error occurred when opening taxonomy list, Invalid vocabulary!.');
    }
    Get.lazyPut<TaxonomyListController>(() =>
        TaxonomyListController(vocabulary!, Get.put(TaxonomyApiService())));
  }
}
