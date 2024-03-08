import '../../controllers/base_controller.dart';
import 'package:get/get.dart';

import '../../models/enum/message_status.dart';
import '../../models/taxonomy/taxonomy_vocabulary_mode.dart';
import '../../services/taxonomy_vocabulary_api.service.dart';

class TaxonomyVocabularyListController extends BaseController {
  final TaxonomyVocabularyApiService _taxonomyVocabularyApiService;

  Rxn<bool> isLoading = Rxn<bool>(false);
  var list = RxList(<TaxonomyVocabularyModel>[]);

  TaxonomyVocabularyListController(this._taxonomyVocabularyApiService);
  @override
  void onInit() {
    try {
      isLoading.value = true;
      _taxonomyVocabularyApiService.list().then((value) {
        isLoading.value = false;
        list.value = value!;
      }).catchError((onError) {
        isLoading.value = false;
        list.value = <TaxonomyVocabularyModel>[];
        addMessage(message: onError.toString(), status: MessageStatus.error);
        throw Exception(onError);
      });
    } catch (e) {
      isLoading.value = false;
    }

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
