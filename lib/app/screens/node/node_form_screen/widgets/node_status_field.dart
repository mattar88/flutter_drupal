import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../access/access.dart';
import '../../../../controllers/node/node_form_controller.dart';

class NodeStatusField extends StatelessWidget {
  const NodeStatusField(this.controller, {super.key});
  final NodeFormController controller;
  @override
  Widget build(BuildContext context) {
    if (Access.administerNodes()) {
      var T = AppLocalizations.of(context)!;
      return Row(
        children: [
          Text(T.published),
          Switch(
            value: controller.status.value!,
            onChanged: controller.onChangeStatus,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
