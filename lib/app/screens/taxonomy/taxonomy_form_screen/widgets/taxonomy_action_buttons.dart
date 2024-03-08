import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../../controllers/taxonomy/taxonomy_form_controller.dart';
import '../../../../controllers/taxonomy/taxonomy_list_controller.dart';
import '../../../../dialogs/fd_dialog.dart';
import '../../../../models/enum/entity_action.dart';
import '../../../../models/enum/message_status.dart';
import '../../../../widgets/Loading_overlay.dart';

class TaxonomyActionButtons extends GetView<TaxonomyFormController> {
  TaxonomyActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    var editAction = controller.action == EntityAction.edit;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.save),
          label: Text(T.save), // <-- Text
          onPressed: () async {
            log('${controller.taxonomyFormKey.currentState}');
            if (controller.taxonomyFormKey.currentState!.validate()) {
              LoadingOverlay.show(message: T.submitting);
              try {
                var newTaxonomyName = controller.nameController.text;
                await controller.submit();

                controller.taxonomyFormKey.currentState!.save();
                log('response submit');
                LoadingOverlay.hide();
                controller.addMessage(
                    title: T.statusMessage,
                    message: editAction
                        ? T.entityUpdatedSuccessMessage(
                            'taxonomy', newTaxonomyName)
                        : T.entityCreatedSuccessMessage(
                            'taxonomy', newTaxonomyName));

                // Get.offAndToNamed(Routes.TAXONOMY_LIST.path
                //     .replaceAll(':vocabulary', controller.vocabulary));
                Get.back();
              } catch (err, _) {
                printError(info: err.toString());
                LoadingOverlay.hide();
                controller.addMessage(
                    status: MessageStatus.error, message: err.toString());
              } finally {}
            }
          },
        ),
        if (editAction)
          FilledButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            icon: const Icon(Icons.delete),
            label: Text(T.delete), // <-- Text
            onPressed: () async {
              var taxonomy = controller.taxonomy;
              FDDialog.delete(
                context,
                deleteMessage:
                    T.entityDeletedMessage('taxonomy', taxonomy!.name),
                onDeleted: () {
                  LoadingOverlay.show(message: T.submitting);

                  controller
                      .delete(taxonomy.vocabulary, taxonomy.id!)
                      .then((value) {
                    //Update taxonomy list before redirect ot it
                    if (Get.isRegistered<TaxonomyListController>()) {
                      Get.find<TaxonomyListController>()
                          .deleteListItem(taxonomy.id!);
                    }
                    LoadingOverlay.hide();
                    controller.addMessage(
                        message: T.entityDeletedSuccessMessage(
                            'taxonomy', taxonomy.name));

                    // Get.offAndToNamed('taxonomy/${controller.vocabulary}');
                    Get.back();
                  }).catchError((onError) {
                    LoadingOverlay.hide();
                    controller.addMessage(
                        status: MessageStatus.error,
                        message: T.entityDeletedErrorMessage(
                            'taxonomy', taxonomy.name));
                  });
                },
              );
            },
          ),
      ],
    );
  }
}
