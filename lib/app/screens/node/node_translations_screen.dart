import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../..../../../routes/app_pages.dart';
import '../../locale/config_locale.dart';
import '../../controllers/languages_controller.dart';
import '../../models/node/node_model.dart';
import '../../values/app_values.dart';

class NodeTranslationsScreen extends StatelessWidget {
  final NodeModel node;

  const NodeTranslationsScreen({super.key, required this.node});
  @override
  Widget build(BuildContext context) {
    LanguagesController languagesController = Get.find();
    var T = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(T.translationsOf(node.title)),
          ],
        ),
      ),
      body: ListView.builder(
          padding: AppValues.pagePadding,
          itemCount: ConfigLocale.supportedLocalesData.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  var locale = ConfigLocale.supportedLocalesData[index].locale;
                  languagesController.onChanged(locale);
                  Get.toNamed(Routes.TAXONOMY_EDIT.path
                      .replaceAll(':vocabulary', node.type.toString())
                      .replaceAll(':id', node.id.toString()));
                },
                title: Text(ConfigLocale.supportedLocalesData[index].language),
              ),
            );
          }),
    );
  }
}
