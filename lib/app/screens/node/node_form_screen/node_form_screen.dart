import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../controllers/node/node_form_controller.dart';
import '../../../mixins/helper_mixin.dart';
import '../../../models/enum/entity_action.dart';
import '../../../models/node/node_model.dart';
import '../../../values/app_values.dart';
import '../../../widgets/circuclar_indicator.dart';
import '../../base_screen.dart';
import 'widgets/node_action_buttons.dart';
import 'widgets/node_alias_field.dart';
import 'widgets/node_body_field.dart';
import 'widgets/node_status_field.dart';
import 'widgets/node_title_field.dart';

class NodeFormScreen extends BaseScreen<NodeFormController<NodeModel>> {
  final EntityAction action;
  final String? title;
  final InputDecoration? fieldTitleDecoration;
  final InputDecoration? fieldBodyDecoration;
  final InputDecoration? fieldAliasDecoration;

  NodeFormScreen(
    this.action, {
    this.title,
    this.fieldTitleDecoration,
    this.fieldBodyDecoration,
    this.fieldAliasDecoration,
    Key? key,
  }) : super(key: key);

  Widget spacer() {
    return const SizedBox(
      height: AppValues.formFieldsSpacer,
    );
  }

  @override
  Widget pageScaffold(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    var appBar = AppBar(
      title: Text(title ?? controller.title ?? T.node),
    );
    log('node form screen:  ');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: Obx(() {
        return (controller.initializing.value!)
            ? const CircularPageIndicator()
            : SingleChildScrollView(
                child: Form(
                    key: controller.nodeFormKey,
                    child: Container(
                      padding: AppValues.pagePadding,
                      height: HelperMixin.getBodyHeight(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NodeTitleField(controller,
                              decoration: fieldTitleDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          NodeBodyField(controller,
                              decoration: fieldBodyDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          NodeAliasField(controller,
                              decoration: fieldAliasDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          NodeStatusField(controller),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          NodeActionButtons(controller)
                        ],
                      ),
                    )));
      }),
    );
  }
}
