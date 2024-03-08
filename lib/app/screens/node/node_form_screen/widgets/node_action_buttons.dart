import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../../widgets/Loading_overlay.dart';
import '../../../../controllers/node/node_form_controller.dart';
import '../../../../controllers/node/node_list_controller.dart';
import '../../../../dialogs/fd_dialog.dart';
import '../../../../models/enum/entity_action.dart';
import '../../../../models/enum/message_status.dart';

class NodeActionButtons extends StatelessWidget {
  NodeActionButtons(this.controller, {super.key});
  final NodeFormController controller;
  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    var editAction = controller.action == EntityAction.edit;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (editAction)
          FilledButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            icon: const Icon(Icons.delete),
            label: Text(T.delete), // <-- Text
            onPressed: () async {
              var node = controller.node;
              FDDialog.delete(
                context,
                deleteMessage: T.entityDeletedMessage('node', node!.title),
                onDeleted: () {
                  LoadingOverlay.show(message: T.submitting);
                  try {
                    controller.delete(node.type, node.id!).then((value) {
                      //Update node list before redirect ot it
                      if (Get.isRegistered<NodeListController>()) {
                        Get.find<NodeListController>().deleteListItem(node.id!);
                      }
                      LoadingOverlay.hide();
                      controller.addMessage(
                          message: T.entityDeletedSuccessMessage(
                              'node', node.title));

                      Get.back();
                    });
                  } catch (e) {
                    LoadingOverlay.hide();
                    controller.addMessage(
                        status: MessageStatus.error,
                        message:
                            T.entityDeletedErrorMessage('node', node.title));
                  }
                },
              );
            },
          ),
        FilledButton.icon(
          icon: const Icon(Icons.save),
          label: Text(T.save), // <-- Text
          onPressed: () async {
            log('${controller.nodeFormKey.currentState}');
            if (controller.nodeFormKey.currentState!.validate()) {
              LoadingOverlay.show(message: T.submitting);
              try {
                var newNodeTitle = controller.titleController.text;
                await controller.submit();

                controller.nodeFormKey.currentState!.save();
                // log('response submit,,,, ${Get.o}');
                LoadingOverlay.hide();
                controller.addMessage(
                    title: T.statusMessage,
                    message: editAction
                        ? T.entityUpdatedSuccessMessage('node', newNodeTitle)
                        : T.entityCreatedSuccessMessage('node', newNodeTitle));
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
      ],
    );
  }
}
