import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../mixins/helper_mixin.dart';
import 'package:get/get.dart';

import '../../../controllers/taxonomy/taxonomy_form_controller.dart';
import '../../../models/enum/entity_action.dart';
import '../../../widgets/circuclar_indicator.dart';
import '../../../values/app_values.dart';
import '../../base_screen.dart';
import 'widgets/taxonomy_action_buttons.dart';
import 'widgets/taxonomy_alias_field.dart';
import 'widgets/taxonomy_description_field.dart';
import 'widgets/taxonomy_name_field.dart';
import 'widgets/taxonomy_parent_field.dart';
import 'widgets/taxonomy_status_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaxonomyFormScreen extends BaseScreen<TaxonomyFormController> {
  final EntityAction action;
  final String? title;
  final InputDecoration? fieldNameDecoration;
  final InputDecoration? fieldDescriptionDecoration;
  final InputDecoration? fieldAliasDecoration;
  final Widget? fieldStatus;

  TaxonomyFormScreen(
    this.action, {
    this.title,
    this.fieldNameDecoration,
    this.fieldDescriptionDecoration,
    this.fieldAliasDecoration,
    this.fieldStatus,
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
      title: Text(title ?? controller.title ?? T.taxonomy),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: Obx(() {
        return (controller.initializing.value!)
            ? const CircularPageIndicator()
            : SingleChildScrollView(
                child: Form(
                    key: controller.taxonomyFormKey,
                    child: Container(
                      padding: AppValues.pagePadding,
                      height: HelperMixin.getBodyHeight(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TaxonomyNameField(fieldNameDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          TaxonomyDescriptionField(fieldDescriptionDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          TaxonomyAliasField(fieldAliasDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          TaxonomyParentField(),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          TaxonomyStatusField(fieldStatus),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          TaxonomyActionButtons()
                        ],
                      ),
                    )));
      }),
    );
  }
}
