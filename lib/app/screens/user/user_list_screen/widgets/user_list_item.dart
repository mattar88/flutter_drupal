import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../../config/config_locale.dart';
import '../../../../controllers/user/user_list_controller.dart';
import '../../../../mixins/helper_mixin.dart';
import '../../../../models/user_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../values/app_values.dart';

class UserListItem extends GetView<UserListController> {
  final UserModel user;
  const UserListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    var isRTL = HelperMixin.isDirectionRTL(context);
    return Card(
        child: Slidable(
            dragStartBehavior: DragStartBehavior.down,
            // Specify a key if the Slidable is dismissible.
            key: ValueKey(user.id),
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
                    label: T.cancel,
                    icon: Icons.delete,
                    backgroundColor: Theme.of(context).colorScheme.error,
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
                    onPressed: (context) {
                      // final slidableController = Slidable.of(context);
                      // FDDialog.delete(context,
                      //     deleteMessage: T.entityDeletedMessage(
                      //         'user', user.name!), onDeleted: () {
                      //   slidableController?.dismiss(
                      //     ResizeRequest(const Duration(milliseconds: 300), () {
                      //       controller.delete(user.id!).then((value) {
                      //         controller.deleteListItem(user.id!);
                      //       }).catchError((onError) {
                      //         controller.addMessage(
                      //             status: MessageStatus.error,
                      //             message: onError.toString());
                      //       });
                      //     }),
                      //     duration: const Duration(milliseconds: 300),
                      //   );
                      // }, onCanceled: () {
                      //   final controller = Slidable.of(context);
                      //   controller?.close(
                      //       duration: const Duration(milliseconds: 300));
                      // });
                    },
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
                      icon: Icons.translate,
                      label: T.translate,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      // borderRadius: BorderRadius.circular(30),
                      // autoClose: false,

                      onPressed: (BuildContext context) {},
                    ),
                  SlidableAction(
                    flex: 1,
                    label: T.edit,
                    icon: Icons.edit,
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                    onPressed: (BuildContext context) {
                      // var route = Routes.
                      //     .replaceAll(':nodeType', node.type.toString())
                      //     .replaceAll(':id', user.id.toString());

                      // Get.toNamed(route);
                    },
                  ),
                ]),
            child: ListTile(
              title: Text(user.displayName!),

              // isThreeLine: true,
              subtitle: Text(user.lastAccess),
              leading: const Icon(Icons.people_outline),
              trailing: (user.status != null && user.status!)
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Get.toNamed(
                    Routes.USER_VIEW.path.replaceAll(':id', user.id.toString()),
                    arguments: {'name': user.displayName});
              },
            )));
  }
}
