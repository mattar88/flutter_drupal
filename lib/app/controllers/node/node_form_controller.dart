import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../locale/config_locale.dart';
import '../../models/enum/entity_action.dart';
import '../../models/node/node_model.dart';
import '../../services/node_api_service.dart';
import 'node_controller.dart';
import 'node_list_controller.dart';

class NodeFormController<T> extends NodeController<T> {
  final String nodeType;
  final EntityAction action;
  final String? id;
  final NodeApiService<T> _nodeApiService;
  Rxn<bool> initializing = Rxn<bool>(false);
  late dynamic node;
  List<String>? include;

  NodeFormController(this.nodeType, this.action, this.id, this._nodeApiService,
      {this.include})
      : super(_nodeApiService) {
    include = include ?? [];
  }

  late GlobalKey<FormState> nodeFormKey;
  final titleController = TextEditingController();
  final formTitleFieldKey = GlobalKey<FormFieldState>();
  FocusNode titleFocusNode = FocusNode();
  final bodyController = TextEditingController();
  final formBodyFieldKey = GlobalKey<FormFieldState>();
  FocusNode bodyFocusNode = FocusNode();
  final aliasController = TextEditingController();
  final formAliasFieldKey = GlobalKey<FormFieldState>();
  FocusNode aliasFocusNode = FocusNode();
  final Rxn<bool> status = Rxn<bool>(true);

  String? title;

  @override
  onInit() async {
    await initializeNodeForm();
    // textFieldFocusNode.hasFocus = false;
    log('NodeFormController done.......');
    super.onInit();
  }

  initializeNodeForm() async {
    title = Get.arguments != null && Get.arguments.containsKey('title')
        ? Get.arguments['title']
        : null;
    try {
      initializing.value = true;
      // await initParentField();

      _addListener();
      if (action == EntityAction.edit) {
        if (id != null) {
          nodeFormKey =
              GlobalKey<FormState>(debugLabel: "__EditnodeFormKey${id}__");
          await _initDefaultValueFields();

          initializing.value = false;
        } else {
          initializing.value = false;
          throw ('An error occurred invalid node id.');
        }
      } else {
        //Nothing to do in Add action but add this condition
        // and use observable variable is important to prevent Getx/Obx errors
        nodeFormKey = GlobalKey<FormState>(debugLabel: "__AddnodeFormKey__");
        initializing.value = false;
      }
    } catch (err) {
      throw Exception('initializeNodeForm: ${err}');
    }
  }

  // initParentField() async {
  //   relationsFieldOptions =
  //       await _taxonomyApiService.getTaxonomiesByFilter(vocabulary, null);
  //   if (action == EntityAction.edit) {
  //     relationsFieldOptions = relationsFieldOptions!.where((rTerm) {
  //       //Exclude current term on Edit Action
  //       if (id == rTerm.id) {
  //         return false;
  //       }
  //       //Exclude all the children to prevent loop
  //       if (rTerm.parent!.where((cPTerm) => cPTerm['id'] == id).isNotEmpty) {
  //         return false;
  //       }

  //       return true;
  //     }).toList();
  //   }

  //   return true;
  // }

  _initDefaultValueFields() async {
    log('initDefaultValueFields1----------------1');
    node = await load(nodeType, id!, include: include) as T;

    log('initDefaultValueFields2----------------1: ${node!.toJson()}');
    titleController.text = node!.title;
    bodyController.text = node!.body.toString();
    aliasController.text = node!.alias != null ? node!.alias.toString() : '';
    status.value = node!.status;

    return true;
  }

  void _addListener() {
    titleFocusNode.addListener(() {
      log('bodyFocusNode-----${titleFocusNode.hasFocus}');
      if (!titleFocusNode.hasFocus) {
        formTitleFieldKey.currentState!.validate();
        // fieldLostFocus = usertitleController.hashCode.toString();
      }
    });
    bodyFocusNode.addListener(() {
      log('odyFocusNode-----${bodyFocusNode.hasFocus}');
      if (!bodyFocusNode.hasFocus) {
        formBodyFieldKey.currentState!.validate();
      }
    });
    aliasFocusNode.addListener(() {
      if (!aliasFocusNode.hasFocus) {
        formAliasFieldKey.currentState!.validate();
      }
    });
  }

  String? titleValidator(String? value) {
    // if(fieldLostFocus == usertitleController.hashCode)
    log('titleValidator-----');
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 4) {
      return 'name must be at least 4 characters in length';
    }
    // Return null if the entered name is valid
    return null;
  }

  String? bodyValidator(String? value) {
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
    titleController.clear();
    bodyController.clear();
    aliasController.clear();
  }

  parentSetValues(values) {
    // parent(values);
  }

  Future<void> submit() async {
    // log('${emailController.text}, ${passwordController.text}');
    if (nodeFormKey.currentState!.validate()) {
      var isEditing = EntityAction.edit == action && id!.isNotEmpty;
      // log('on submit images length: ${images.value!.first.id}');
      try {
        var submitedNode = NodeModel(
            type: nodeType,
            id: isEditing ? id : null,
            title: titleController.text,
            body: bodyController.text,
            alias: aliasController.text,
            status: status.value,
            langcode: isEditing
                ? node.langcode
                : ConfigLocale.currentLocale.locale.languageCode);

        if (isEditing) {
          var node = (await _nodeApiService.update(submitedNode)) as NodeModel;
          log('After submittinnng....');
          if (Get.isRegistered<NodeListController>()) {
            Get.find<NodeListController>().editListItem(nodeType, id!, node);
          }
        } else {
          log('submittaxonomy***************  ');
          var node = await _nodeApiService.create(submitedNode);
          if (Get.isRegistered<NodeListController>()) {
            Get.find<NodeListController>().addListItem(node as NodeModel);
          }
        }
      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +
        log('Error occurred: ${err} {${nodeType}, ${titleController.text}, ${status.value}}');

        rethrow;
      } finally {
        if (!isEditing) clearFields();
      }
    } else {
      throw Exception('An error occurred, invalid inputs value');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    titleFocusNode.dispose();
    aliasController.dispose();
    aliasFocusNode.dispose();
    bodyController.dispose();
    bodyFocusNode.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    nodeFormKey.currentState!.dispose();
    super.dispose();
  }
}
