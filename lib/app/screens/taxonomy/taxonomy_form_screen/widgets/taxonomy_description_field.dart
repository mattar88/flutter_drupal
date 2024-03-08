import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../controllers/taxonomy/taxonomy_form_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaxonomyDescriptionField extends GetView<TaxonomyFormController> {
  final InputDecoration? fieldDescriptionDecoration;
  const TaxonomyDescriptionField(this.fieldDescriptionDecoration, {super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return TextFormField(
      key: controller.formDescriptionFieldKey,
      controller: controller.descriptionController,
      decoration: fieldDescriptionDecoration ??
          InputDecoration(
            icon: Icon(Icons.description),
            hintText: T.fieldDescription,
          ),
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: controller.descriptionFocusNode,
      maxLines: 3,
      validator: controller.descriptionValidator,
    );
  }
}
