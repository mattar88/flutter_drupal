import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../controllers/taxonomy/taxonomy_vocabulary_list_controller.dart';
import '../../routes/app_pages.dart';
import '../../screens/base_screen.dart';
import '../../values/app_values.dart';
import '../../widgets/skeleton/skeleton_list_view_card.dart';

class TaxonomyVocabularyListScreen
    extends BaseScreen<TaxonomyVocabularyListController> {
  TaxonomyVocabularyListScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.vocabulariesListTitle,
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
                              var vocabulary = controller.list[index];
                              Get.toNamed(
                                  Routes.TAXONOMY_LIST.path.replaceAll(
                                      ':vocabulary', vocabulary.machineName),
                                  arguments: {'title': vocabulary.name});
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
