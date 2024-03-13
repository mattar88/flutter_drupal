import 'package:flutter/material.dart';
import '../../locale/config_locale.dart';
import '../../models/taxonomy/taxonomy_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../controllers/languages_controller.dart';
import '../../values/app_values.dart';

class TaxonomyTranslationsScreen extends StatelessWidget {
  final TaxonomyModel taxonomy;

  const TaxonomyTranslationsScreen({super.key, required this.taxonomy});
  @override
  Widget build(BuildContext context) {
    LanguagesController languagesController = Get.find();
    var T = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(T.translationsOf(taxonomy.name)),
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
                      .replaceAll(':vocabulary', taxonomy.vocabulary.toString())
                      .replaceAll(':id', taxonomy.id.toString()));
                },
                title: Text(ConfigLocale.supportedLocalesData[index].language),
              ),
            );
          }),
    );
  }
}
