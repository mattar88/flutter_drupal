import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../controllers/taxonomy/taxonomy_form_controller.dart';

class TaxonomyNameField extends GetView<TaxonomyFormController> {
  final InputDecoration? fieldNameDecoration;

  const TaxonomyNameField(this.fieldNameDecoration, {super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return TextFormField(
      key: controller.formNameFieldKey,
      controller: controller.nameController,
      decoration: fieldNameDecoration ??
          InputDecoration(
            icon: Icon(Icons.tag),
            hintText: T.fieldName,
          ),
      focusNode: controller.nameFocusNode,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: controller.nameValidator,
    );
  }
}
