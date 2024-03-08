import 'package:get/get.dart';

import '../../controllers/taxonomy/taxonomy_view_controller.dart';
import '../../services/taxonomy_api_service.dart';

class TaxonomyViewBinding extends Bindings {
  TaxonomyViewBinding();
  String? vocabulary;
  String? id;

  @override
  void dependencies() {
    if (Get.parameters.containsKey('vocabulary')) {
      vocabulary = Get.parameters['vocabulary'].toString();
    } else {
      throw Exception(
          'An error occurred when view taxonomy, Empty Vocabulary!.');
    }

    if (Get.parameters.containsKey('id')) {
      id = Get.parameters['id'].toString();
    } else {
      throw Exception('An error occurred when view taxonomy, Empty Id!.');
    }

    Get.lazyPut<TaxonomyViewController>(() =>
        TaxonomyViewController(vocabulary!, id, Get.put(TaxonomyApiService())));
  }
}
