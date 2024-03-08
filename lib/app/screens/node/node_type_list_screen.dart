import 'package:flutter/material.dart';
import '../../screens/base_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../controllers/node/node_type_list_controller.dart';
import '../../values/app_values.dart';
import '../../widgets/skeleton/skeleton_list_view_card.dart';

class NodeTypeListScreen extends BaseScreen<NodeTypeListController> {
  NodeTypeListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.nodeTypeList,
              ),
            ],
          ),
        ),
        body: Obx(() {
          return (controller.isLoading.value!)
              ? SkeletonListViewCard(
                  hasSubtitle: true,
                  hasLeading: false,
                  paddingContainer: AppValues.pagePadding,
                )
              : Container(
                  padding: AppValues.pagePadding,
                  child: ListView.builder(
                      itemCount: controller.list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              var nodeType = controller.list[index];
                              Get.toNamed(
                                  Routes.NODE_LIST.path.replaceAll(
                                      ':nodeType', nodeType.machineName),
                                  arguments: {'title': nodeType.name});
                            },
                            title: Text(controller.list[index].name),
                            subtitle: Text(controller.list[index].description!),
                          ),
                        );
                      }),
                );
        }));
  }
}
