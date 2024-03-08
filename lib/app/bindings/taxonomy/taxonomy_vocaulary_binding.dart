import 'package:get/get.dart';

import '../../controllers/taxonomy/taxonomy_vocabulary_list_controller.dart';
import '../../services/taxonomy_vocabulary_api.service.dart';

class TaxonomyVocabularyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaxonomyVocabularyListController>(() =>
        TaxonomyVocabularyListController(
            Get.put(TaxonomyVocabularyApiService())));
  }
}
