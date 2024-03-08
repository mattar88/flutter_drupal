import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../../access/access.dart';
import '../../../../config/config_locale.dart';
import '../../../../controllers/taxonomy/taxonomy_list_controller.dart';
import '../../../../dialogs/fd_dialog.dart';
import '../../../../mixins/helper_mixin.dart';
import '../../../../models/taxonomy/taxonomy_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../screens/taxonomy/taxonomy_translations_screen.dart';
import '../../../../values/app_values.dart';

class TaxonomyListItem extends GetView<TaxonomyListController> {
  final TaxonomyModel taxonomy;
  const TaxonomyListItem(this.taxonomy, {super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    var isRTL = HelperMixin.isDirectionRTL(context);
    bool enabledEditAction =
        Routes.TAXONOMY_EDIT.access!(Operation.edit, taxonomy);
    bool enabledDeleteAction =
        Routes.TAXONOMY_DELETE.access!(Operation.delete, taxonomy);
    return Card(
        child: Slidable(
            dragStartBehavior: DragStartBehavior.down,
            // Specify a key if the Slidable is dismissible.
            key: ValueKey(taxonomy.id),
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
                    icon: Icons.delete,
                    label: T.delete,

                    backgroundColor: enabledDeleteAction
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.error.withOpacity(0.5),
                    borderRadius: isRTL
                        ? const BorderRadius.only(
                            topRight:
                                Radius.circular(AppValues.slidableActionRadius),
                            bottomRight:
                                Radius.circular(AppValues.slidableActionRadius),
                          )
                        : const BorderRadius.only(
                            topLeft:
                                Radius.circular(AppValues.slidableActionRadius),
                            bottomLeft:
                                Radius.circular(AppValues.slidableActionRadius),
                          ),
                    onPressed: enabledDeleteAction
                        ? (context) {
                            final slidableController = Slidable.of(context);
                            FDDialog.delete(context,
                                deleteMessage: T.entityDeletedMessage(
                                    'taxonomy', taxonomy.name), onDeleted: () {
                              slidableController?.dismiss(
                                ResizeRequest(const Duration(milliseconds: 300),
                                    () {
                                  controller
                                      .delete(taxonomy.vocabulary, taxonomy.id!)
                                      .then((value) {
                                    controller.deleteListItem(taxonomy.id!);
                                  });
                                }),
                                duration: const Duration(milliseconds: 300),
                              );
                            }, onCanceled: () {
                              final controller = Slidable.of(context);
                              controller?.close(
                                  duration: const Duration(milliseconds: 300));
                            });
                          }
                        : null,
                  ),
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      // borderRadius: BorderRadius.circular(30),
                      // autoClose: false,
                      icon: Icons.translate,
                      label: T.translate,
                      onPressed: (BuildContext context) {
                        Get.to(TaxonomyTranslationsScreen(taxonomy: taxonomy),
                            transition: Transition.noTransition);
                      },
                    ),
                  SlidableAction(
                    flex: 1,
                    backgroundColor: enabledEditAction
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                    icon: Icons.edit,
                    label: T.edit,
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
                            Get.toNamed(Routes.TAXONOMY_EDIT.path
                                .replaceAll(':vocabulary',
                                    taxonomy.vocabulary.toString())
                                .replaceAll(':id', taxonomy.id.toString()));
                          }
                        : null,
                  ),
                ]),
            child: ListTile(
              title: Text(taxonomy.name),
              isThreeLine: true,
              subtitle: Text(taxonomy.description ?? ''),
              leading: const Icon(Icons.tag),
              trailing: (taxonomy.status!) ? const Icon(Icons.check) : null,
              onTap: () {
                log('${taxonomy.id}');
                Get.toNamed(
                    Routes.TAXONOMY_VIEW.path
                        .replaceAll(
                            ':vocabulary', taxonomy.vocabulary.toString())
                        .replaceAll(':id', taxonomy.id.toString()),
                    arguments: {'title': taxonomy.name});
              },
            )));
  }
}
