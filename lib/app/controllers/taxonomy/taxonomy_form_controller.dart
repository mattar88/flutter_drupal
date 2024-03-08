import 'dart:developer';

import 'package:flutter/cupertino.dart';
import '../../controllers/taxonomy/taxonomy_controller.dart';
import '../../controllers/taxonomy/taxonomy_list_controller.dart';
import '../../models/enum/entity_action.dart';
import '../../models/taxonomy/taxonomy_model.dart';
import 'package:get/get.dart';

import '../../services/taxonomy_api_service.dart';

class TaxonomyFormController extends TaxonomyController {
  final String vocabulary;
  final EntityAction action;
  final String? id;
  final TaxonomyApiService _taxonomyApiService;
  Rxn<bool> initializing = Rxn<bool>(false);

  late TaxonomyModel? taxonomy;
  List<TaxonomyModel>? relationsFieldOptions = [];

  TaxonomyFormController(
      this.vocabulary, this.action, this.id, this._taxonomyApiService)
      : super(_taxonomyApiService);

  late GlobalKey<FormState> taxonomyFormKey;
  final nameController = TextEditingController();
  final formNameFieldKey = GlobalKey<FormFieldState>();
  FocusNode nameFocusNode = FocusNode();
  final descriptionController = TextEditingController();
  final formDescriptionFieldKey = GlobalKey<FormFieldState>();
  FocusNode descriptionFocusNode = FocusNode();
  final aliasController = TextEditingController();
  final formAliasFieldKey = GlobalKey<FormFieldState>();
  FocusNode aliasFocusNode = FocusNode();
  final Rxn<bool> status = Rxn<bool>(true);
  Rxn<List<TaxonomyModel>?> parent = Rxn<List<TaxonomyModel>>([]);

  String? title;

  @override
  void onInit() async {
    title = Get.arguments != null && Get.arguments.containsKey('title')
        ? Get.arguments['title']
        : 'Taxonomy';
    try {
      initializing.value = true;
      await initParentField();

      _addListener();
      if (action == EntityAction.edit) {
        if (id != null) {
          taxonomyFormKey =
              GlobalKey<FormState>(debugLabel: "__EditTaxonomyFormKey${id}__");
          await initDefaultValueFields();

          initializing.value = false;
        } else {
          initializing.value = false;
          throw ('An error occurred invalid taxonomy id.');
        }
      } else {
        //Nothing to do in Add action but add this condition
        // and use observable variable is important top prevent Getx/Obx errors
        taxonomyFormKey =
            GlobalKey<FormState>(debugLabel: "__AddTaxonomyFormKey__");
        initializing.value = false;
      }
    } catch (err) {
      throw Exception('An error occurred: $err');
    }
    // textFieldFocusNode.hasFocus = false;
    super.onInit();
  }

  initParentField() async {
    relationsFieldOptions = await _taxonomyApiService.list(vocabulary);

    if (action == EntityAction.edit) {
      relationsFieldOptions = relationsFieldOptions!.where((rTerm) {
        //Exclude current term on Edit Action
        if (id == rTerm.id) {
          return false;
        }
        //Exclude all the children to prevent loop
        if (rTerm.parent!.where((cPTerm) => cPTerm['id'] == id).isNotEmpty) {
          return false;
        }

        return true;
      }).toList();
    }

    return true;
  }

  initDefaultValueFields() async {
    taxonomy = await load(vocabulary, id!);
    nameController.text = taxonomy!.name;
    descriptionController.text = taxonomy!.description.toString();
    aliasController.text =
        taxonomy!.alias != null ? taxonomy!.alias.toString() : '';
    status.value = taxonomy!.status;
    // parent.value = action == EntityAction.edit
    //     ? relationsFieldOptions!.where((pTaxonomy) {
    //         return taxonomy!.parent!
    //             .where((element) => element['id'] == pTaxonomy.id)
    //             .isNotEmpty;
    //       }).toList()
    //     : <TaxonomyModel>[];

    return true;
  }

  void _addListener() {
    nameFocusNode.addListener(() {
      log('bodyFocusNode-----${nameFocusNode.hasFocus}');
      if (!nameFocusNode.hasFocus) {
        formNameFieldKey.currentState!.validate();
        // fieldLostFocus = usernameController.hashCode.toString();
      }
    });
    descriptionFocusNode.addListener(() {
      log('odyFocusNode-----${descriptionFocusNode.hasFocus}');
      if (!descriptionFocusNode.hasFocus) {
        formDescriptionFieldKey.currentState!.validate();
      }
    });
    aliasFocusNode.addListener(() {
      if (!aliasFocusNode.hasFocus) {
        formAliasFieldKey.currentState!.validate();
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    nameFocusNode.dispose();
    aliasController.dispose();
    aliasFocusNode.dispose();
    descriptionController.dispose();
    descriptionFocusNode.dispose();

    super.onClose();
  }

  String? nameValidator(String? value) {
    // if(fieldLostFocus == usernameController.hashCode)
    log('nameValidator-----');
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 4) {
      return 'name must be at least 4 characters in length';
    }
    // Return null if the entered name is valid
    return null;
  }

  String? descriptionValidator(String? value) {
    return null;
  }

  String? aliasValidator(String? value) {
    return null;
  }

  String? validator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void onChangeStatus(value) {
    status.value = value;
  }

  void clearFields() {
    nameController.clear();
    descriptionController.clear();
    aliasController.clear();
  }

  parentSetValues(values) {
    parent(values);
  }

  Future<void> submit() async {
    // log('${emailController.text}, ${passwordController.text}');
    if (taxonomyFormKey.currentState!.validate()) {
      var isEditing = EntityAction.edit == action && id!.isNotEmpty;
      try {
        var submitedTaxonomy = TaxonomyModel(
            vocabulary: vocabulary,
            id: isEditing ? id : null,
            name: nameController.text,
            description: descriptionController.text,
            alias: aliasController.text,
            status: status.value,
            parent: parent.value!.isNotEmpty
                ? parent.value!
                    .map((e) => {'id': e.id, 'vocabulary': e.vocabulary})
                    .toList()
                : []);

        if (isEditing) {
          var taxonomy = await _taxonomyApiService.update(submitedTaxonomy);

          if (Get.isRegistered<TaxonomyListController>()) {
            Get.find<TaxonomyListController>()
                .editListItem(vocabulary, id!, taxonomy);
          }
        } else {
          // log('submittaxonomy*************** ${data}');
          var taxonomy = await _taxonomyApiService.create(submitedTaxonomy);
          if (Get.isRegistered<TaxonomyListController>()) {
            Get.find<TaxonomyListController>().addListItem(taxonomy);
          }
        }
      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +
        log('Error occurrend: ${err}');

        rethrow;
      } finally {
        if (!isEditing) clearFields();
      }
    } else {
      throw Exception('An error occurred, invalid inputs value');
    }
  }
}
