import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../dialogs/fd_dialog.dart';
import '../../../../values/app_values.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../config/config_locale.dart';
import '../../../../controllers/node/node_list_controller.dart';
import '../../../../mixins/helper_mixin.dart';
import '../../../../models/enum/message_status.dart';
import '../../../../models/node/node_model.dart';
import '../../../../access/access.dart';
import '../../node_translations_screen.dart';

class NodeListItem extends GetView<NodeListController> {
  final NodeModel node;
  const NodeListItem(this.node, {super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    var isRTL = HelperMixin.isDirectionRTL(context);
    bool enabledEditAction = Routes.NODE_EDIT.access!(Operation.edit, node);
    bool enabledDeleteAction =
        Routes.NODE_DELETE.access!(Operation.delete, node);
    log('enabledEditAction: ${enabledEditAction}');
    return Card(
        child: Slidable(
            dragStartBehavior: DragStartBehavior.down,
            // Specify a key if the Slidable is dismissible.
            key: ValueKey(node.id),
            startActionPane: ActionPane(
                dragDismissible: false,
                // A motion is a widget used to control how the pane animates.
                motion: const BehindMotion(),

                // A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),

                // All actions are defined in the children parameter.
                children: [
                  SlidableAction(
                      // flex: 1,
                      // autoClose: false,
                      label: T.delete,
                      icon: Icons.delete,
                      backgroundColor: enabledDeleteAction
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.5),
                      borderRadius: isRTL
                          ? const BorderRadius.only(
                              topRight: Radius.circular(
                                  AppValues.slidableActionRadius),
                              bottomRight: Radius.circular(
                                  AppValues.slidableActionRadius),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(
                                  AppValues.slidableActionRadius),
                              bottomLeft: Radius.circular(
                                  AppValues.slidableActionRadius),
                            ),
                      onPressed: enabledDeleteAction
                          ? (context) {
                              final slidableController = Slidable.of(context);
                              FDDialog.delete(context,
                                  deleteMessage: T.entityDeletedMessage(
                                      'node', node.title), onDeleted: () {
                                slidableController?.dismiss(
                                  ResizeRequest(
                                      const Duration(milliseconds: 300), () {
                                    controller
                                        .delete(node.type, node.id!)
                                        .then((value) {
                                      controller.deleteListItem(node.id!);
                                    }).catchError((onError) {
                                      controller.addMessage(
                                          status: MessageStatus.error,
                                          message: onError.toString());
                                    });
                                  }),
                                  duration: const Duration(milliseconds: 300),
                                );
                              }, onCanceled: () {
                                final controller = Slidable.of(context);
                                controller?.close(
                                    duration:
                                        const Duration(milliseconds: 300));
                              });
                            }
                          : null),
                ]),
            // The start action pane is the one at the left or the top side.
            endActionPane: ActionPane(
                dragDismissible: false,
                // A motion is a widget used to control how the pane animates.
                motion: const BehindMotion(),

                // A pane can dismiss the Slidable.
                dismissible: DismissiblePane(onDismissed: () {}),

                // All actions are defined in the children parameter.
                children: [
                  if (ConfigLocale.supportedLocalesData.isEmpty)
                    SlidableAction(
                      flex: 1,
                      icon: Icons.translate,
                      label: T.translate,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      // borderRadius: BorderRadius.circular(30),
                      // autoClose: false,

                      onPressed: (BuildContext context) {
                        Get.to(NodeTranslationsScreen(node: node),
                            transition: Transition.noTransition);
                      },
                    ),
                  SlidableAction(
                    flex: 1,
                    label: T.edit,
                    icon: Icons.edit,
                    backgroundColor: enabledEditAction
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                    borderRadius: isRTL
                        ? const BorderRadius.only(
                            topLeft:
                                Radius.circular(AppValues.slidableActionRadius),
                            bottomLeft:
                                Radius.circular(AppValues.slidableActionRadius),
                          )
                        : const BorderRadius.only(
                            topRight:
                                Radius.circular(AppValues.slidableActionRadius),
                            bottomRight:
                                Radius.circular(AppValues.slidableActionRadius),
                          ),
                    onPressed: enabledEditAction
                        ? (BuildContext context) {
                            var route = Routes.NODE_EDIT.path
                                .replaceAll(':nodeType', node.type.toString())
                                .replaceAll(':id', node.id.toString());
                            log('node.Edit.....${node.id}, Routee: ${route}');
                            Get.toNamed(route);
                          }
                        : null,
                  ),
                ]),
            child: ListTile(
              title: Text(node.title),
              isThreeLine: true,
              subtitle: Text(node.body ?? ''),
              leading: const Icon(Icons.tag),
              trailing: (node.status!) ? const Icon(Icons.check) : null,
              onTap: Routes.NODE_VIEW.access!()
                  ? () {
                      log('node......${node.id}');
                      Get.toNamed(
                          Routes.NODE_VIEW.path
                              .replaceAll(':nodeType', node.type.toString())
                              .replaceAll(':id', node.id.toString()),
                          arguments: {'title': node.title});
                    }
                  : null,
            )));
  }
}
