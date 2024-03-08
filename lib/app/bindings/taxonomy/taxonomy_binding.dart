import 'package:get/get.dart';

import '../../controllers/taxonomy/taxonomy_controller.dart';
import '../../services/taxonomy_api_service.dart';

class TaxonomyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaxonomyController>(
        () => TaxonomyController(Get.put(TaxonomyApiService())));
  }
}
