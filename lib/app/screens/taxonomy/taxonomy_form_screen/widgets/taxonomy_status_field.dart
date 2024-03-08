import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../controllers/taxonomy/taxonomy_form_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaxonomyStatusField extends GetView<TaxonomyFormController> {
  final Widget? fieldStatus;
  const TaxonomyStatusField(this.fieldStatus, {super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Obx(
      () => Row(
        children: [
          Text(T.published),
          Switch(
            value: controller.status.value!,
            onChanged: controller.onChangeStatus,
          ),
        ],
      ),
    );
  }
}
