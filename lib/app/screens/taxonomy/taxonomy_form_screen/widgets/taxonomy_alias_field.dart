import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../controllers/taxonomy/taxonomy_form_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaxonomyAliasField extends GetView<TaxonomyFormController> {
  final InputDecoration? fieldAliasDecoration;
  const TaxonomyAliasField(this.fieldAliasDecoration, {super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Column(
      children: [
        TextFormField(
          key: controller.formAliasFieldKey,
          controller: controller.aliasController,
          decoration: fieldAliasDecoration ??
              InputDecoration(
                icon: Icon(Icons.link),
                hintText: T.fieldAlias,
              ),
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: controller.aliasFocusNode,
          maxLines: 1,
          validator: controller.aliasValidator,
        ),
        Text(
          T.fieldAliasDescription,
          style: new TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
