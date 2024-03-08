import '../../models/enum/entity_action.dart';
import 'package:get/get.dart';

import '../../controllers/taxonomy/taxonomy_form_controller.dart';
import '../../services/taxonomy_api_service.dart';

class TaxonomyFormBinding extends Bindings {
  TaxonomyFormBinding(this.action);
  String? vocabulary;
  String? id;
  final EntityAction action;
  @override
  void dependencies() {
    if (Get.parameters.containsKey('vocabulary')) {
      vocabulary = Get.parameters['vocabulary'].toString();
    } else {
      throw Exception(
          'An error occurred when $action taxonomy, Empty Vocabulary!.');
    }

    if (action == EntityAction.edit) {
      if (Get.parameters.containsKey('id')) {
        id = Get.parameters['id'].toString();
      } else {
        throw Exception('An error occurred when $action taxonomy, Empty Id!.');
      }
    }

    Get.lazyPut<TaxonomyFormController>(() => TaxonomyFormController(
        vocabulary!, action, id, Get.put(TaxonomyApiService())));
  }
}
