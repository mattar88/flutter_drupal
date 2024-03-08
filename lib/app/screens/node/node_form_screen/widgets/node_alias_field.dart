import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../controllers/node/node_form_controller.dart';
import '../../../../models/node/article_model.dart';
import '../../../../models/node/node_model.dart';

class NodeAliasField extends StatelessWidget {
  final InputDecoration? decoration;
  final NodeFormController controller;
  const NodeAliasField(this.controller, {this.decoration, super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Column(
      children: [
        TextFormField(
          key: controller.formAliasFieldKey,
          controller: controller.aliasController,
          decoration: decoration ??
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
