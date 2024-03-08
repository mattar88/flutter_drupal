import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../controllers/node/node_form_controller.dart';
import '../../../../controllers/taxonomy/taxonomy_form_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/node/article_model.dart';
import '../../../../models/node/node_model.dart';

class NodeBodyField extends StatelessWidget {
  final InputDecoration? decoration;
  final NodeFormController controller;
  const NodeBodyField(this.controller, {this.decoration, super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return TextFormField(
      key: controller.formBodyFieldKey,
      controller: controller.bodyController,
      decoration: decoration ??
          InputDecoration(
            icon: Icon(Icons.description),
            hintText: T.body,
          ),
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: controller.bodyFocusNode,
      maxLines: 3,
      validator: controller.bodyValidator,
    );
  }
}
