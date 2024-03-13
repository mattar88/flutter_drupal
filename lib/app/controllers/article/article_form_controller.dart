import 'dart:developer';

import '../../models/node/article_model.dart';
import 'package:get/get.dart';

import '../../locale/config_locale.dart';
import '../../models/enum/entity_action.dart';
import '../../models/file_model.dart';
import '../../models/taxonomy/taxonomy_model.dart';
import '../../services/node_api_service.dart';
import '../node/node_form_controller.dart';
import '../node/node_list_controller.dart';

class ArticleFormController extends NodeFormController<ArticleModel> {
  final EntityAction action;
  final String? id;
  final NodeApiService<ArticleModel> _nodeApiService;
  ArticleFormController(this.action, this.id, this._nodeApiService)
      : super('article', action, id, _nodeApiService,
            include: ['field_image', 'field_tags', 'uid']);

  Rxn<List<TaxonomyModel>> tags = Rxn<List<TaxonomyModel>>([]);
  Rxn<List<FileModel>?> images = Rxn<List<FileModel>>([]);
  @override
  void onInit() async {
    super.onInit();
    ever(initializing, (processing) {
      log('OnInit.....................######${processing}');
      if (processing == false) _initDefaultValueFields();
    });
    // _initDefaultValueFields();
  }

  _initDefaultValueFields() {
    tags.value = node!.tags;
    images.value = node!.images;

    return true;
  }

  Future<void> submit() async {
    //tags.value = [];
    // log('Tags.2....${tags.value}');
    // log('${emailController.text}, ${passwordController.text}');
    if (nodeFormKey.currentState!.validate()) {
      var isEditing = EntityAction.edit == action && id!.isNotEmpty;

      try {
        log('Tags.....${tags.value}');
        var submitedNode = ArticleModel(
            type: nodeType,
            id: isEditing ? id : null,
            title: titleController.text,
            body: bodyController.text,
            alias: aliasController.text,
            status: status.value,
            tags: tags.value,
            images: images.value,
            langcode: isEditing
                ? node.langcode
                : ConfigLocale.currentLocale.locale.languageCode);
        log('Helloooo: ${titleController.text}');
        if (isEditing) {
          var node = (await _nodeApiService.update(submitedNode));
          log('After submittinnng....');
          if (Get.isRegistered<NodeListController>()) {
            Get.find<NodeListController>().editListItem(nodeType, id!, node);
          }
        } else {
          log('submittaxonomy***************  ');
          var node = await _nodeApiService.create(submitedNode);
          if (Get.isRegistered<NodeListController>()) {
            Get.find<NodeListController>().addListItem(node);
          }
        }
      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +
        log('Error occurred: ${err} {${nodeType}, ${titleController.text}, ${status.value}}');

        rethrow;
      } finally {
        // if (!isEditing) clearFields();
      }
    } else {
      throw Exception('An error occurred, invalid inputs value');
    }
  }
}
