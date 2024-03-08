import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../../controllers/taxonomy/taxonomy_form_controller.dart';
import '../../../../models/enum/entity_action.dart';
import '../../../../models/taxonomy/taxonomy_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaxonomyParentField extends GetView<TaxonomyFormController> {
  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    return Obx(() {
      bool defaultValueIsEmpty = controller.parent.value!.isEmpty;

      final _multiSelectKey = GlobalKey<FormFieldState>();
      return Container(
          decoration: defaultValueIsEmpty
              ? null
              : BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(
                      width: 1,
                      color: Colors.lightBlue,
                      style: BorderStyle.solid))),
          child: MultiSelectBottomSheetField<dynamic>(
            key: _multiSelectKey,
            cancelText: Text(T.cancel),
            confirmText: Text(T.confirm),
            initialValue: controller.parent.value!,
            itemsTextStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface),
            selectedItemsTextStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface),
            chipDisplay: MultiSelectChipDisplay(
              // icon: Icon(Icons.access_time_filled_outlined,
              //     color: Theme.of(context).colorScheme.onPrimary),
              // colorator: (p0) {
              //   return Colors.red;
              // },
              chipColor: Theme.of(context).colorScheme.primary,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),

            initialChildSize: 0.7,
            maxChildSize: 0.95,
            title: Text(T.parentTerm),
            buttonText:
                defaultValueIsEmpty ? Text(T.selectParent) : Text(T.relations),
            items: controller.relationsFieldOptions!
                .map((taxonomy) =>
                    MultiSelectItem<TaxonomyModel>(taxonomy, taxonomy.name))
                .toList(),
            searchable: true,
            validator: (values) {
              // if (values == null || values.isEmpty) {
              //   return "Required";
              // }
              // List<String> names = values.map((e) => e.name).toList();
              // if (names.contains("Frog")) {
              //   return "Frogs are weird!";
              // }
              return null;
            },
            onSelectionChanged: (values) {},
            onConfirm: (values) {
              controller.parent(values.cast<TaxonomyModel>());

              log('multiselct valuesss ${controller.parent}');
            },
            // chipDisplay: MultiSelectChipDisplay(
            //   onTap: (item) {},
            // ),
          ));
    });
  }
}
