import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../controllers/node/node_form_controller.dart';
import '../../../../models/node/node_model.dart';

class NodeTitleField extends StatelessWidget {
  const NodeTitleField(this.controller, {this.decoration, super.key});

  final NodeFormController controller;

  final InputDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;

    return TextFormField(
      key: controller.formTitleFieldKey,
      controller: controller.titleController,
      decoration: decoration ??
          InputDecoration(
            icon: Icon(Icons.title),
            hintText: T.title,
          ),
      focusNode: controller.titleFocusNode,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: controller.titleValidator,
    );
  }
}

// class NodeTitleField<T> extends GetView<NodeFormController<T>> {
//   final InputDecoration? decoration;

//   const NodeTitleField(this.decoration, {super.key});

//   @override
//   Widget build(BuildContext context) {
   
//     var T = AppLocalizations.of(context)!;
//     return TextFormField(
//       key: controller.formTitleFieldKey,
//       controller: controller.titleController,
//       decoration: decoration ??
//           InputDecoration(
//             icon: Icon(Icons.title),
//             hintText: T.title,
//           ),
//       focusNode: controller.titleFocusNode,
//       // autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: controller.titleValidator,
//     );
//   }
// }
